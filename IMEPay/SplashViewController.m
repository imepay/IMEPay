//
//  SplashViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "SplashViewController.h"
#import "IMPApiManager.h"
#import "ConfirmPaymentViewController.h"
#import "Helper.h"
#import "UIViewController+Alert.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SplashViewController ()

@property (nonatomic, strong) IMPApiManager *apiManager;

@end

@implementation SplashViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _logoView.alpha = 0.0;
    _apiManager = [IMPApiManager new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmiss) name:NOTIF_SHOULD_QUIT_SPLASH object:nil];
    [self fetchToken];
}

- (void)dissmiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        _logoView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fetchToken {
    
    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              };
    [SVProgressHUD showWithStatus:@"Preparing for payment.."];
    [_apiManager getToken:params success:^(NSDictionary *tokenInfo) {
        NSString *tokenId = tokenInfo[@"TokenId"];
        [_paymentParams setValue:tokenId forKey:@"token"];
        [self postToMerchant];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmiss];
        } tryAgainHandler:^{
            [self fetchToken];
        }];
    }];
}

- (void)postToMerchant {
    
    NSDictionary *params = @{ @"TokenId": _paymentParams[@"token"],
                              @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"ReferenceId" : _paymentParams[@"referenceId"],
                              @"merchantUrl": _paymentParams[@"merchantUrl"]
                              };
    
    [_apiManager postToMerchant:params success:^{
        
        [SVProgressHUD dismiss];
        NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];

        ConfirmPaymentViewController *paymentVc = (ConfirmPaymentViewController *) [sb instantiateViewControllerWithIdentifier:@"ConfirmPaymentViewController"];
        paymentVc.paymentParams = _paymentParams;
        
        paymentVc.successBlock = _successBlock;
        paymentVc.failureBlock = _failureBlock;
        
        [topViewController() presentViewController:paymentVc animated:YES completion:nil];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmiss];
        } tryAgainHandler:^{
            [self fetchToken];
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
