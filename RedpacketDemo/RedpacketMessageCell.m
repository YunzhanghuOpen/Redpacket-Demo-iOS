//
//  RedpacketMessageCell.m
//  LeanChat
//
//  Created by YANG HONGBO on 2016-5-7.
//  Copyright © 2016年 云帐户. All rights reserved.
//

#import "RedpacketMessageCell.h"
#import "RedpacketUser.h"
#import "RedpacketView.h"
#import "RedPacketLuckView.h"


#define HeaderImageWith     40.0f
#define RedpacketMargin     15.0f
#define UserNameSize        14.0f
#define LabelHeight         20.0f

@interface RedpacketMessageCell ()

@property (nonatomic, strong) RedpacketView     *redpacketView;
@property (nonatomic, strong) RedPacketLuckView *redpacketLuckView;
#ifdef AliAuthPay
@property (nonatomic, strong) RPRedpacketModel *redpacketMessageModel;
#else
@property (nonatomic, strong) RedpacketMessageModel *redpacketMessageModel;
#endif
@end

@implementation RedpacketMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _userNickNameLabel = [UILabel new];
        _userNickNameLabel.font = [UIFont systemFontOfSize:UserNameSize];
        
        _headerImageView = [UIImageView new];
        _headerImageView.frame = CGRectMake(0, 0, HeaderImageWith, HeaderImageWith);
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = HeaderImageWith / 2.0f;
        
        _redpacketView = [RedpacketView new];
        
        [self.contentView addSubview:_redpacketView];
        [self.contentView addSubview:_userNickNameLabel];
        [self.contentView addSubview:_headerImageView];
        [self.contentView addSubview:_redpacketView];
    }
    
    return self;
}
#ifdef AliAuthPay
- (void)configWithRedpacketMessageModel:(RPRedpacketModel *)model
                        andRedpacketDic:(NSDictionary *)redpacketDic
{
    if (model.redpacketType == RPRedpacketTypeAmount) {
        
        [_redpacketView removeFromSuperview];
        if (!_redpacketLuckView) {
            _redpacketLuckView = [RedPacketLuckView new];
        }
        [self.contentView addSubview:_redpacketLuckView];
        
        [_redpacketLuckView configWithRedpacketMessageModel:model];
        
    }else {
        
        [_redpacketLuckView removeFromSuperview];
        if (!_redpacketView) {
            _redpacketView = [RedpacketView new];
        }
        
        [self.contentView addSubview:_redpacketView];
        
        [_redpacketView configWithRedpacketMessageModel:model
                                        andRedpacketDic:redpacketDic];
    }
    
    UserInfo *currentUser = [RedpacketUser currentUser].userInfo;
    
    if (model.isSender) {
        
        [_headerImageView setImage:[UIImage imageNamed:currentUser.userAvatar]];
        _userNickNameLabel.text = [RedpacketUser currentUser].userInfo.userNickName;
        
    }else {
        
        [_headerImageView setImage:[UIImage imageNamed:[RedpacketUser currentUser].talkingUserInfo.userAvatar]];
        _userNickNameLabel.text = [RedpacketUser currentUser].talkingUserInfo.userNickName;
        
    }
    
    [self swapSide:model.isSender withRedpacketModel:model];
    
}

- (void)swapSide:(BOOL)isSender withRedpacketModel:(RPRedpacketModel *)model
{
    UIView *adjustView = _redpacketView;
    
    if (model.redpacketType == RPRedpacketTypeAmount) {
        adjustView = _redpacketLuckView;
    }
    
    if (isSender) {
        
        CGRect windowFrame = [UIScreen mainScreen].bounds;
        CGFloat windowWith = CGRectGetWidth(windowFrame);
        
        CGRect frame = _headerImageView.frame;
        frame.origin.x = windowWith - RedpacketMargin - HeaderImageWith;
        frame.origin.y = RedpacketMargin;
        _headerImageView.frame = frame;
        
        [_userNickNameLabel sizeToFit];
        frame = _userNickNameLabel.frame;
        frame.origin.x = windowWith - RedpacketMargin * 2 - CGRectGetWidth(frame) - HeaderImageWith;
        frame.origin.y = RedpacketMargin;
        frame.size.height = LabelHeight;
        _userNickNameLabel.frame = frame;
        
        frame = adjustView.frame;
        frame.origin.x = windowWith - RedpacketMargin * 2 - CGRectGetWidth(frame) - HeaderImageWith;
        frame.origin.y = RedpacketMargin * 3;
        adjustView.frame = frame;
        
    }else {
        
        CGRect frame = _headerImageView.frame;
        frame.origin.x = RedpacketMargin;
        frame.origin.y = RedpacketMargin;
        _headerImageView.frame = frame;
        
        [_userNickNameLabel sizeToFit];
        frame = _userNickNameLabel.frame;
        frame.origin.x = RedpacketMargin * 2 + HeaderImageWith;
        frame.origin.y = RedpacketMargin;
        frame.size.height = LabelHeight;
        _userNickNameLabel.frame = frame;
        
        frame = adjustView.frame;
        frame.origin.x = RedpacketMargin * 2 + HeaderImageWith;
        frame.origin.y = RedpacketMargin * 3;
        adjustView.frame = frame;
    }
}

