//
//  RedpacketUserLoginViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/29.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketUserLoginViewController.h"
#import "RedpacketUser.h"

@interface RedpacketUserLoginViewController ()

@property (nonatomic, assign) IBOutlet  UITextField *sender;
@property (nonatomic, assign) IBOutlet  UITextField *receiver;

@end

@implementation RedpacketUserLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登陆";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClicked)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapGestureClicked
{
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked:(id)sender
{
    if (_sender.text.length && _receiver.text.length) {
        
        [[RedpacketUser currentUser] loginWithSender:_sender.text
                                         andReceiver:_receiver.text];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
