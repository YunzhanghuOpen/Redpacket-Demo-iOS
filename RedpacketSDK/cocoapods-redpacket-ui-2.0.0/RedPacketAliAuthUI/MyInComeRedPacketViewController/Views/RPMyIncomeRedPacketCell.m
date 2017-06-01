//
//  RPMyIncomeRedPacketCell.m
//  RedpacketLib
//
//  Created by Mr.Yan on 2016/10/31.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPMyIncomeRedPacketCell.h"
#import "RPLayout.h"
#import "UIView+YZHExtension.h"
#import "RedpacketColorStore.h"
#import "UIImageView+YZHWebCache.h"
#import "RPRedpacketTool.h"

@interface RPMyIncomeRedPacketCell ()

@property (nonatomic, strong) UILabel       *nameLable;
//  红包类型标识图片
@property (nonatomic, strong) UIImageView   *typeImageView;
@property (nonatomic, strong) UILabel       *timeLable;
@property (nonatomic, strong) UILabel       *moneyLabel;
//  红包来源显示
@property (nonatomic, strong) UILabel       *sourceLable;

@end

@implementation RPMyIncomeRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self.nameLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.rpm_top).offset(11);
        make.left.equalTo(self.rpm_left).offset(15);
    }];
    
    [self.typeImageView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.left.equalTo(self.nameLable.rpm_right).offset(2);
        make.centerY.equalTo(self.nameLable.rpm_centerY).offset(0);
    }];
    
    [self.timeLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self.rpm_bottom).offset(-11);
        make.left.equalTo(self.rpm_left).offset(15);
    }];
 
    [self.moneyLabel rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.rpm_top).offset(11);
        make.right.equalTo(self.rpm_right).offset(-15);
    }];
    
    [self.sourceLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self.rpm_bottom).offset(-11);
        make.right.equalTo(self.rpm_right).offset(-15);
    }];
    
    UIView * lineView = [self rp_addsubview:[UIView class]];
    lineView.backgroundColor = [RedpacketColorStore rp_lineColorLightGray];
    [lineView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.right.equalTo(self);
         make.left.equalTo(self).offset(15);
        make.height.offset(RP_(@(0.5)).floatValue);
        make.bottom.equalTo(self);
    }];
}

- (void)setBriefReceiveInfo:(RPRedpacketBriefReceiveInfo *)briefReceiveInfo
{
    _briefReceiveInfo = briefReceiveInfo;
    self.nameLable.text = briefReceiveInfo.user.userName;
    self.sourceLable.text = briefReceiveInfo.propuctName;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",briefReceiveInfo.money];
    self.typeImageView.hidden = NO;
    if (briefReceiveInfo.type == RPRedpacketTypeGroupRand) {
        [self.typeImageView setImage:rpRedpacketBundleImage(@"redPackert_luck")];
    } else if (briefReceiveInfo.type == RPRedpacketTypeGoupMember) {
        [self.typeImageView setImage:rpRedpacketBundleImage(@"redPackert_exclusive")];
    } else {
        self.typeImageView.hidden = YES;
    }
    
    // 获得当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSString *redpacketTIme = [briefReceiveInfo.date substringWithRange:NSMakeRange(0, 10)];
    if ([locationString isEqualToString:redpacketTIme]) {//今天的红包 显示几点几分
        self.timeLable.text = [briefReceiveInfo.date substringWithRange:NSMakeRange(11, 5)];
    }else if(![[locationString substringWithRange:NSMakeRange(0, 4)] isEqualToString:[redpacketTIme substringWithRange:NSMakeRange(0, 4)]]){//往年的红包 显示年份和月份
        self.timeLable.text = [briefReceiveInfo.date substringWithRange:NSMakeRange(0, 10)];
    }else{//昨天和今年之内的红包 显示月日
        self.timeLable.text =[briefReceiveInfo.date substringWithRange:NSMakeRange(5, 5)];
    }
}

- (void)setBriefSendInfo:(RPRedpacketBriefSendInfo *)briefSendInfo {
    _briefSendInfo = briefSendInfo;
    self.typeImageView.hidden = YES;
    self.nameLable.text = briefSendInfo.redpacketType;
    
    NSString *dataTime;
    // 获得当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSString *redpacketTIme = [briefSendInfo.date substringWithRange:NSMakeRange(0, 10)];
    if ([locationString isEqualToString:redpacketTIme]) {//今天的红包
        dataTime = [briefSendInfo.date substringWithRange:NSMakeRange(11, 5)];
    }else if(![[locationString substringWithRange:NSMakeRange(0, 4)] isEqualToString:[redpacketTIme substringWithRange:NSMakeRange(0, 4)]]){//往年的红包
        dataTime = [briefSendInfo.date substringWithRange:NSMakeRange(0, 10)];
    }else{//昨天和今年之内的红包
        dataTime = [briefSendInfo.date substringWithRange:NSMakeRange(5, 5)];
    }
    
    self.timeLable.text = [NSString stringWithFormat:@"%@ %@",dataTime,briefSendInfo.propuctName];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",briefSendInfo.money];
    if (briefSendInfo.totalCount == briefSendInfo.receiveCount) {
        self.sourceLable.text = [NSString stringWithFormat:@"已领完%ld/%ld个",(long)briefSendInfo.receiveCount,(long)briefSendInfo.totalCount];
    }else
    {
        self.sourceLable.text = [NSString stringWithFormat:@"已领取%ld/%ld个",(long)briefSendInfo.receiveCount,(long)briefSendInfo.totalCount];
    }
    self.typeImageView.hidden = YES;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [self rp_addsubview:[UILabel class]];
        _nameLable.font = [UIFont systemFontOfSize:15.0f];
        _nameLable.textColor = [RedpacketColorStore rp_textColorBlack];
    }
    return _nameLable;
}

- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [self rp_addsubview:[UIImageView class]];
    }
    return _typeImageView;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [self rp_addsubview:[UILabel class]];
        _timeLable.font = [UIFont systemFontOfSize:12.0f];
        _timeLable.textColor = [RedpacketColorStore rp_textColorGray];
    }
    return _timeLable;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [self rp_addsubview:[UILabel class]];
        _moneyLabel.font = [UIFont systemFontOfSize:15.0f];
        _moneyLabel.textColor = [RedpacketColorStore rp_textColorBlack];
    }
    return _moneyLabel;
}

- (UILabel *)sourceLable {
    if (!_sourceLable) {
        _sourceLable = [self rp_addsubview:[UILabel class]];
        _sourceLable.font = [UIFont systemFontOfSize:12.0f];
        _sourceLable.textColor = [RedpacketColorStore rp_textColorGray];
    }
    return _sourceLable;
}

@end
