//
//  IMPTransactionInfo.h
//  IMEPay
//
//  Created by Manoj Karki on 9/16/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPTransactionInfo : NSObject

@property NSInteger responseCode;
@property (nonatomic, strong) NSString* responseDescription;
@property (nonatomic, strong) NSString* transactionId;
@property (nonatomic, strong) NSString* customerMsisdn;
@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* referenceId;

@end
