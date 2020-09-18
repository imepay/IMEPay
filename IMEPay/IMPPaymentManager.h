//
//  IMPPaymentManager.h
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "IMPTransactionInfo.h"

@interface IMPPaymentManager : NSObject

- (instancetype)initWithEnvironment:(APIEnvironment)environment;

- (void)payWithUsername:(NSString *)userName password:(NSString *)password  merchantCode:(NSString *)merchantCode merchantName: (NSString *)merchantName  merchantUrl:(NSString *)merchantUrl deliveryUrl:(NSString *)deliveryUrl amount:(NSString *)amount referenceId: (NSString *)referenceId module: (NSString *)module success: (void(^)(IMPTransactionInfo *transactionInfo))success failure: (void(^)(IMPTransactionInfo *transactionInfo, NSString *errorMessage))failure;


@end
