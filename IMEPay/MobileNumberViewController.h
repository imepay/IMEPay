//
//  MobileNumberViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(NSDictionary *);

typedef void(^failureBlock)(NSDictionary *);

@interface MobileNumberViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mobileNumebrField;    
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) NSMutableDictionary *paymentParams;

@property (nonatomic, copy) successBlock success;
@property (nonatomic, copy) failureBlock failure;

@end
