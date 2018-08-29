//
//  BaseViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 8/10/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+Extensions.h"

@interface BaseViewController()

@end

@implementation BaseViewController

#define CANCEL_BTN_TITLE @"Cancel"

- (void)addCancelButton {

    UINavigationController *nav = self.navigationController;
    if (nav == nil) {
        return;
    }

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:CANCEL_BTN_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelButtonClicked {
    [self dissmissVc];
}

- (void)dissmissVc {
    [self dismissViewControllerAnimated:true completion:false];
}

@end



