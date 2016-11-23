//
//  AboutMeViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (NSString *)title
{
    return @"联系我们";
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


@end
