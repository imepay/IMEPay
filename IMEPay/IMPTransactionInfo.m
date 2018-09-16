//
//  IMPTransactionInfo.m
//  IMEPay
//
//  Created by Manoj Karki on 9/16/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import "IMPTransactionInfo.h"
#import "Helper.h"

@implementation IMPTransactionInfo

- (id)init {
    self = [super init];

    if (self) {
        _transactionId = 0;
        _responseDescription = @"";
        _transactionId = @"";
        _customerMsisdn = @"";
        _amount = @"";
        _referenceId = @"";
    }
    return self;
}


- (instancetype)initWithDictionary: (NSDictionary *)response totalAmount: (NSString *)totalAmount {

    self = [self init];

    if (self) {
        if (isNilORNull(response)) {
            return self;
        }
        NSNumber *resCode =  [response valueForKey:@"ResponseCode"];

        if (!(isNilORNull(resCode))) {
            _responseCode = resCode.integerValue;
        }

        NSLog(@"parsed resonse code %@", resCode);

        NSString *resDesc = [response valueForKey:@"ResponseDescription"];

        if (!(isNilORNull(resDesc))) {
            _responseDescription = resDesc;
        }

        NSString *tranId = [response valueForKey:@"TransactionId"];

        if (!(isNilORNull(tranId))) {
            _transactionId = tranId;
        }

        NSString *customerMobileNum = [response valueForKey:@"Msisdn"];

        if (!(isNilORNull(customerMobileNum))) {
            _customerMsisdn = customerMobileNum;
        }

        if (!(isNilORNull(totalAmount))) {
            _amount = totalAmount;
        }

        NSString *refId = [response valueForKey:@"RefId"];

        if (!(isNilORNull(refId))) {
            _referenceId = refId;
        }
    }

    return self;

}


@end
