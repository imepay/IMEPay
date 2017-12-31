//
//  IMPPaymentManager.m
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "IMPPaymentManager.h"
#import "Helper.h"
#import "SplashViewController.h"
#import "MobileNumberViewController.h"

@interface IMPPaymentManager()

@property (nonatomic, strong) NSMutableDictionary  *paymentParams;

@end

@implementation IMPPaymentManager

- (instancetype)initWithEnvironment:(APIEnvironment)environment {
    if (!self)
        self = [super init];
    SessionManager *sessionManager = [SessionManager sharedInstance];
    sessionManager.environment = environment;
    return  self;
}

- (void)pay:(NSString *)userName password:(NSString *)password  merchantCode:(NSString *)merchantCode merchantName: (NSString *)merchantName  merchantUrl:(NSString *)merchantUrl amount:(NSString *)amount customerMobileNumber:(NSString *)customerMobileNumber referenceId: (NSString *)referenceId module: (NSString *)module success: (void(^)(NSDictionary *transactionInfo))success failure: (void(^)(NSDictionary *transactionInfo))failure {

    NSString *curatedRefId = [referenceId  stringByReplacingOccurrencesOfString:@" " withString:@"_"];    
    NSData *dataTake2 =
    [@"gottopay" dataUsingEncoding:NSUTF8StringEncoding];
    
    // Convert to Base64 data
    NSData *base64Data = [dataTake2 base64EncodedDataWithOptions:0];
    
    NSString *base64Module = [NSString stringWithUTF8String:[base64Data bytes]];

    _paymentParams = [NSMutableDictionary dictionaryWithDictionary: @{ @"userName": userName ? userName : @"",
                                                                        @"password": password ? password : @"",
                                                                        @"merchantCode" : merchantCode ? merchantCode : @"",
                                                                        @"merchantName" : merchantName ? merchantName : @"",
                                                                       @"merchantUrl": merchantUrl ? merchantUrl : @"",
                                                                        @"amount" : amount ? amount : @"",
                                                                        @"referenceId" : curatedRefId ? curatedRefId : @"",
                                                                        @"module" : base64Module ? base64Module : @"",
                                                                       @"mobileNumber" : customerMobileNumber ? customerMobileNumber : @""
                                                                        }];
    SessionManager *sessionManager = [SessionManager sharedInstance];
    [sessionManager setAuthorization:userName password:password];
    [sessionManager setModule:module];

   // [self gotoSplashwithSuccess:success failure:failure];
    [self gotoMobileNumberVc:success failure:failure];

}

- (void)gotoSplashwithSuccess: (void(^)(NSDictionary *transactionInfo))success failure: (void(^)(NSDictionary *transactionInfo))failure  {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    
    SplashViewController *splashVc = (SplashViewController *) [sb instantiateViewControllerWithIdentifier:@"SplashViewController"];
    splashVc.paymentParams = _paymentParams;
    splashVc.successBlock = success;
    splashVc.failureBlock = failure;
    [topViewController() presentViewController:splashVc animated:YES completion:nil];

}

- (void)gotoMobileNumberVc: (void(^)(NSDictionary *transactionInfo))success failure: (void(^)(NSDictionary *transactionInfo))failure {

    NSBundle *bundle = [NSBundle bundleForClass:[IMPPaymentManager class]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    
    MobileNumberViewController *mobileNumVc = (MobileNumberViewController *) [sb instantiateViewControllerWithIdentifier:@"MobileNumberViewController"];
    mobileNumVc.paymentParams = _paymentParams;
    mobileNumVc.success  = success;
    mobileNumVc.failure = failure;
    [topViewController() presentViewController:mobileNumVc animated:YES completion:nil];
    
}

@end
