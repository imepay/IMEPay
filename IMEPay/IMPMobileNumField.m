//
//  IMPMobileNumField.m
//  IMEPay
//
//  Created by Manoj Karki on 8/30/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import "IMPMobileNumField.h"

@implementation IMPMobileNumField

#pragma mark:- Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self styleTextField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addShadow];
}

- (void)styleTextField {
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
    [self addCountryCodeView];
}

- (void)addCountryCodeView {

    UIView *container = [UIView new];
    container.frame = CGRectMake(8.0, (self.bounds.size.height - 25.0) / 2.0 , 48.0, self.bounds.size.height);
    container.clipsToBounds = YES;

    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"+977";
    label.font = self.font;
    label.textColor = self.textColor;

    label.frame = CGRectMake(8.0, (self.bounds.size.height - 25.0) / 2.0 , 40.0, 25.0);
    [container addSubview:label];
    self.leftView = container;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addShadow {
    self.layer.cornerRadius = 5.0;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowColor = [UIColor colorWithRed:204.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1.0].CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    self.layer.shadowRadius = 3.0;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)setThemedPlaceholder:(NSString *)placeholderText {

    NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeholderText];
    UIColor *colorAttribute = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];

    [attributedPlaceholder addAttributes: @{  NSForegroundColorAttributeName: colorAttribute }  range: NSMakeRange(0, placeholderText.length)];
    self.attributedPlaceholder = attributedPlaceholder;
}

@end
