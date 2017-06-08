//
//  RPReceiotsInAlipayHeaderView.h
//  RedpacketLib
//
//  Created by 都基鹏 on 2016/12/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRedpacketManager.h"

@protocol RPReceiotsInAlipayHeaderViewDelegate <NSObject>

- (void)doAlipayAuth;
- (void)removeBinding;

@end

@interface RPReceiotsInAlipayHeaderView : UITableViewCell

@property (nonatomic, assign)   RPPersonalRedpacketType                     personalRedpacketType;
@property (nonatomic, strong)   RPPersonalRedpacketInfo                     *personalRedpacketInfo;
@property (nonatomic, copy)     NSString                                    *username;
@property (nonatomic, weak)     id<RPReceiotsInAlipayHeaderViewDelegate>    delegate;

@end
