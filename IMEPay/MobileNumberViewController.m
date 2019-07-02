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
@import IQKeyboardManager;
#import "IMPTransactionInfo.h"

#define MOBILE_NUMBER_LENGTH 10
#define PAYMENT_DESC_TEXT @"Please enter your mobile number that is registered to IME pay."

@interface MobileNumberViewController()<UITextFieldDelegate>

@property (nonatomic, strong) IMPApiManager *apiManager;
@property (nonatomic, strong) UIColor *hostAppIQToolBarTintColor;
@property (nonatomic) UIStatusBarStyle hostAppBarStyle;

@end

#pragma mark:- MobileNumberViewController implementation

@implementation MobileNumberViewController

#define MOBILENUM_FIELD_PLACEHOLDER @"Enter Mobile Number"
#define COUNTRY_CODE @"+977"

#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    _hostAppIQToolBarTintColor = [[IQKeyboardManager  sharedManager]toolbarTintColor];

    _hostAppBarStyle = [[UIApplication sharedApplication]statusBarStyle];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 15.0;

    [self setupUI];

    //MARK:- Should Dissmiss Notification

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmissAll) name:NOTIF_SHOULD_QUIT object:nil];

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleTransactionCancellation) name:NOTIF_TRANSACTION_CANCELLED object:nil];

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

    [[IQKeyboardManager sharedManager]setToolbarTintColor:_hostAppIQToolBarTintColor];

    [[UIApplication sharedApplication]setStatusBarStyle:_hostAppBarStyle];

    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)handleTransactionCancellation {

    IMPTransactionInfo *tranInfo = [IMPTransactionInfo new];
    if (_failure) {
        _failure(tranInfo, TRAN_CANCELLED_DESC);
    }

}

#pragma mark:- Setup UI

- (void)setupUI {
    [self addCancelBtn];

    NSString *descText = [[NSString stringWithFormat:@"To pay %@, %@", _paymentParams[@"merchantName"], PAYMENT_DESC_TEXT] stringByReplacingOccurrencesOfString:@"_" withString:@" "];

    _paymetDescLabel.text = descText;

    _confirmBtn.layer.cornerRadius = _confirmBtn.frame.size.height /  2.0;
    [_mobileNumebrField setThemedPlaceholder:MOBILENUM_FIELD_PLACEHOLDER];

    [[IQKeyboardManager sharedManager] setToolbarTintColor:[UIColor colorWithRed:216.0 / 255.0 green: 55.0 / 255.0 blue: 49.0 /255.0 alpha:1.0]];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)addCancelBtn {

    UINavigationController *nav = self.navigationController;
    if (nav == nil) {
        return;
    }

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelBtnClicked {

     [[IQKeyboardManager sharedManager]setToolbarTintColor:_hostAppIQToolBarTintColor];

    [[UIApplication sharedApplication]setStatusBarStyle:_hostAppBarStyle];

    IMPTransactionInfo *tranInfo = [IMPTransactionInfo new];
    if (_failure) {
        _failure(tranInfo, TRAN_CANCELLED_DESC);
    }

    [self dissmissVc];
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

    NSLog(@"post to merchant params %@", params);

    NSString *merchantPaymentUrl = _paymentParams[@"merchantUrl"];
    NSString *cleanUrl = [merchantPaymentUrl stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    

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
