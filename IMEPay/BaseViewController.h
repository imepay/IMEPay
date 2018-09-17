//
//  BaseViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 8/10/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "IMPTransactionInfo.h"

typedef void(^successBlock)(IMPTransactionInfo *);
typedef void(^failureBlock)(IMPTransactionInfo *, NSString *);

#define TRAN_SUCCESS_CODE 0
#define TRAN_FAILURE_CODE 1

#define TRAN_CANCELLED_DESC @"Transaction Cancelled!"

@import SVProgressHUD;

@interface BaseViewController: UIViewController

- (void)addCancelButton;
- (void)dissmissVc;
- (void)addLogoTitle;
- (void)addCloseButton;
- (void)addDissmissButton;
- (void)addCancelButtonWithAlert;

- (void)showHud: (NSString *)status;
- (void)dissmissHud;

@end

