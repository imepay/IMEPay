//
//  ConfirmPaymentViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"

#define PIN_MAX_LENGTH 4

@interface PinConfirmPaymentViewController : UIViewController

#pragma mark:- IBOutlets

@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet BaseTextField* pinField;

@property (strong, nonatomic) NSDictionary *paymentParams;

#pragma marK:- Success Failure Handlers

@property (nonatomic, copy) void(^successBlock)(NSDictionary *info);
@property (nonatomic, copy) void(^failureBlock)(NSDictionary *info);

@end
