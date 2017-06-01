//
//  RPReceiotsInAlipayHeaderView.m
//  RedpacketLib
//
//  Created by 都基鹏 on 2016/12/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPReceiotsInAlipayHeaderView.h"
#import "UIView+YZHExtension.h"
#import "RPLayout.h"
#import "RedpacketColorStore.h"
#import "RPRedpacketTool.h"
#import "UIButton+RPAction.h"
#import "UIImageView+YZHWebCache.h"


@interface RPReceiotsInAlipayHeaderViewButton : UIButton

@end

@implementation RPReceiotsInAlipayHeaderViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:[RedpacketColorStore rp_textColorRed] forState:UIControlStateNormal];
        [self setTitleColor:[RedpacketColorStore colorWithHexString:@"0xd24f44" alpha:0.4] forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.layer setCornerRadius:20];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[RedpacketColorStore rp_textColorRed].CGColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self.layer setBorderColor:[RedpacketColorStore colorWithHexString:@"0xd24f44" alpha:0.4].CGColor];
    }else{
        [self.layer setBorderColor:[RedpacketColorStore rp_textColorRed].CGColor];
    }
}

@end


@interface RPReceiotsInAlipayHeaderView()<UIActionSheetDelegate>

@property (nonatomic, weak)     UILabel     *moneyLable;
@property (nonatomic, weak)     UILabel     *receiveNumbersLable;
@property (nonatomic, weak)     UILabel     *bestLuckyNumbersLable;
@property (nonatomic, weak)     UIImageView *headImageView;
@property (nonatomic, weak)     UILabel     *themeDescribeLable;
@property (nonatomic, weak)     UILabel     *receiveDescribeLable;
@property (nonatomic, weak)     UILabel     *bestLuckyDescibeLable;
@property (nonatomic, weak)     UILabel     *sendNumbersLable;
@property (nonatomic, weak)     UIButton    *describeLable;
@property (nonatomic, weak)     UIButton    *bindingButton;
@property (nonatomic, weak)     UIButton    *removeBindingButton;
@property (nonatomic, weak)     UIView      *lineView;
@property (nonatomic, weak)     UIView      *gapView;
@property (nonatomic, weak)     UIImageView *arrowView;

@end

