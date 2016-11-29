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

#define HeaderImageWith     40.0f
#define RedpacketMargin     15.0f
#define UserNameSize        14.0f
#define LabelHeight         20.0f

@interface RedpacketMessageCell ()

@property (nonatomic, strong) RedpacketView *redpacketView;

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

- (void)configWithRedpacketMessageModel:(RedpacketMessageModel *)model
                        andRedpacketDic:(NSDictionary *)redpacketDic
{
    UserInfo *currentUser = [RedpacketUser currentUser].userInfo;
    
    if (model.isRedacketSender) {
        
        [_headerImageView setImage:[UIImage imageNamed:currentUser.userAvatar]];
        _userNickNameLabel.text = [RedpacketUser currentUser].talkingUserInfo.userNickName;
        
    }else {
     
        [_headerImageView setImage:[UIImage imageNamed:currentUser.userAvatar]];
        _userNickNameLabel.text = [RedpacketUser currentUser].talkingUserInfo.userNickName;
        
    }
    
    [_redpacketView configWithRedpacketMessageModel:model
                                    andRedpacketDic:redpacketDic];
    
    [self swapSide:model.isRedacketSender];
    
}

- (void)swapSide:(BOOL)isSender
{
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
        
        frame = _redpacketView.frame;
        frame.origin.x = windowWith - RedpacketMargin * 2 - CGRectGetWidth(frame) - HeaderImageWith;
        frame.origin.y = RedpacketMargin * 2;
        _redpacketView.frame = frame;
        
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
        
        frame = _redpacketView.frame;
        frame.origin.x = RedpacketMargin * 2 + HeaderImageWith;
        frame.origin.y = RedpacketMargin * 2;
        _redpacketView.frame = frame;
    }
}

+ (CGFloat)heightForRedpacketMessageCell
{
    return [RedpacketView redpacketViewHeight];
}

@end
