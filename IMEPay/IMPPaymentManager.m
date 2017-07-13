//
//  IMPPaymentManager.m
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "IMPPaymentManager.h"

@implementation IMPPaymentManager

- (instancetype)initWithEnvironment:(APIEnvironment)environment {
    if (!self) {
        self = [super init];
        _environment = environment;
    }
    return  self;
}

- (void)pay:(NSString *)userName password:(NSString *)password merchantCode:(NSString *)merchantCode merchantName:(NSString *)merchantName amount:(NSString *)amount customerMobileNumber:(NSString *)customerMobileNumber referenceId:(NSString *)referenceId module:(NSString *)module success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
   
    
    
    
    
    
    
}

@end
