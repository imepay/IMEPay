//
//  Auth.h
//  IMEPay
//
//  Created by Manoj Karki on 8/17/16.
//  Copyright © Manoj Karki All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef enum : NSInteger {
    Live,
    Test,
}APIEnvironment;

@interface SessionManager : AFHTTPSessionManager

+ (id)sharedInstance;

@property (nonatomic, assign) APIEnvironment environment;

- (void)setAuthorization:(NSString *)username password:(NSString *)password;

- (void)setModule:(NSString *)moduleString;

@end
