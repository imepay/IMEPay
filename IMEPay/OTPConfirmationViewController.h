//
//  OTPConfirmationViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "BaseTextField.h"
#import "BaseViewController.h"

@interface OTPConfirmationViewController : BaseViewController

#pragma mark:- IBOutlets

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BaseTextField* otpField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSDictionary *paymentParams;
@property (nonatomic, strong) NSString* PIN;
@property (nonatomic, strong) NSString *OTP;

#pragma mark:- Success/Failure Handlers

@property (nonatomic, copy) successBlock success;
@property (nonatomic, copy) failureBlock failure;

@end
