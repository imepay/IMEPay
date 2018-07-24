//
//  IMPApiManager.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPPaymentManager.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

@interface IMPApiManager : NSObject

- (void)getToken:(NSDictionary *)params success: (void(^)(NSDictionary *tokenInfo))success failure: (void(^)(NSString *error))failure;

- (void)postToMerchant: (NSString *)merchantUrl parameters: (NSDictionary *)params success: (void(^)())success failure: (void(^)(NSString *error))failure;

- (void)makePayment:(NSDictionary *)params success: (void(^)(NSDictionary *info))success failure: (void (^) (NSString *error))failure;

- (void)confirmPayment:(NSDictionary *)params success: (void(^)(NSDictionary *info))success failure: (void (^)(NSString *error))failure;

- (void)validateUser: (NSDictionary *)params success: (void(^)(NSString *PIN))success failure: (void (^)(NSString *error))failure;

@end

#pragma clang diagnostic pop


