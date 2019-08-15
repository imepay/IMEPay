//
//  MobileNumberViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "BaseViewController.h"
#import "BaseTextField.h"

#pragma mark:- View Controller to take users mobile number

@interface MobileNumberViewController : BaseViewController

#pragma mark:- IBOutlets

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BaseTextField *mobileNumebrField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) NSMutableDictionary *paymentParams;

@property (weak, nonatomic) IBOutlet UILabel *paymetDescLabel;

@property (strong, nonatomic) IBOutlet UIWindow *originalWindow;

#pragma mark:- Success/ Failure Handlers

@property (nonatomic, copy) successBlock success;
@property (nonatomic, copy) failureBlock failure;

@end
