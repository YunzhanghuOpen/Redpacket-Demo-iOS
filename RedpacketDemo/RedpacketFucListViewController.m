//
//  RedpacketFucListViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketFucListViewController.h"
#import "RedpacketConfig.h"
#import "RedpacketViewControl.h"
#import "RedpacketUser.h"
#import "RedpacketSingleViewController.h"
#import "RedpacketGroupViewController.h"
#import "AboutMeViewController.h"
#import "RedpacketUserLoginViewController.h"
#import "RedpacketDefines.h"

@interface RedpacketFucListViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@end

@implementation RedpacketFucListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle       = UIBarStyleBlack;
    self.nameLabel.text = [RedpacketUser currentUser].userInfo.userNickName;
    [self showLoginViewController];
}

- (void)showLoginViewController
{
    if (![RedpacketUser currentUser].userInfo) {
        RedpacketUserLoginViewController *loginController = [[RedpacketUserLoginViewController alloc] initWithNibName:NSStringFromClass([RedpacketUserLoginViewController class]) bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [self.clearBtn addTarget:self action:@selector(loginOutClicked) forControlEvents:UIControlEventTouchUpInside];
    self.headBackgroundView.backgroundColor = rpHexColor(0xd24f44);
    [self addButtons];
    [self.clearBtn setTitleColor:rpHexColor(0x44459a) forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];

    
    [self.navigationController.navigationBar setBackgroundImage:[self navgationBarBackImage:rpHexColor(0xd24f44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)addButtons
{
    for (int i=0; i<[self functions].count ; i++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitleColor:rpHexColor(0xd24f44) forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = i;
        btn.titleLabel.font = [UIFont fontWithName:@"" size:19];
        [btn setTitle:[self functions][i] forState:UIControlStateNormal];
        if (i<3) {
            btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width/3, 277, [UIScreen mainScreen].bounds.size.width/3, 100);
        }else {
            btn.frame = CGRectMake((i - 3) * [UIScreen mainScreen].bounds.size.width/3, 377, [UIScreen mainScreen].bounds.size.width/3, 100);
        }
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(clickListBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *lineHorizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 377, [UIScreen mainScreen].bounds.size.width, .5)];
    lineHorizontal.backgroundColor = rpHexColor(0xc7c7c7);
    [self.view addSubview:lineHorizontal];
    for (int i = 0; i < 2; i ++) {
        UIView *lineVertical = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3*(1+i), 277, .5, 200)];
        lineVertical.backgroundColor = rpHexColor(0xc7c7c7);
        [self.view addSubview:lineVertical];
    }
}

- (void)clickListBtn:(id)sender
{
    static NSString *systemRedpacketInstruction = @"系统红包简介：\n系统红包以系统管理员的身份给用户发拼手气群红包，特别适合开发者们做运营活动使用。";
    static NSString *advertRedpacketInstruction = @"广告红包简介：\n广告红包使用云账户的商户端进行广告计划和品牌主红包素材配置，计划开始执行时，给符合条件的用户发放一个品牌红包，增加品牌曝光量。";
    
    UIViewController * controller = nil;
    UIButton *btn = sender;
    switch (btn.tag) {
            
        case 0: controller = [RedpacketSingleViewController controllerWithControllerType:NO]; break;
            
        case 1: controller = [RedpacketGroupViewController controllerWithControllerType:YES]; break;
            
        case 2: [self alertMessage:systemRedpacketInstruction]; break;
            
        case 3: [self alertMessage:advertRedpacketInstruction]; break;
            
        case 4: [[RedpacketConfig sharedConfig] presentChangeViewControllerInController:self]; break;
            
        case 5: controller = [[AboutMeViewController alloc] initWithNibName:@"AboutMeViewController" bundle:[NSBundle mainBundle]]; break;
            
        default: controller = nil; break;
    }
    
    if (controller != nil) {
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (void)loginOutClicked
{
    [[RedpacketUser currentUser] loginOut];
    
    [self showLoginViewController];
}

- (void)alertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    
    [alert show];
}

- (NSArray *)functions
{
    return @[
             @"单人红包",
             @"多人红包",
             @"系统红包",
             @"广告红包",
             @"零钱页面",
             @"联系我们"
             ];
}

- (UIImage *)navgationBarBackImage:(UIColor *)color
{
    CGSize size = CGSizeMake(10, 10);
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
