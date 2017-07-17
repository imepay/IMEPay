//
//  UIViewController+Alert.h
//  IMEPay
//
//  Created by Manoj Karki on 7/13/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)showTryAgain:(NSString *)title message:(NSString *)message cancelHandler: (void (^)())cancelBlock tryAgainHandler:(void (^)())tryAgainBlock;

- (void)showAlert:(NSString *)title message:(NSString *)message okayHandler: (void (^)())okayBlock;

@end
