//
//  TransactionResultViewController.m
//  IMEPay
//
//  Created by Manoj Karki on 12/29/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "TransactionResultViewController.h"

@interface TransactionResultViewController ()

@end

@implementation TransactionResultViewController

#define DATE_FORMAT @"dd/MM/yyyy"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  addLogoTitle];
    [self populateInfo];
}

- (void)populateInfo {

    _tranDescriptionLabel.text = _transactionInfo[@"ResponseDescription"];
    _transactionIdLabel.text = _transactionInfo[@"TransactionId"];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = DATE_FORMAT;

    NSString *dateString = [dateFormatter stringFromDate:[NSDate new]];
    _transactionDateLabel.text = dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- Done action

- (IBAction)doneClicked:(id)sender {

}

@end