@implementation RPReceiotsInAlipayHeaderView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.headImageView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.rpm_top).offset(47);
        make.centerX.equalTo(self.rpm_centerX).offset(0);
        make.width.offset(57);
        make.height.offset(57);
    }];
    
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 57 / 2.0f;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView rp_setImageWithURL:[NSURL URLWithString:[RPRedpacketAliauth redpacketCurrentUser].avatar] placeholderImage:rpRedpacketBundleImage(@"redpacket_header_default")];
    
    [self.themeDescribeLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.headImageView.rpm_bottom).offset(14);
        make.centerX.equalTo(self.rpm_centerX).offset(0);
    }];
    [self.moneyLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.themeDescribeLable.rpm_bottom).offset(24);
        make.centerX.equalTo(self.rpm_centerX).offset(0);
        make.height.offset(40);
    }];
    
    [self.sendNumbersLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self.rpm_bottom).offset(-38.5);
        make.centerX.equalTo(self.rpm_centerX).offset(0);
    }];
    
    [self.receiveDescribeLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-11);
        make.left.equalTo(self.rpm_left).offset(0);
        make.right.equalTo(self.rpm_centerX).offset(0);
    }];
    self.receiveDescribeLable.text = @"收到红包";
    
    [self.receiveNumbersLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self.receiveDescribeLable.rpm_top).offset(-11);
        make.left.equalTo(self.rpm_left).offset(0);
        make.right.equalTo(self.rpm_centerX).offset(0);
    }];
    
    [self.bestLuckyDescibeLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self.receiveDescribeLable);
        make.left.equalTo(self.rpm_centerX).offset(0);
        make.right.equalTo(self.rpm_right).offset(0);
    }];
    self.bestLuckyDescibeLable.text = @"手气最佳";
    
    [self.bestLuckyNumbersLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self.receiveNumbersLable);
        make.left.equalTo(self.rpm_centerX).offset(0);
        make.right.equalTo(self.rpm_right).offset(0);
    }];
    
    UIView * lineView = [self rp_addsubview:[UIView class]];
    lineView.backgroundColor = [RedpacketColorStore rp_lineColorLightGray];
    [lineView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.offset(RP_(@(0.5)).floatValue);
        make.bottom.equalTo(self);
    }];
    
    [self.headImageView rpm_updateConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.rpm_top).offset(30);
    }];
    
    self.bindingButton = [self rp_addsubview:[RPReceiotsInAlipayHeaderViewButton class]];
    [self.bindingButton addTarget:self action:@selector(doAlipayAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.bindingButton setTitle:@"绑定支付宝" forState:UIControlStateNormal];
    [self.bindingButton rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.moneyLable.rpm_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.offset(156);
        make.height.offset(40);
    }];
    
    self.describeLable = [self rp_addsubview:[UIButton class]];
    [self.describeLable setTitleColor:[RedpacketColorStore rp_textColorGray] forState:UIControlStateNormal];
    self.describeLable.titleLabel.font = [UIFont systemFontOfSize:13];
    self.describeLable.titleLabel.numberOfLines = 2;
    self.describeLable.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.describeLable rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.offset(13);
    }];
    
    self.removeBindingButton = [self rp_addsubview:[UIButton class]];
    [self.removeBindingButton addTarget:self action:@selector(removeBinding) forControlEvents:UIControlEventTouchUpInside];
    [self.removeBindingButton setTitleColor:[RedpacketColorStore rp_colorWithHEX:0x35b7f3] forState:UIControlStateNormal];
    self.removeBindingButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.removeBindingButton.hidden = YES;
    self.removeBindingButton.rp_hitTestEdgeInsets = UIEdgeInsetsMake(-40, -150, -40, -150);
    [self.removeBindingButton rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.top.equalTo(self.describeLable.rpm_bottom).offset(11);
        make.centerX.equalTo(self);
        make.height.offset(13);
    }];
    
    self.arrowView = [self rp_addsubview:[UIImageView class]];
    self.arrowView.image = rpRedpacketBundleImage(@"alipay_name_bluearrow");
    [self.arrowView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.left.equalTo(self.removeBindingButton.rpm_right).offset(2);
        make.centerY.equalTo(self.removeBindingButton);
        make.height.offset(14);
        make.width.offset(8);
    }];
    self.arrowView.hidden = YES;
    
    self.lineView = [self rp_addsubview:[UIView class]];
    self.lineView.backgroundColor = [RedpacketColorStore rp_lineColorLightGray];
    [self.lineView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-80);
        make.left.and.right.equalTo(self);
        make.height.offset(RP_(@(0.5)).floatValue);
    }];
    
    self.gapView = [self rp_addsubview:[UIView class]];
    self.gapView.backgroundColor = [RedpacketColorStore rp_lineColorLightGray];
    [self.gapView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.width.offset(0.5);
        make.centerX.equalTo(self);
        make.top.equalTo(self.lineView).offset(10);
        make.bottom.equalTo(self.rpm_bottom).offset(-10);
    }];
    
    [self.receiveDescribeLable rpm_updateConstraints:^(RPConstraintMaker *make) {
        make.height.offset(13);
    }];
    
    [self.receiveNumbersLable rpm_updateConstraints:^(RPConstraintMaker *make) {
        make.height.offset(34);
    }];
    
    [self.bestLuckyDescibeLable rpm_updateConstraints:^(RPConstraintMaker *make) {
        make.height.offset(13);
    }];
    
    [self.bestLuckyNumbersLable rpm_updateConstraints:^(RPConstraintMaker *make) {
        make.height.offset(34);
    }];
    
    return self;
}

