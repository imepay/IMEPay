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



#pragma mark:- Vc Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    //MARK:- Should Dissmiss Notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmissVc) name:NOTIF_SHOULD_QUIT_SPLASH object:nil];
    [self setupUI];
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

- (void)setupUI {
    [self addCancelButton];
    _confirmBtn.layer.cornerRadius = _confirmBtn.frame.size.height /  2.0;
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

    NSString *mobNum = self.mobileNumebrField.text;
    _paymentParams[@"mobileNumber"] = mobNum;
    [self fetchToken];
    //[self gotoSplash];
}

#pragma mark:- Goto Splash

- (void)gotoSplash {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];

    SplashViewController *splashVc = (SplashViewController *) [sb instantiateViewControllerWithIdentifier:@"SplashViewController"];
    splashVc.paymentParams = _paymentParams;
    splashVc.successBlock = _success;
    splashVc.failureBlock = _failure;
    [self.navigationController pushViewController:splashVc animated:true];
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
    [SVProgressHUD showWithStatus:@"Preparing for payment.."];

    [_apiManager getToken:params success:^(NSDictionary *tokenInfo) {
        NSString *tokenId = tokenInfo[@"TokenId"];
        [self.paymentParams setValue:tokenId forKey:@"token"];
        [self postToMerchant];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
           [self dissmissVc];
        } tryAgainHandler: ^{
            [self fetchToken];
        }];
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
        [SVProgressHUD dismiss];
        [self gotoPinConfirmationVc];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self gotoPinConfirmationVc];
        return;
        [self showTryAgain:@"Oops!" message:error cancelHandler:^{
            [self dissmissVc];
        } tryAgainHandler:^{
            [self postToMerchant];
        }];
    }];
}

#pragma mark:- Goto Pin confirmation

- (void)gotoPinConfirmationVc {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    PinConfirmPaymentViewController *paymentVc = (PinConfirmPaymentViewController *) [sb instantiateViewControllerWithIdentifier:@"PinConfirmPaymentViewController"];
    paymentVc.paymentParams = self.paymentParams;
  //  paymentVc.successBlock = self.successBlock;
   // paymentVc.failureBlock = self.failureBlock;
    [self.navigationController pushViewController:paymentVc animated:true];

}



@end
