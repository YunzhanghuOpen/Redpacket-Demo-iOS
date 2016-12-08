//
//  AboutMeViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "AboutMeViewController.h"
#import "RedpacketDefines.h"

@interface AboutMeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@end

@implementation AboutMeViewController

- (NSString *)title
{
    return @"";
}

- (IBAction)telphoneButtonClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"telprompt://400-6565-739"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)mailToButtonClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"mailto://BD@yunzhanghu.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)webSiteButtonClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://yunzhanghu.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)QQNumber:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"4006565739";
    [self alertMessage:@"QQ号已经复制到粘贴板"];
}

- (IBAction)QQGroupNumber:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"366135448";
    [self alertMessage:@"技术支持群号已经复制到粘贴板"];
}

- (void)alertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    
    [alert show];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.navigationBar.tintColor = rpHexColor(0xd3d97a);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : rpHexColor(0xd3d97a)}];
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.bottomBtn setTitleColor:rpHexColor(0x999999) forState:UIControlStateHighlighted];
    [self.bottomBtn setTitleColor:rpHexColor(0x44459A) forState:UIControlStateNormal];
}

@end
