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
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setupGsture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self observeKeyboardNotifs];
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

    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Do you want to cancel payment?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_TRANSACTION_CANCELLED object:nil];

        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_SHOULD_QUIT object:nil];
    }];

    [confirmationAlert addAction:okAction];
    [confirmationAlert addAction:noAction];
    [self presentViewController:confirmationAlert animated:YES completion:nil];

}

- (void)showHud: (NSString *)status {

    UIView *containerView = self.view;

    if ([self navigationController] != nil) {
        containerView = [self navigationController].view;
    }
    [SVProgressHUD setContainerView:containerView];

    if (status.length == 0) {
        [SVProgressHUD show];
        return;
    }

    [SVProgressHUD showWithStatus:status];
}

- (void)dissmissHud {
   [SVProgressHUD dismiss];
}

#pragma mark:- Observe Keyboard notification

-(void)observeKeyboardNotifs {
    
    BOOL hasTextField = YES;
    NSArray *subViews = self.view.subviews;
    
    for ( UIView *subView in subViews) {

        if ( [subView isKindOfClass:[UITextField class]] ) {
            hasTextField = YES;
            break;
        }

    }

    if (hasTextField == YES) {

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustScrollView:) name:UIKeyboardWillShowNotification object:nil];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustScrollView:) name: UIKeyboardWillHideNotification object:nil];
    }

}

- (UIScrollView * _Nullable)scrollV {
    
    NSArray *subViews = self.view.subviews;

    for ( UIView *subView in subViews) {
        if ( [subView isKindOfClass:[UIScrollView class]] ) {
            return (UIScrollView *)subView;
        }
    }
    return NULL;
}

#pragma mark:- Keyboard notificaiton handlers

- (void)adjustScrollView: (NSNotification *)notification {

    CGRect keyboardFrame = [[notification.userInfo valueForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    BOOL isShow = (notification.name == UIKeyboardWillShowNotification);
    CGFloat adjustmentHeight = (keyboardFrame.size.height + 30.0) * (isShow ? 1 : -1);
    
    UIEdgeInsets insets  = UIEdgeInsetsMake([self scrollV].contentInset.top, [ self scrollV].contentInset.left, adjustmentHeight, [self scrollV].contentInset.right);
    
    
    [[self scrollV] setContentInset: insets];
    [[self scrollV] setScrollIndicatorInsets:insets];

}
    
#pragma  mark:- Gesture Setup

- (void)setupGsture {
    
    UITapGestureRecognizer *gesture =[[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped)];
    [self.view setUserInteractionEnabled:YES];
     [self.view addGestureRecognizer:gesture];

}
    
- (void)screenTapped {
    [self.view endEditing:YES];
}

@end



