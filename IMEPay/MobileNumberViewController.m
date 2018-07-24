//
//  MobileNumberViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "MobileNumberViewController.h"
#import "UIViewController+Alert.h"
#import "IMPPaymentManager.h"
#import "SplashViewController.h"
#import "Helper.h"

@interface MobileNumberViewController ()

@end

@implementation MobileNumberViewController

#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //MARK:- Should Dissmiss Notification

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmiss) name:NOTIF_SHOULD_QUIT_SPLASH object:nil];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _confirmBtn.layer.cornerRadius = _confirmBtn.frame.size.height /  2.0;
}

- (void)setupUI {

    UIView *leftPaddingView = [[UIView alloc]initWithFrame:CGRectMake(_mobileNumebrField.frame.origin.x, _mobileNumebrField.frame.origin.y, 10.0, _mobileNumebrField.frame.size.height)];
    _mobileNumebrField.leftView = leftPaddingView;
    _mobileNumebrField.leftViewMode = UITextFieldViewModeAlways;

    //ScrollView ContentSize

    //[_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, 350.0)];
}

#pragma mark:- Vc Dissmissal

- (void)dissmiss {
    //[topViewController() dismissViewControllerAnimated:true completion:nil];
}

#pragma marK:- IBAction

- (IBAction)confirmCickced:(id)sender {
    
    [_mobileNumebrField resignFirstResponder];

    if  (_mobileNumebrField.text.length  == 0 ) {
        [self showAlert: nil message:@"Mobile Number Field is empty" okayHandler:^{}];
        return;
    }

    if (_mobileNumebrField.text.length != 10) {
        
        [self showAlert: nil message:@"Mobile Number Should be 10 Digits" okayHandler:^{}];
        return;
    }

    NSString *mobNum = self.mobileNumebrField.text;
    _paymentParams[@"mobileNumber"] = mobNum;
    [self gotoSplash];
}

#pragma mark:- Goto Splash

- (void)gotoSplash {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    
    SplashViewController *splashVc = (SplashViewController *) [sb instantiateViewControllerWithIdentifier:@"SplashViewController"];
    splashVc.paymentParams = _paymentParams;
    splashVc.successBlock = _success;
    splashVc.failureBlock = _failure;
    [topViewController() presentViewController:splashVc animated:YES completion:nil];
}

@end
