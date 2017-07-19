//
//  ConfirmPaymentViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "IMPApiManager.h"
#import "UIViewController+Alert.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#define PIN_MAX_LENGTH 4

@interface ConfirmPaymentViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IMPApiManager *apiManager;
@property (nonatomic, strong) NSString *transactionId;

@property (nonatomic, assign) BOOL isFailedForFirstTime;

@end

@implementation ConfirmPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _apiManager = [IMPApiManager new];
    IQKeyboardManager.sharedManager.enable = YES;
    [self setupUI];
    _pinField.delegate = self;
    _isFailedForFirstTime = YES;
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

- (IBAction)confirm:(id)sender {
    
    if (_pinField.text.length == 0) {
        [self showAlert:@"Oops!" message:@"Pin is empty!" okayHandler:nil];
        return;
    }
    if (_pinField.text.length > 4) {
        [self showAlert:@"Oops!" message:@"Pin must be 4 digits!" okayHandler:nil];
        return;
    }
    
    [self makePayment];
    
}

- (void)makePayment {
    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              @"TokenId": _paymentParams[@"token"],
                              @"Pin" : _pinField.text,
                              @"Msisdn" : _paymentParams[@"mobileNumber"]
                              };
    [SVProgressHUD showWithStatus:@"Processing payment.."];
    [_apiManager makePayment:params success:^(NSDictionary *info) {
        [SVProgressHUD dismissWithDelay:2];
        _transactionId = info[@"TransactionId"];
        [self setUpTimer];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmissAndNotify];
        } tryAgainHandler:^{
            [self makePayment];
        }];
    }];
}

- (void)setUpTimer {
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(confirmPayment) userInfo:nil repeats:NO];
}


- (void)confirmPayment {
    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"TransactionId" : _transactionId,
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              @"Msisdn" : _paymentParams[@"mobileNumber"]
                              };
    [SVProgressHUD showWithStatus:@"Confirming.."];
    [_apiManager confirmPayment:params success:^(NSDictionary *info) {
        [SVProgressHUD dismiss];
        
        NSNumber *responseCode = info[@"ResponseCode"];
        NSString *title = responseCode.integerValue == 0 ? @"Sucess!" : @"Sorry!";
    
        [self showAlert:title message:info[@"ResponseDescription"] okayHandler:^{
            [self dissmissAndNotify];
        }];
        
        if (responseCode.integerValue == 0) {
           if (_successBlock)
            _successBlock(info);
        }else {
           if (_failureBlock)
            _failureBlock(info);
        }
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];

        if (_isFailedForFirstTime){
            _isFailedForFirstTime = NO;
            [self confirmPayment];
            return;
        }

        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmissAndNotify];
        } tryAgainHandler:^{
            [self confirmPayment];
        }];
    }];
}

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

@end
