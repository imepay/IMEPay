//
//  IMPPaymentManager.h
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    Live,
    Test,
}APIEnvironment;

@interface IMPPaymentManager : NSObject

@property (nonatomic, assign) APIEnvironment environment;

- (instancetype)initWithEnvironment: (APIEnvironment)environment;

- (void)pay:(NSString *)userName password:(NSString *)password  merchantCode:(NSString *)merchantCode merchantName: (NSString *)merchantName amount:(NSString *)amount customerMobileNumber:(NSString *)customerMobileNumber referenceId: (NSString *)referenceId module: (NSString *)module success:(void (^) (NSDictionary *paymentInfo))success failure: (void(^)(NSString *errorMessage))failure;

@end