- (void)doAlipayAuth {
    if ([self.delegate respondsToSelector:@selector(doAlipayAuth)]) {
        [self.delegate doAlipayAuth];
    }
}

- (void)removeBinding {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"解绑支付宝"
                                  otherButtonTitles:nil,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(removeBinding)]) {
            [self.delegate removeBinding];
        }
    }
}

- (void)setPersonalRedpacketType:(RPPersonalRedpacketType)personalRedpacketType
{
    _personalRedpacketType = personalRedpacketType;
    self.sendNumbersLable.hidden = personalRedpacketType != RPPersonalRedpacketTypeSend;
    self.receiveNumbersLable.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.receiveDescribeLable.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.bestLuckyNumbersLable.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.bestLuckyDescibeLable.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.themeDescribeLable.text = [NSString stringWithFormat:@"%@%@", [RPRedpacketAliauth redpacketCurrentUser].userName,self.personalRedpacketType == RPPersonalRedpacketTypeSend?@"共发出":@"共收到"];
    self.lineView.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.gapView.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.describeLable.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.bindingButton.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.arrowView.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    self.removeBindingButton.hidden = personalRedpacketType == RPPersonalRedpacketTypeSend;
    [self updateConstraintsIfNeeded];
    
}

- (void)setUsername:(NSString *)username {
    _username = username;
    if (self.personalRedpacketType == RPPersonalRedpacketTypeSend) return;
    if (_username && username.length) {
        self.bindingButton.hidden = YES;
        [self.describeLable setTitle:@"红包会自动入账到支付宝账号" forState:UIControlStateNormal];
        self.removeBindingButton.hidden = NO;
        [self.removeBindingButton setTitle:username forState:UIControlStateNormal];
        [self.describeLable rpm_updateConstraints:^(RPConstraintMaker *make) {
            make.top.equalTo(self.moneyLable.rpm_bottom).offset(24);
        }];
        self.arrowView.hidden = NO;
    }else {
        self.arrowView.hidden = YES;
        self.removeBindingButton.hidden = YES;
        [self.describeLable setTitle:@"绑定后，收到的红包会自动入账到支付宝账号" forState:UIControlStateNormal];
        [self.describeLable rpm_updateConstraints:^(RPConstraintMaker *make) {
            make.top.equalTo(self.moneyLable.rpm_bottom).offset(76);
        }];
    }
    [self updateConstraintsIfNeeded];
}

- (void)setPersonalRedpacketInfo:(RPPersonalRedpacketInfo *)personalRedpacketInfo
{
    _personalRedpacketInfo = personalRedpacketInfo;
    NSString *money, *totalCout;
    if (self.personalRedpacketType == RPPersonalRedpacketTypeReceive) {
        money = personalRedpacketInfo.totalReceiveMoney;
        totalCout = [NSString stringWithFormat:@"%ld",(long)personalRedpacketInfo.totalReceiveCount];
    } else {
        money = personalRedpacketInfo.totalSendMoney;
        totalCout = [NSString stringWithFormat:@"%ld",(long)personalRedpacketInfo.totalSendCount];
    }
    if (!money)  return;
    
    if (money.length == 0) {
        money = @"0.00";
    }
    self.moneyLable.text = [@"¥ " stringByAppendingString:money];
    if (self.personalRedpacketType == RPPersonalRedpacketTypeSend) {
        NSString *string;
        string = [NSString stringWithFormat:@"发出红包%@个",totalCout];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:[RedpacketColorStore rp_textColorBlack] range:NSMakeRange(0,4)];
        [str addAttribute:NSForegroundColorAttributeName value:[RedpacketColorStore rp_textColorBlack] range:NSMakeRange(string.length - 1,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[RedpacketColorStore rp_textColorRed] range:NSMakeRange(4,string.length - 5)];
        self.sendNumbersLable.attributedText = str;
    }else
    {
        self.bestLuckyNumbersLable.text = [NSString stringWithFormat:@"%ld",(long)personalRedpacketInfo.bestReceiveCount];
        self.receiveNumbersLable.text = [NSString stringWithFormat:@"%@",totalCout];
    }
    
    if (money.length) {
        self.bestLuckyNumbersLable.textColor = [RedpacketColorStore rp_textColorBlack6];
        self.receiveNumbersLable.textColor = [RedpacketColorStore rp_textColorBlack6];
    }else {
        self.bestLuckyNumbersLable.textColor = [RedpacketColorStore rp_textColorGray];
        self.receiveNumbersLable.textColor = [RedpacketColorStore rp_textColorGray];
    }
    
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [self rp_addsubview:[UIImageView class]];
        _headImageView.backgroundColor = [RedpacketColorStore rp_backGroundGrayColor];
    }
    return _headImageView;
}

