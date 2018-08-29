//
//  BaseTextField.m
//  IMEPay
//
//  Created by Manoj Karki on 8/10/18.
//  Copyright © 2018 Manoj Karki. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark:- Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addStandardLeftPadding];
}

- (void)addStandardLeftPadding {

    UIView *leftPaddingView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 10.0, self.frame.size.height)];
    self.leftView = leftPaddingView;
    self.leftViewMode = UITextFieldViewModeAlways;

}

@end
