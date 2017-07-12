//
//  Auth.h
//  Foodmandu
//
//  Created by Ajeet Shakya on 8/17/16.
//  Copyright © Ajeet Shakya All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface Auth : AFHTTPSessionManager

+ (id)sharedInstance;

@end
