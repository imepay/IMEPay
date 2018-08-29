//
//  BaseTextField.m
//  IMEPay
//
//  Created by Manoj Karki on 8/10/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

{

    CAShapeLayer *shapeLayer;
    CGFloat cornerRadius;
    UIColor *fillColor;

}

#pragma mark:- Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self styleTextfield];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addShadow];
}

- (void)styleTextfield {
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
    UIView *leftPaddingView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 15.0, self.frame.size.height)];
    self.leftView = leftPaddingView;
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

- (void)setThemedPlaceholder:(NSString *)themedPlaceholder {

    NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:themedPlaceholder];
    UIColor *colorAttribute = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    UIFont *fontAttribute = [UIFont fontWithName:@"System" size:14.0];

    [attributedPlaceholder addAttributes: @{ NSFontAttributeName: fontAttribute, NSForegroundColorAttributeName: colorAttribute }  range: NSMakeRange(0, themedPlaceholder.length)];
    self.attributedPlaceholder = attributedPlaceholder;
}

@end
