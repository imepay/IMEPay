//
//  MobileNumberViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "MobileNumberViewController.h"
#import "UIViewController+Extensions.h"
#import "IMPPaymentManager.h"
#import "SplashViewController.h"
#import "Helper.h"

#define MOBILE_NUMBER_LENGTH 10

@interface MobileNumberViewController()<UITextFieldDelegate>

@end

#pragma mark:- MobileNumberViewController implementation

@implementation MobileNumberViewController



#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //MARK:- Should Dissmiss Notification

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmissVc) name:NOTIF_SHOULD_QUIT_SPLASH object:nil];
    [self setupUI];
    _mobileNumebrField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [self addCancelButton];
    _confirmBtn.layer.cornerRadius = _confirmBtn.frame.size.height /  2.0;
    [_mobileNumebrField addStandardLeftPadding];
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

#pragma mark:- UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (string.length == 0) {
        return YES;
    }
    return range.location < MOBILE_NUMBER_LENGTH;
}

@end
