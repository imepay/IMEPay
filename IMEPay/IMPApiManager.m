//
//  IMPApiManager.m
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "IMPApiManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Config.h"
#import "Helper.h"
#import "SessionManager.h"

@implementation IMPApiManager

- (NSString *)url:(NSString *)endpoint {
    SessionManager *manager = [SessionManager sharedInstance];
    if (manager.environment == Test)
        return [NSString stringWithFormat:@"%@%@",URL_BASE_TEST, endpoint];
    return [NSString stringWithFormat:@"%@%@",URL_BASE_LIVE, endpoint];
}

- (void)getToken:(NSDictionary *)params success:(void(^)(NSDictionary *tokenInfo))success failure: (void (^) (NSString *error))failure {
    SessionManager *manager = [SessionManager sharedInstance];
    NSString *url = [self url:EP_GET_TOKEN];
    NSLog(@"GET TOKEN URL ------- %@", url);
    NSLog(@"Session manager request serializer %@", manager.requestSerializer.HTTPRequestHeaders);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)postToMerchant:(NSDictionary *)params success:(void (^)())success failure:(void (^)(NSString *))failure {
  
    SessionManager *manager  = [SessionManager sharedInstance];
    NSString *merchantUrl = params[@"merchantUrl"];
    [manager POST:merchantUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)makePayment:(NSDictionary *)params success:(void (^)(NSDictionary *info))success failure:(void (^)(NSString *error))failure {
    SessionManager *manager  = [SessionManager sharedInstance];
    [manager POST:[self url:EP_PAYMENT] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)confirmPayment:(NSDictionary *)params success:(void (^)(NSDictionary *info))success failure:(void (^)(NSString *error))failure {
    SessionManager *manager  = [SessionManager sharedInstance];
    [manager POST:[self url:EP_CONFIRM] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

@end
