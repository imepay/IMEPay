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
#import "IMPApiManager.h"
#import "PinConfirmPaymentViewController.h"
@import SVProgressHUD;

#define MOBILE_NUMBER_LENGTH 10

@interface MobileNumberViewController()<UITextFieldDelegate>

@property (nonatomic, strong) IMPApiManager *apiManager;

@end

#pragma mark:- MobileNumberViewController implementation

@implementation MobileNumberViewController

#define MOBILENUM_FIELD_PLACEHOLDER @"Mobile Number"
#define COUNTRY_CODE @"+977"

#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

    //MARK:- Should Dissmiss Notification

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmissAll) name:NOTIF_SHOULD_QUIT object:nil];

    _mobileNumebrField.delegate = self;
    _apiManager = [IMPApiManager new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addLogoTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- Dissmiss Entire SDK

- (void)dissmissAll {
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark:- Setup UI

- (void)setupUI {
    [self addCancelButton];
    _confirmBtn.layer.cornerRadius = _confirmBtn.frame.size.height /  2.0;
    [_mobileNumebrField setThemedPlaceholder:MOBILENUM_FIELD_PLACEHOLDER];
}

#pragma marK:- IBAction

- (IBAction)confirmCickced:(id)sender {

    [_mobileNumebrField resignFirstResponder];

    if  (_mobileNumebrField.text.length  == 0 ) {
        [self showAlert: @"Alert!" message:@"Mobile Number Field is empty" okayHandler:^{}];
        return;
    }

    if (_mobileNumebrField.text.length != 10) {
        
        [self showAlert: @"Alert!" message:@"Mobile Number should be 10 digits" okayHandler:^{}];
        return;
    }
    [self showMobileNumberConfirmationAlert];
}

#pragma mark:- Helper Methods

- (NSString *)formattedMobileNumber {

    NSString *mobileNumber = [NSString stringWithFormat:@"%@ %@", COUNTRY_CODE, _mobileNumebrField.text];
    return mobileNumber;

}

- (void)showMobileNumberConfirmationAlert {

    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Is this mobile number correct?" message:[self formattedMobileNumber] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.mobileNumebrField becomeFirstResponder];
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self proceed];
    }];

    [confirmationAlert addAction:editAction];
    [confirmationAlert addAction:okAction];

    [self presentViewController:confirmationAlert animated:YES completion:nil];
}

#pragma mark:- Proceed

- (void)proceed {
    NSString *mobNum = self.mobileNumebrField.text;
    _paymentParams[@"mobileNumber"] = mobNum;
    [self fetchToken];
}

#pragma mark:- UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (string.length == 0) {
        return YES;
    }
    return range.location < MOBILE_NUMBER_LENGTH;
}

#pragma mark:- Fetch Token and Record payment

- (void)fetchToken {

    NSDictionary *params = @{ @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"RefId" : _paymentParams[@"referenceId"],
                              };
    NSLog(@"payment params fetch token %@", params);

    [self showHud:@"Preparing for payment.."];

    [_apiManager getToken:params success:^(NSDictionary *tokenInfo) {
        NSString *tokenId = tokenInfo[@"TokenId"];
        [self.paymentParams setValue:tokenId forKey:@"token"];
        [self postToMerchant];
    } failure:^(NSString *error) {
        [self dissmissHud];
        [self showAlert:@"Error!" message:error okayHandler: ^{}];
    }];
}

- (void)postToMerchant {

    NSDictionary *params = @{ @"TokenId": _paymentParams[@"token"],
                              @"MerchantCode": _paymentParams[@"merchantCode"],
                              @"Amount" : _paymentParams[@"amount"],
                              @"ReferenceId" : _paymentParams[@"referenceId"]
                              };
    NSLog(@"mercharnt URL post params %@", params);
    NSLog(@"PAYMENT PARAMS BEFORE POST TO MERCHANT %@", _paymentParams);
    NSString *merchantPaymentUrl = _paymentParams[@"merchantUrl"];
    NSString *cleanUrl = [merchantPaymentUrl stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSLog(@"Merchant Payment URL %@", cleanUrl);

    if (merchantPaymentUrl == nil) {
        return;
    }

    [_apiManager postToMerchant:cleanUrl parameters:params success:^{
        [self dissmissHud];
        [self gotoPinConfirmationVc];
    } failure:^(NSString *error) {
        [self dissmissHud];
        [self showAlert:@"Error!" message:error okayHandler: ^{}];
    }];
}

#pragma mark:- Goto Pin Confirmation

- (void)gotoPinConfirmationVc {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    PinConfirmPaymentViewController *pinConfirmationVc = (PinConfirmPaymentViewController *) [sb instantiateViewControllerWithIdentifier:@"PinConfirmPaymentViewController"];

    pinConfirmationVc.success  = _success;
    pinConfirmationVc.failure = _failure;
    pinConfirmationVc.paymentParams = self.paymentParams;

    UINavigationController *pinConfirmationNav = baseNav(pinConfirmationVc);

    [self.navigationController presentViewController:pinConfirmationNav animated:true completion:nil];
}

@end
