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

@interface ConfirmPaymentViewController ()

@property (nonatomic, strong) IMPApiManager *apiManager;
@property (nonatomic, strong) NSString *transactionId;

@end

@implementation ConfirmPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _apiManager = [IMPApiManager new];
    IQKeyboardManager.sharedManager.enable = YES;
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
        [SVProgressHUD dismiss];
        _transactionId = info[@"TransactionId"];
        [self confirmPayment:_transactionId];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmissAndNotify];
        } tryAgainHandler:^{
            [self makePayment];
        }];
    }];
}

- (void)confirmPayment: (NSString *)trasactionId {

    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"TransactionId" : trasactionId,
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              @"Msisdn" : _paymentParams[@"mobileNumber"]
                              };
    [SVProgressHUD showWithStatus:@"Confirming.."];
    [_apiManager confirmPayment:params success:^(NSDictionary *info) {
        [SVProgressHUD dismiss];
        [self showAlert:@"Success!" message:@"" okayHandler:^{
            [self dissmissAndNotify];
        }];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmissAndNotify];        } tryAgainHandler:^{
            [self confirmPayment:_transactionId];
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

@end
