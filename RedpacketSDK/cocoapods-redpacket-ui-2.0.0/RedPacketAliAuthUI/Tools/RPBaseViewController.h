//
//  RPBaseViewController.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/9.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedpacketColorStore.h"
#import "UIView+YZHExtension.h"
#import "UIView+YZHPrompting.h"
#import "UIView+YZHAnimation.h"
#import "RPRedpacketBridge.h"
#import "RPRedpacketTool.h"
#import "RPRedpacketViews.h"

@interface RPBaseViewController : UIViewController

/**
 *  大title
 */
@property (nonatomic) UILabel *titleLable;

/**
 *  小title
 */
@property (nonatomic) UILabel *subLable;

/**
 *  设置NavgationBard的北京颜色 title颜色 和 左右按钮颜色
 */
- (void)setNavgationBarBackgroundColor:(UIColor *)groundColor
                            titleColor:(UIColor *)titleColor
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle;

/**
 *  隐藏navgationBar底部的分割线 ，根据设计要求，目前已经设置为全部隐藏，（YES）
 */
@property (nonatomic,assign)  BOOL cuttingLineHidden;

- (void)configViewStyle;

@end
