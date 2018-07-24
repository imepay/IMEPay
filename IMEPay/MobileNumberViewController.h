//
//  MobileNumberViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

@interface MobileNumberViewController : UIViewController

#pragma mark:- IBOutlets

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumebrField;    
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) NSMutableDictionary *paymentParams;

#pragma mark:- Success/ Failure Handlers

@property (nonatomic, copy) successBlock success;
@property (nonatomic, copy) failureBlock failure;

@end
