//
//  IMPPaymentManager.h
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"

@interface IMPPaymentManager : NSObject

- (instancetype)initWithEnvironment:(APIEnvironment)environment;

@property (nonatomic, assign) APIEnvironment environment;
@property (nonatomic, strong) NSString *PIN;

- (void)pay:(NSString *)userName password:(NSString *)password  merchantCode:(NSString *)merchantCode merchantName: (NSString *)merchantName amount:(NSString *)amount customerMobileNumber:(NSString *)customerMobileNumber referenceId: (NSString *)referenceId module: (NSString *)module success:(void (^) (NSDictionary *paymentInfo))success failure: (void(^)(NSString *errorMessage))failure;

@end
