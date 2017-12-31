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

@property (nonatomic, strong) NSString *OTP;

@property (nonatomic, strong) IMPApiManager *apiManager;

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

- (IBAction)confirmClicked:(id)sender {

}

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

@end
