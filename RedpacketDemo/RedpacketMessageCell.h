//
//  RedpacketMessageCell.h
//  LeanChat
//
//  Created by YANG HONGBO on 2016-5-7.
//  Copyright © 2016年 云帐户. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RPRedpacketModel.h"


/** 演示用Cell页面*/
@interface RedpacketMessageCell : UITableViewCell

@property (nonatomic, strong)   UIImageView *headerImageView;
@property (nonatomic, strong)   UILabel     *userNickNameLabel;

- (void)configWithRedpacketMessageModel:(RPRedpacketModel *)model
                        andRedpacketDic:(NSDictionary *)redpacketDic;

+ (CGFloat)heightForRedpacketMessageCell:(RPRedpacketModel *)model;

@end
