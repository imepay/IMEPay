//
//  ConfirmPaymentViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "PinConfirmPaymentViewController.h"
#import "IMPApiManager.h"
#import "UIViewController+Extensions.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "OTPConfirmationViewController.h"
#import "Helper.h"

@interface PinConfirmPaymentViewController () <UITextFieldDelegate>

//MARK:- API Manager

@property (nonatomic, strong) IMPApiManager *apiManager;

//MARK:- States

@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, assign) BOOL isFailedForFirstTime;

@end

@implementation PinConfirmPaymentViewController

#define PIN_FIELD_PLACEHOLER @"Enter your PIN"

#pragma mark:- VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addLogoTitle];

    [self setupUI];
    _apiManager = [IMPApiManager new];

    _pinField.delegate = self;
    _isFailedForFirstTime = YES;
    IQKeyboardManager.sharedManager.enable = YES;
    [_pinField setThemedPlaceholder:PIN_FIELD_PLACEHOLER];
}

- (void)setupUI {
    _mobileNumberLabel.text = _paymentParams[@"mobileNumber"];
    _amountLabel.text = _paymentParams [@"amount"];
    _merchantNameLabel.text = _paymentParams[@"merchantName"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- IBAction

- (IBAction)confirm:(id)sender {

    [self.view endEditing:YES];
    if (_pinField.text.length == 0 || _pinField.text.length < 4) {
        [self showAlert:@"" message:@"Please enter valid PIN (4 digits)" okayHandler:nil];
        return;
    }
    [self gotoOTPConfirmation];
}

#pragma mark:- Dissmiss and notify

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

#pragma mark:- Goto OTP Confirmation

- (void)gotoOTPConfirmation {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    
    OTPConfirmationViewController *mobileNumVc = (OTPConfirmationViewController *) [sb instantiateViewControllerWithIdentifier:@"OTPConfirmationViewController"];
    mobileNumVc.PIN = _pinField.text;
    mobileNumVc.paymentParams = _paymentParams;
    mobileNumVc.success  = _successBlock;
    mobileNumVc.failure = _failureBlock;

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mobileNumVc];
    nav.navigationBar.tintColor = UIColor.blackColor;

    [self presentViewController:nav animated:YES completion:nil];
}

@end
