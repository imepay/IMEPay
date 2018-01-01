//
//  SplashViewController.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(NSDictionary *);

typedef void(^failureBlock)(NSDictionary *);

@interface SplashViewController : UIViewController

#pragma mark:- IBOutlet

@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@property (strong, nonatomic) NSDictionary *paymentParams;

#pragma marK:- Success Failure Handlers

@property (nonatomic, copy) void(^successBlock)(NSDictionary *info);
@property (nonatomic, copy) void(^failureBlock)(NSDictionary *info);

//MARK:- Mobile Number Passed

@property (nonatomic, strong) NSString *mobileNumber;
    
@end
