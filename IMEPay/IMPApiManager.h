//
//  IMPApiManager.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPApiManager : NSObject

- (void)getToken:(NSDictionary *)params success:(void(^)(NSDictionary *tokenInfo))success failure: (void (^) (NSString *error))failure;

- (void)postToMerchant: (NSDictionary *)params success: (void (^)())success failure: (void (^)(NSString *error))failure;

- (void)makePayment:(NSDictionary *)params success:(void(^)())success failure: (void (^) (NSString *error))failure;

- (void)confirmPayment:(NSDictionary *)params success:(void(^)())success failure: (void (^) (NSString *error))failure;

@end
