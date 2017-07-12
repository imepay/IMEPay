
//
//  Auth.m
//  Foodmandu
//
//  Created by Manoj Karki on 8/17/16.
//  Copyright © Manoj Karki All rights reserved.
//

#import "Auth.h"
#import "Config.h"


@implementation Auth

+ (id)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    // initialize sharedObject as nil (first call only)
    __strong static AFHTTPSessionManager *_sharedObject = nil;
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [AFHTTPSessionManager manager];
    });
    // returns the same object each time
    [_sharedObject setRequestSerializer:[AFHTTPRequestSerializer serializer]];
     return _sharedObject;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer {
    [super setRequestSerializer:requestSerializer];
    [self.requestSerializer setValue:@"application/json"
                  forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)setAccessToken:(NSString *)token {

    AFHTTPSessionManager *manager = [Auth sharedInstance];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", token] forHTTPHeaderField:@"Authorization"];
}

- (void)setModule: (NSString *)moduleString {
  
    AFHTTPSessionManager *manager = [Auth sharedInstance];
    [manager.requestSerializer setValue:moduleString forHTTPHeaderField:@"Module"];
    
}


@end
