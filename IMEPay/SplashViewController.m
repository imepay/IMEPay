//
//  SplashViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "SplashViewController.h"
#import "IMPApiManager.h"
#import "PinConfirmPaymentViewController.h"
#import "Helper.h"
#import "UIViewController+Extensions.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SplashViewController ()

//MARK:- API Manager

@property (nonatomic, strong) IMPApiManager *apiManager;

@end

@implementation SplashViewController

#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    _apiManager = [IMPApiManager new];
    [self fetchToken];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
         self.logoView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    _logoView.alpha = 0.0;
}

#pragma mark:- Vc Dissmissal

- (void)dissmiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
