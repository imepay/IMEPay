//
//  Helper.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "Config.h"
#import "SessionManager.h"
#import "BaseViewController.h"

#ifndef Helper_h
#define Helper_h

#define isNilORNull(obj) ((obj == (id)[NSNull null]) || !obj)

static inline UIViewController* topViewController() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController  = window.rootViewController;
    UIViewController *topViewController = rootViewController;
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

static inline UINavigationController *baseNav(UIViewController *rootVc) {

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootVc];
    [nav.navigationBar setBarTintColor:[UIColor whiteColor]];
    nav.navigationBar.tintColor = UIColor.blackColor;
    nav.navigationBar.backgroundColor = [UIColor whiteColor];

    [nav.navigationBar setBackIndicatorImage:[UIImage new]];
    [nav.navigationBar setShadowImage:[UIImage new]];

    [nav.navigationBar setTranslucent:NO];
    return nav;
}

#endif /* Helper_h */
