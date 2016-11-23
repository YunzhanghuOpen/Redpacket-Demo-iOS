//
//  RedpacketView.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/21.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketView.h"
#import "RedpacketUser.h"

#define Redpacket_Message_Font_Size     14
#define Redpacket_SubMessage_Font_Size  12
#define Redpacket_SubMessage_Text NSLocalizedString(@"查看红包", @"查看红包")
#define REDPACKET_BUNDLE(name) @"RedpacketCellResource.bundle/" name
#define kPeerNameZoneHeight(displayPeerName)  (displayPeerName ? kXHPeerNameLabelHeight : 0)

@implementation RedpacketView

+ (CGFloat)heightForRedpacketMessageCell
{
    return 114;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }

    return self;
}

- (void)initialize {
    
    self.bubbleBackgroundView = [UIImageView new];
    // 设置红包图标
    UIImage *icon = [UIImage imageNamed:REDPACKET_BUNDLE(@"redPacket_redPacktIcon")];
    self.iconView = [[UIImageView alloc] initWithImage:icon];
    self.iconView.frame = CGRectMake(13, 19, 26, 34);
    [self.bubbleBackgroundView addSubview:self.iconView];
    
    // 设置红包文字
    self.greetingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.greetingLabel.frame = CGRectMake(48, 19, 137, 15);
    self.greetingLabel.font = [UIFont systemFontOfSize:Redpacket_Message_Font_Size];
    self.greetingLabel.textColor = [UIColor whiteColor];
    self.greetingLabel.numberOfLines = 1;
    [self.greetingLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.greetingLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.greetingLabel];
    
    // 设置次级文字
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    CGRect frame = self.greetingLabel.frame;
    frame.origin.y = 41;
    self.subLabel.frame = frame;
    self.subLabel.text = Redpacket_SubMessage_Text;
    self.subLabel.font = [UIFont systemFontOfSize:Redpacket_SubMessage_Font_Size];
    self.subLabel.numberOfLines = 1;
    self.subLabel.textColor = [UIColor whiteColor];
    [self.subLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.subLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.subLabel];
    
    // 红包出处
    self.orgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.orgLabel.frame = CGRectMake(13, 76, 150, 12);
    self.orgLabel.font = [UIFont systemFontOfSize:Redpacket_SubMessage_Font_Size];
    self.orgLabel.numberOfLines = 1;
    self.orgLabel.textColor = [UIColor lightGrayColor];
    [self.orgLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.orgLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.orgLabel];
    
    self.typeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 76, 180, 12)];
    self.typeLable.font = [UIFont systemFontOfSize:Redpacket_SubMessage_Font_Size];
    self.typeLable.textColor = [UIColor redColor];
    self.typeLable.textAlignment = NSTextAlignmentRight;
    [self.bubbleBackgroundView addSubview:self.typeLable];
    
    self.orgIconView = [[UIImageView alloc] initWithImage:icon];
    [self.bubbleBackgroundView addSubview:self.orgIconView];
    CGRect rt = self.orgIconView.frame;
    rt.origin = CGPointMake(165, 75);
    rt.size = CGSizeMake(21, 14);
    self.orgIconView.frame = rt;
    _orgIconView.hidden = YES;
    
    CGFloat bubbleX = 10.0f;
    
    CGFloat bubbleViewY = 10.0f;
    
    frame = CGRectMake(bubbleX,
                              bubbleViewY,
                              198,
                              94);
    self.bubbleBackgroundView.frame = frame;
    
    [self addSubview:self.bubbleBackgroundView];
    
    frame = CGRectMake(0,
                       0,
                       218,
                       114);
    
    self.frame = frame;

}

- (void)configWithRedpacketMessageModel:(RedpacketMessageModel *)redpacketMessage
{
    self.greetingLabel.text = redpacketMessage.redpacket.redpacketGreeting;
    self.orgLabel.text = redpacketMessage.redpacket.redpacketOrgName;
    
    // 设置红包文字
    self.bubbleBackgroundView.frame = CGRectMake(-8, 0, 198, 94);
    UIImage *image;
    
#pragma mark - Redpacket
    UserInfo *currentUser = [RedpacketUser currentUser].userInfo;
    BOOL isSender = [currentUser.userId isEqualToString:redpacketMessage.redpacketSender.userId];
    if (!isSender) {
        
        image = [UIImage imageNamed:REDPACKET_BUNDLE(@"redpacket_receiver_bg")];
        
    } else {
        
        image = [UIImage imageNamed:REDPACKET_BUNDLE(@"redpacket_sender_bg")];
        
    }
    
    self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(70, 9, 25, 20)];
    
    if (redpacketMessage.redpacketType == RedpacketTypeMember) {
        self.typeLable.text = @"专属红包";
    }else {
        self.typeLable.hidden = YES;
    }
}

@end
