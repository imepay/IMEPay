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

@interface SplashViewController ()

@property (nonatomic, strong) IMPApiManager *apiManager;

@end

@implementation SplashViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _logoView.alpha = 0.0;
    _apiManager = [IMPApiManager new];
    [self fetchToken];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        _logoView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fetchToken {
    
    [_indicator startAnimating];
    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              };
    [_apiManager getToken:params success:^(NSDictionary *tokenInfo) {
        
        NSString *tokenId = tokenInfo[@"TokenId"];
        [_paymentParams setValue:tokenId forKey:@"token"];
        [self postToMerchant];
    } failure:^(NSString *error) {
        [_indicator stopAnimating];
        
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dismissViewControllerAnimated:YES completion:nil];
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
                              };
    [_apiManager postToMerchant:params success:^{
        [_indicator stopAnimating];
        NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
        
        ConfirmPaymentViewController *paymentVc = (ConfirmPaymentViewController *) [sb instantiateViewControllerWithIdentifier:@"ConfirmPaymentViewController"];
        paymentVc.paymentParams = _paymentParams;
        [topViewController() presentViewController:paymentVc animated:YES completion:nil];
    } failure:^(NSString *error) {
       [_indicator stopAnimating];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dismissViewControllerAnimated:YES completion:nil];
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
