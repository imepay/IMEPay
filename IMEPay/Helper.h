//
//  Helper.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "Config.h"
#import "SessionManager.h"

#ifndef Helper_h
#define Helper_h

#define isNilORNull(obj) ((obj == (id)[NSNull null]) || !obj)

//static inline  NSString* url(NSString *endpoint) {
//  return [NSString stringWithFormat:@"%@%@",URL_BASE_TEST,endpoint];
//}

static inline UIViewController* topViewController() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController  = window.rootViewController;
    UIViewController *topViewController = rootViewController;
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

#endif /* Helper_h */
