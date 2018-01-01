
//
//  Auth.m
//  IMEPay
//
//  Created by Manoj Karki on 8/17/16.
//  Copyright © Manoj Karki All rights reserved.
//

#import "SessionManager.h"
#import "Config.h"


@implementation SessionManager

+ (id)sharedInstance {

    static dispatch_once_t p = 0;
    // initialize sharedObject as nil (first call only)
    __strong static SessionManager *_sharedObject = nil;
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [SessionManager manager];
    });
    // returns the same object each time
     return _sharedObject;
}

- (void)setAuthorization:(NSString *)username password:(NSString *)password {
    [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    [self setResponseSerializer:[AFJSONResponseSerializer serializer]];

    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[ @"text/html", @"application/json"]];
    
    self.responseSerializer.stringEncoding = NSUTF8StringEncoding;

    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

- (void)setModule:(NSString *)moduleString {
    [self.requestSerializer setValue:moduleString forHTTPHeaderField:@"Module"];
}

@end
