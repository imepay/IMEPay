//
//  OTPConfirmationViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "OTPConfirmationViewController.h"
#import "IMPApiManager.h"
#import "UIViewController+Extensions.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "PinConfirmPaymentViewController.h"
#import "TransactionResultViewController.h"

@interface OTPConfirmationViewController ()<UITextFieldDelegate>

//MARK:- API MANAGER

@property (nonatomic, strong) IMPApiManager *apiManager;

//MARK:- STATES


@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, assign) BOOL isFailedForFirstTime;

@end

@implementation OTPConfirmationViewController

#define OTP_FIELD_PLACEHOLDER @"Enter OTP"

#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLogoTitle];
    [self addDissmissButton];

    [_otpField setThemedPlaceholder:OTP_FIELD_PLACEHOLDER];

    _apiManager = [IMPApiManager new];
    _otpField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- IBAction

- (IBAction)confirmClicked:(id)sender {

    [self.view endEditing:YES];
    if ([_OTP isEqualToString:_otpField.text]) {
       [self makePayment];
        return;
    }

    NSString *mobileNumber = _paymentParams[@"mobileNumber"];
    [self showAlert:@"Invalid OTP!" message:[NSString stringWithFormat:@"Please Enter the One Time Password sent to %@", mobileNumber] okayHandler:^{
    }];
}

#pragma mark:- Dissmissal and Notification

- (void)dissmissAndNotify {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_SHOULD_QUIT object:nil];
    }];
}

#pragma mark:- Payment and confirmation

- (void)makePayment {
    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              @"TokenId": _paymentParams[@"token"],
                              @"Pin" : _PIN,
                              @"Msisdn" : _paymentParams[@"mobileNumber"]
                              };

    [self showHud:@"Performing payment.."];

    [_apiManager makePayment:params success:^(NSDictionary *info) {
        [self dissmissHud];
        self.transactionId = info[@"TransactionId"];
        NSNumber *responseCode = info[@"ResponseCode"];
        NSString *title = responseCode.integerValue == 0 ? @"Success!" : @"Sorry!";

        [self showAlert:title message:info[@"ResponseDescription"] okayHandler:^{
            [self gotoFinalPage:info];
        }];

//        if (responseCode.integerValue == 0) {
//            if (self.success)
//                self.success(info);
//        }else {
//            if (self.failure)
//                self.failure(info);
//        }
    } failure:^(NSString *error) {
        [self dissmissHud];
        [self showTryAgain:@"Error!" message:error cancelHandler:^{
        } tryAgainHandler:^{
            [self makePayment];
        }];
    }];
}

//- (void)setUpTimer {
//    [SVProgressHUD showWithStatus:@"Processing payment.."];
//    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(confirmPayment) userInfo:nil repeats:NO];
//}

//- (void)confirmPayment {
//    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
//                              @"TransactionId" : _transactionId,
//                              @"Amount" : _paymentParams[@"amount"],
//                              @"RefId" : _paymentParams[@"referenceId"],
//                              @"Msisdn" : _paymentParams[@"mobileNumber"]
//                              };
//    [SVProgressHUD showWithStatus:@"Confirming.."];
//    [_apiManager confirmPayment:params success:^(NSDictionary *info) {
//        [SVProgressHUD dismiss];
//
//    } failure:^(NSString *error) {
//        [SVProgressHUD dismiss];
//        if (self.isFailedForFirstTime){
//            self.isFailedForFirstTime = NO;
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

#pragma mark:- UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return newString.length <= PIN_MAX_LENGTH;
}

#pragma mark:- Goto Success Page

- (void)gotoFinalPage :(NSDictionary *)info {

    NSLog(@"transaction info before final result view %@", info);

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    TransactionResultViewController *resultVc = (TransactionResultViewController *) [sb instantiateViewControllerWithIdentifier:@"TransactionResultViewController"];
    resultVc.transactionInfo = info;
    resultVc.paymentParams = self.paymentParams;

    UINavigationController *resultNav = [[UINavigationController alloc]initWithRootViewController:resultVc];

    resultVc.failure = self.failure;
    resultVc.success  = self.success;


    [self.navigationController presentViewController:resultNav animated:true completion:nil];
}

@end
