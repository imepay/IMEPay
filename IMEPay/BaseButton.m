//
//  BaseButton.m
//  IMEPay
//
//  Created by Manoj Karki on 8/29/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self styleButton];
}

- (void)styleButton {
    self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
    [self setContentEdgeInsets:UIEdgeInsetsMake(0.0, 60.0, 0.0, 60.0)];
}

@end
