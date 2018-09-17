//
//  TransactionResultViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SplashViewController.h"

@interface TransactionResultViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *tranDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionIdLabel;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *tranDetailContainer;

@property (strong, nonatomic) NSDictionary *transactionInfo;
@property (strong, nonatomic) NSDictionary *paymentParams;

@property (nonatomic, copy) successBlock success;
@property (nonatomic, copy) failureBlock failure;

@property (nonatomic, strong) UIImageView *successIconView;

@end
