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
#define CURRENCY_PREFIX @"Rs."

#pragma mark:- VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLogoTitle];
    [self addCancelButtonWithAlert];
    [self setupUI];

    _apiManager = [IMPApiManager new];
    _pinField.delegate = self;
    _isFailedForFirstTime = YES;
}

#pragma mark:- Setup UI

- (void)setupUI {
    _mobileNumberLabel.text = _paymentParams[@"mobileNumber"];
    _amountLabel.text = [NSString stringWithFormat:@"%@ %@", CURRENCY_PREFIX, _paymentParams [@"amount"]];
    _merchantNameLabel.text = _paymentParams[@"merchantName"];

    [_pinField setThemedPlaceholder:PIN_FIELD_PLACEHOLER];
    _infoContainer.layer.cornerRadius = 5.0;
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
    [self requestOTP];
}

#pragma mark:- Request OTP

- (void)requestOTP {

    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Pin" : _pinField.text,
                              @"Msisdn" : _paymentParams[@"mobileNumber"]
                              };
    NSLog(@"request OTP user params %@", params);
    [self showHud:@""];

    [_apiManager validateUser:params success:^(NSString *OTP) {
        NSLog(@"OTP RECEIVED %@", OTP);
        [self dissmissHud];
        [self gotoOTPConfirmation:OTP];
    } failure:^(NSString *error) {
        [self dissmissHud];
        [self showAlert:@"Error!" message:error okayHandler:^{}];
    }];
}

#pragma mark:- Goto OTP Confirmation

- (void)gotoOTPConfirmation: (NSString *)otp {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    
    OTPConfirmationViewController *otpValidationVc = (OTPConfirmationViewController *) [sb instantiateViewControllerWithIdentifier:@"OTPConfirmationViewController"];
    otpValidationVc.PIN = _pinField.text;
    otpValidationVc.paymentParams = _paymentParams;
    otpValidationVc.OTP = otp;
    otpValidationVc.success  = _successBlock;
    otpValidationVc.failure = _failureBlock;

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:otpValidationVc];
    nav.navigationBar.tintColor = UIColor.blackColor;
    [self presentViewController:nav animated:true completion:nil];
}

#pragma mark:- UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return newString.length <= PIN_MAX_LENGTH;
}

@end
