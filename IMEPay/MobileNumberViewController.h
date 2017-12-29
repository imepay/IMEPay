//
//  MobileNumberViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileNumberViewController : UIViewController
    
@property (weak, nonatomic) IBOutlet UITextField *mobileNumebrField;    
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
    
@property (strong, nonatomic) NSDictionary *paymentParams;
    
    

@end
