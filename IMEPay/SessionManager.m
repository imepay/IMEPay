
//
//  Auth.m
//  Foodmandu
//
//  Created by Manoj Karki on 8/17/16.
//  Copyright © Manoj Karki All rights reserved.
//

#import "SessionManager.h"
#import "Config.h"


@implementation SessionManager

+ (id)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    // initialize sharedObject as nil (first call only)
    __strong static SessionManager *_sharedObject = nil;
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [SessionManager manager];
    });
    // returns the same object each time
   // [_sharedObject setRequestSerializer:[AFHTTPRequestSerializer serializer]];
     return _sharedObject;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer {
    [super setRequestSerializer:requestSerializer];
    
}

- (void)setAuthorization:(NSString *)username password:(NSString *)password {
    [self.requestSerializer setValue:@"application/json"
                  forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

- (void)setModule:(NSString *)moduleString {
    [self.requestSerializer setValue:moduleString forHTTPHeaderField:@"Module"];
}

@end