- (UILabel *)themeDescribeLable
{
    if (!_themeDescribeLable) {
        _themeDescribeLable = [self rp_addsubview:[UILabel class]];
        _themeDescribeLable.font = [UIFont systemFontOfSize:15.0f];
        _themeDescribeLable.textColor = [RedpacketColorStore rp_textColorBlack6];
    }
    return _themeDescribeLable;
}

- (UILabel *)moneyLable
{
    if (!_moneyLable) {
        _moneyLable = [self rp_addsubview:[UILabel class]];
        _moneyLable.font = [UIFont systemFontOfSize:44.0f];
        _moneyLable.textColor = [RedpacketColorStore rp_textColorBlack];
        _moneyLable.text = @"¥ 0.00";
    }
    return _moneyLable;
}

- (UILabel *)receiveNumbersLable
{
    if (!_receiveNumbersLable) {
        _receiveNumbersLable = [self rp_addsubview:[UILabel class]];
        _receiveNumbersLable.font = [UIFont systemFontOfSize:36.0f];
        _receiveNumbersLable.textColor = [RedpacketColorStore rp_textColorGray];
        _receiveNumbersLable.textAlignment = NSTextAlignmentCenter;
        _receiveNumbersLable.text = @"0";
    }
    return _receiveNumbersLable;
}

- (UILabel *)receiveDescribeLable
{
    if (!_receiveDescribeLable) {
        _receiveDescribeLable =[self rp_addsubview:[UILabel class]];
        _receiveDescribeLable.font = [UIFont systemFontOfSize:13.0f];
        _receiveDescribeLable.textColor = [RedpacketColorStore rp_textColorGray];
        _receiveDescribeLable.textAlignment = NSTextAlignmentCenter;
    }
    return _receiveDescribeLable;
}

- (UILabel *)bestLuckyNumbersLable
{
    if (!_bestLuckyNumbersLable) {
        _bestLuckyNumbersLable = [self rp_addsubview:[UILabel class]];
        _bestLuckyNumbersLable.font = [UIFont systemFontOfSize:36.0f];
        _bestLuckyNumbersLable.textColor = [RedpacketColorStore rp_textColorGray];
        _bestLuckyNumbersLable.textAlignment = NSTextAlignmentCenter;
        _bestLuckyNumbersLable.text = @"0";
    }
    return _bestLuckyNumbersLable;
}

- (UILabel *)bestLuckyDescibeLable
{
    if (!_bestLuckyDescibeLable) {
        _bestLuckyDescibeLable = [self rp_addsubview:[UILabel class]];
        _bestLuckyDescibeLable.font = [UIFont systemFontOfSize:13.0f];
        _bestLuckyDescibeLable.textColor = [RedpacketColorStore rp_textColorGray];
        _bestLuckyDescibeLable.textAlignment = NSTextAlignmentCenter;
    }
    return  _bestLuckyDescibeLable;
}

- (UILabel *)sendNumbersLable
{
    if (!_sendNumbersLable) {
        _sendNumbersLable = [self rp_addsubview:[UILabel class]];
        _sendNumbersLable.font = [UIFont systemFontOfSize:15.0f];
    }
    return _sendNumbersLable;
}


@end
