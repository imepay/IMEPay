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
#define CLOSE_BTN_TITLE @"Close"

- (void)viewDidLoad {

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

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

- (void)addLogoTitle {

    UIView * logoContainer = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 110.0, 46.0)];
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.frame =  CGRectMake(0.0, 0.0, 110.0, 46.0);
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;

    NSBundle *bundle = [NSBundle bundleForClass:[BaseViewController class]];

    logoImageView.image = [UIImage imageNamed:@"logo_new.png" inBundle:bundle compatibleWithTraitCollection:nil];
    NSLog(@"nav image %@", logoImageView.image);
    [logoContainer addSubview:logoImageView];
    self.navigationItem.titleView = logoContainer;
}

- (void)addCloseButton {

    UINavigationController *nav = self.navigationController;
    if (nav == nil) {
        return;
    }

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithTitle:CLOSE_BTN_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = closeButton;

}

- (void)addDissmissButton {

    NSBundle *bundle = [NSBundle bundleForClass:[BaseViewController class]];
    UIImage *dissmissLogo = [UIImage imageNamed:@"close.png" inBundle:bundle compatibleWithTraitCollection:nil];

    UIBarButtonItem *dissmissBtn = [[UIBarButtonItem alloc]initWithImage:dissmissLogo style:UIBarButtonItemStylePlain target:self action:@selector(dissmissVc)];
    self.navigationItem.rightBarButtonItem = dissmissBtn;

}

- (void)addCancelButtonWithAlert {

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithTitle:CANCEL_BTN_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(alertCancelButtonClicked)];
    closeButton.tintColor = UIColor.blackColor;
    self.navigationItem.rightBarButtonItem = closeButton;

}

- (void)alertCancelButtonClicked {

    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Do you want to cancel payment ?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_SHOULD_QUIT object:nil];
    }];

    [confirmationAlert addAction:noAction];
    [confirmationAlert addAction:okAction];
    [self presentViewController:confirmationAlert animated:YES completion:nil];

}

@end



