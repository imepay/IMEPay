//
//  OTPConfirmationViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

@interface OTPConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *otpField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSMutableDictionary *paymentParams;

@property (nonatomic, strong) NSString* PIN;

@property (nonatomic, copy) successBlock success;
@property (nonatomic, copy) failureBlock failure;

@end
