//
//  ConfirmPaymentViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "PinConfirmPaymentViewController.h"
#import "IMPApiManager.h"
#import "UIViewController+Alert.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "OTPConfirmationViewController.h"
#import "Helper.h"



@interface PinConfirmPaymentViewController () <UITextFieldDelegate>

//MARK:- API Manager

@property (nonatomic, strong) IMPApiManager *apiManager;

//MARK:- States

@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, assign) BOOL isFailedForFirstTime;

@end

@implementation PinConfirmPaymentViewController

#pragma mark:- VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];

    _apiManager = [IMPApiManager new];
    
    _pinField.delegate = self;
    _isFailedForFirstTime = YES;

    IQKeyboardManager.sharedManager.enable = YES;
}

- (void)setupUI {
    _mobileNumberLabel.text = _paymentParams[@"mobileNumber"];
    _amountLabel.text = _paymentParams [@"amount"];
    _merchantNameLabel.text = _paymentParams[@"merchantName"];
    
    UIView *leftPaddingView = [[UIView alloc]initWithFrame:CGRectMake(_pinField.frame.origin.x, _pinField.frame.origin.y, 10.0, _pinField.frame.size.height)];
    _pinField.leftView = leftPaddingView;
    _pinField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- IBAction

- (IBAction)confirm:(id)sender {

    [self.view endEditing:YES];

    if (_pinField.text.length == 0 || _pinField.text.length < 4) {
        [self showAlert:@"" message:@"Please enter valid PIN (4 digits)" okayHandler:nil];
        return;
    }

    [self gotoOTPConfirmation];
}

//- (void)makePayment {
//    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
//                              @"Amount" : _paymentParams[@"amount"],
//                              @"RefId" : _paymentParams[@"referenceId"],
//                              @"TokenId": _paymentParams[@"token"],
//                              @"Pin" : _pinField.text,
//                              @"Msisdn" : _paymentParams[@"mobileNumber"]
//                              };
//    [SVProgressHUD showWithStatus:@"Processing payment.."];
//    [_apiManager makePayment:params success:^(NSDictionary *info) {
//        [SVProgressHUD dismiss];
//        _transactionId = info[@"TransactionId"];
//        [self setUpTimer];
//    } failure:^(NSString *error) {
//        [SVProgressHUD dismiss];
//        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
//            [self dissmissAndNotify];
//        } tryAgainHandler:^{
//            [self makePayment];
//        }];
//    }];
//}
//
//- (void)setUpTimer {
//    [SVProgressHUD showWithStatus:@"Processing payment.."];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(confirmPayment) userInfo:nil repeats:NO];
//}
//
//
//- (void)confirmPayment {
//
//    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
//                              @"TransactionId" : _transactionId,
//                              @"Amount" : _paymentParams[@"amount"],
//                              @"RefId" : _paymentParams[@"referenceId"],
//                              @"Msisdn" : _paymentParams[@"mobileNumber"]
//                              };
//    [SVProgressHUD showWithStatus:@"Confirming.."];
//
//    [_apiManager confirmPayment:params success:^(NSDictionary *info) {
//        [SVProgressHUD dismiss];
//        NSNumber *responseCode = info[@"ResponseCode"];
//        NSString *title = responseCode.integerValue == 0 ? @"Sucess!" : @"Sorry!";
//
//        [self showAlert:title message:info[@"ResponseDescription"] okayHandler:^{
//            [self dissmissAndNotify];
//        }];
//
//        if (responseCode.integerValue == 0) {
//           if (_successBlock)
//            _successBlock(info);
//        }else {
//           if (_failureBlock)
//            _failureBlock(info);
//        }
//    } failure:^(NSString *error) {
//        [SVProgressHUD dismiss];
//        if (_isFailedForFirstTime){
//            _isFailedForFirstTime = NO;
//            [self setUpTimer];
//            return;
//        }
//
//        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
//            [self dissmissAndNotify];
//        } tryAgainHandler:^{
//            [self confirmPayment];
//        }];
//    }];
//}
//

#pragma mark:- Dissmiss and notify

- (void)dissmissAndNotify {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_SHOULD_QUIT_SPLASH object:nil];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dissmissAndNotify];
}

#pragma mark:- UITextField Delegates 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return newString.length <= PIN_MAX_LENGTH;
}

#pragma mark:- Goto OTP Confirmation

- (void)gotoOTPConfirmation {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    
    OTPConfirmationViewController *mobileNumVc = (OTPConfirmationViewController *) [sb instantiateViewControllerWithIdentifier:@"OTPConfirmationViewController"];
    mobileNumVc.PIN = _pinField.text;
    mobileNumVc.paymentParams = _paymentParams;
    mobileNumVc.success  = _successBlock;
    mobileNumVc.failure = _failureBlock;
    [topViewController() presentViewController:mobileNumVc animated:YES completion:nil];
}

@end
