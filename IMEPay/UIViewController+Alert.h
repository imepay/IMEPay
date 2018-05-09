//
//  UIViewController+Alert.h
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

@interface UIViewController (Alert)

- (void)showTryAgain:(NSString *)title message:(NSString *)message cancelHandler: (void (^)())cancelBlock tryAgainHandler:(void (^)())tryAgainBlock;

- (void)showAlert:(NSString *)title message:(NSString *)message okayHandler: (void (^)())okayBlock;

@end

#pragma clang diagnostic pop
