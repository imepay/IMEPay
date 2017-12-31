//
//  OTPConfirmationViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "OTPConfirmationViewController.h"
#import "IMPApiManager.h"
#import "UIViewController+Alert.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface OTPConfirmationViewController ()

//MARK:- API MANAGER

@property (nonatomic, strong) IMPApiManager *apiManager;

//MARK:- STATES

@property (nonatomic, strong) NSString *OTP;

@property (nonatomic, strong) NSString *transactionId;

@property (nonatomic, assign) BOOL isFailedForFirstTime;

@end

@implementation OTPConfirmationViewController

#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _apiManager = [IMPApiManager new];
    [self validateUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- IBAction

- (IBAction)confirmClicked:(id)sender {
    [self makePayment];
}

#pragma mark:- User Validation API Call

- (void)validateUser {
    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Pin" : _PIN,
                              @"Msisdn" : _paymentParams[@"mobileNumber"]
                              };
    [SVProgressHUD showWithStatus:@"Validating.."];
    
    [_apiManager validateUser:params success:^(NSString *PIN) {
         [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
          [SVProgressHUD dismiss];
    }];
    
    [_apiManager confirmPayment:params success:^(NSDictionary *info) {

        NSNumber *responseCode = info[@"ResponseCode"];
        NSString *title = responseCode.integerValue == 0 ? @"Sucess!" : @"Sorry!";
        
        [self showAlert:title message:info[@"ResponseDescription"] okayHandler:^{
            //[self dissmissAndNotify];
        }];
        
//        if (responseCode.integerValue == 0) {
//            if (_successBlock)
//                _successBlock(info);
//        }else {
//            if (_failureBlock)
//                _failureBlock(info);
//        }
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
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
    [SVProgressHUD showWithStatus:@"Processing payment.."];
    [_apiManager makePayment:params success:^(NSDictionary *info) {
        [SVProgressHUD dismiss];
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
    [SVProgressHUD showWithStatus:@"Processing payment.."];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(confirmPayment) userInfo:nil repeats:NO];
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
            if (_success)
                _success(info);
        }else {
            if (_failure)
                _failure(info);
        }
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        if (_isFailedForFirstTime){
            _isFailedForFirstTime = NO;
            [self setUpTimer];
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


@end