+ (CGFloat)heightForRedpacketMessageCell:(RPRedpacketModel *)model
{
    if (model.redpacketType == RPRedpacketTypeAmount) {
        return [RedPacketLuckView heightForRedpacketMessageCell] + 50;
    }
    
    return [RedpacketView redpacketViewHeight] + 30;
}
#else
- (void)configWithRedpacketMessageModel:(RedpacketMessageModel *)model
                        andRedpacketDic:(NSDictionary *)redpacketDic
{
    if (model.redpacketType == RedpacketTypeAmount) {
        
        [_redpacketView removeFromSuperview];
        if (!_redpacketLuckView) {
            _redpacketLuckView = [RedPacketLuckView new];
        }
        [self.contentView addSubview:_redpacketLuckView];
        
        [_redpacketLuckView configWithRedpacketMessageModel:model];
        
    }else {
        
        [_redpacketLuckView removeFromSuperview];
        if (!_redpacketView) {
            _redpacketView = [RedpacketView new];
        }
        
        [self.contentView addSubview:_redpacketView];
        
        [_redpacketView configWithRedpacketMessageModel:model
                                        andRedpacketDic:redpacketDic];
    }
    
    UserInfo *currentUser = [RedpacketUser currentUser].userInfo;
    
    if (model.isRedacketSender) {
        
        [_headerImageView setImage:[UIImage imageNamed:currentUser.userAvatar]];
        _userNickNameLabel.text = [RedpacketUser currentUser].userInfo.userNickName;
        
    }else {
        
        [_headerImageView setImage:[UIImage imageNamed:[RedpacketUser currentUser].talkingUserInfo.userAvatar]];
        _userNickNameLabel.text = [RedpacketUser currentUser].talkingUserInfo.userNickName;
        
    }
    
    [self swapSide:model.isRedacketSender withRedpacketModel:model];
    
}

- (void)swapSide:(BOOL)isSender withRedpacketModel:(RedpacketMessageModel *)model
{
    UIView *adjustView = _redpacketView;
    
    if (model.redpacketType == RedpacketTypeAmount) {
        adjustView = _redpacketLuckView;
    }
    
    if (isSender) {
        
        CGRect windowFrame = [UIScreen mainScreen].bounds;
        CGFloat windowWith = CGRectGetWidth(windowFrame);
        
        CGRect frame = _headerImageView.frame;
        frame.origin.x = windowWith - RedpacketMargin - HeaderImageWith;
        frame.origin.y = RedpacketMargin;
        _headerImageView.frame = frame;
        
        [_userNickNameLabel sizeToFit];
        frame = _userNickNameLabel.frame;
        frame.origin.x = windowWith - RedpacketMargin * 2 - CGRectGetWidth(frame) - HeaderImageWith;
        frame.origin.y = RedpacketMargin;
        frame.size.height = LabelHeight;
        _userNickNameLabel.frame = frame;
        
        frame = adjustView.frame;
        frame.origin.x = windowWith - RedpacketMargin * 2 - CGRectGetWidth(frame) - HeaderImageWith;
        frame.origin.y = RedpacketMargin * 3;
        adjustView.frame = frame;
        
    }else {
        
        CGRect frame = _headerImageView.frame;
        frame.origin.x = RedpacketMargin;
        frame.origin.y = RedpacketMargin;
        _headerImageView.frame = frame;
        
        [_userNickNameLabel sizeToFit];
        frame = _userNickNameLabel.frame;
        frame.origin.x = RedpacketMargin * 2 + HeaderImageWith;
        frame.origin.y = RedpacketMargin;
        frame.size.height = LabelHeight;
        _userNickNameLabel.frame = frame;
        
        frame = adjustView.frame;
        frame.origin.x = RedpacketMargin * 2 + HeaderImageWith;
        frame.origin.y = RedpacketMargin * 3;
        adjustView.frame = frame;
    }
}

+ (CGFloat)heightForRedpacketMessageCell:(RedpacketMessageModel *)model
{
    if (model.redpacketType == RedpacketTypeAmount) {
        return [RedPacketLuckView heightForRedpacketMessageCell] + 50;
    }
    
    return [RedpacketView redpacketViewHeight] + 30;
}

#endif
@end
