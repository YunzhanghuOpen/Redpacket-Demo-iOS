//
//  RPSendRedPacketItem.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/8/2.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPSendRedPacketItem.h"
#import "RPRedpacketSetting.h"
#import "RPRedpacketTool.h"


@interface RPSendRedPacketItem()

 //红包个数
@property (nonatomic,strong)NSDecimalNumber * cachePacketCount;

@end


@implementation RPSendRedPacketItem
@synthesize messageModel = _messageModel;
@synthesize totalMoney = _totalMoney;
@synthesize price = _price;
@synthesize maxTotalMoney = _maxTotalMoney;
@synthesize minTotalMoney = _minTotalMoney;

- (void)setInputMoney:(NSDecimalNumber *)inputMoney {
    _inputMoney = inputMoney;
    [self caculateTotalMoney];
}

- (void)setCheckChangeWarningTitle:(BOOL)checkChangeWarningTitle {
    _checkChangeWarningTitle = checkChangeWarningTitle;
    [self caculateTotalMoney];
}

- (void)setPacketCount:(NSDecimalNumber *)packetCount {
    if (_packetCount != packetCount) {
        _packetCount = packetCount;
        _cachePacketCount = packetCount;
        [self caculateTotalMoney];
    }
}

- (void)setMemberList:(NSArray<RPUserInfo *> *)memberList {
    if (_memberList != memberList) {
        _memberList = memberList;
        _packetCount = [NSDecimalNumber decimalNumberWithMantissa:memberList?1:_cachePacketCount.integerValue exponent:0 isNegative:NO];
        [self caculateTotalMoney];
    }
}

- (void)setRedPacketType:(RPRedpacketType)redPacketType {
    if (_redPacketType != redPacketType) {
        _redPacketType = redPacketType;
        _cacheRedPacketType = (redPacketType == RPRedpacketTypeGoupMember)? _cacheRedPacketType : redPacketType;
        [self caculateTotalMoney];
    }
}

- (NSDecimalNumber *)totalMoney{
    switch (self.redPacketType) {
        case RPRedpacketTypeGroupAvg: {
            _totalMoney = [self.price decimalNumberByMultiplyingBy:self.packetCount.integerValue>0?self.packetCount:[NSDecimalNumber one]];
            break;
        }
        case RPRedpacketTypeSingle:
        case RPRedpacketTypeGroupRand:
        case RPRedpacketTypeGoupMember: {
            _totalMoney = self.inputMoney;
            break;
        }
        default:
            _totalMoney = [self.price decimalNumberByMultiplyingBy:self.packetCount.integerValue>0?self.packetCount:[NSDecimalNumber one]];
            break;
    }
    return _totalMoney;
}

- (NSDecimalNumber *)price {
    
    switch (self.redPacketType) {
        case RPRedpacketTypeGroupRand: {
            NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                               decimalNumberHandlerWithRoundingMode:NSRoundDown
                                               scale:0
                                               raiseOnExactness:NO
                                               raiseOnOverflow:NO
                                               raiseOnUnderflow:NO
                                               raiseOnDivideByZero:YES];
            _price = (self.packetCount.integerValue >0)?[self.inputMoney decimalNumberByDividingBy:self.packetCount withBehavior:roundUp]:[NSDecimalNumber zero];
            break;
        }
            
        case RPRedpacketTypeSingle:
        case RPRedpacketTypeGroupAvg:
        case RPRedpacketTypeGoupMember: {
            _price = self.inputMoney;
            break;
        }
            
        default:
            _price = self.inputMoney;
            break;
    }
    
    return _price;
}

- (NSNumber *)minTotalMoney {
    
    CGFloat minPrice = [RPRedpacketSetting shareInstance].redpacketMinMoney;
    NSDecimalNumber * mPrice = [NSDecimalNumber decimalNumberWithMantissa:minPrice exponent:0 isNegative:NO];
    
    switch (self.redPacketType) {
        case RPRedpacketTypeGroupRand:
        case RPRedpacketTypeSingle:
        case RPRedpacketTypeGoupMember: {
            
            _minTotalMoney = (self.packetCount > 0) ? [self.packetCount decimalNumberByMultiplyingBy:mPrice]:mPrice;
            break;
        }
            
        case RPRedpacketTypeGroupAvg: {
            _minTotalMoney = @(minPrice);
            break;
        }
            
        default:
            _minTotalMoney = [self.packetCount decimalNumberByMultiplyingBy:mPrice];
            break;
    }
    
    return _minTotalMoney;
}

- (NSNumber *)maxTotalMoney {
    
    CGFloat maxPrice = [RPRedpacketSetting shareInstance].singlePayLimit;
    NSDecimalNumber * mPrice = [NSDecimalNumber decimalNumberWithMantissa:maxPrice exponent:0 isNegative:NO];
    
    switch (self.redPacketType) {
        case RPRedpacketTypeGroupRand: {
            _maxTotalMoney = (self.packetCount.integerValue >0)?[self.packetCount decimalNumberByMultiplyingBy:mPrice]:[NSDecimalNumber maximumDecimalNumber];
            break;
        }
            
        case RPRedpacketTypeSingle:
        case RPRedpacketTypeGroupAvg:
        case RPRedpacketTypeGoupMember: {
            _maxTotalMoney = [NSNumber numberWithFloat:maxPrice];
            break;
        }
            
        default:
            _maxTotalMoney = [NSNumber numberWithFloat:maxPrice];
            break;
    }
    
    return _maxTotalMoney;
}

- (void)caculateTotalMoney {
    
    RPRedpacketSetting * manager = [RPRedpacketSetting shareInstance];
    NSNumber * minPrice = [NSNumber numberWithFloat:manager.redpacketMinMoney * 100.0f];
    NSNumber * maxPrice = [NSNumber numberWithFloat:manager.singlePayLimit * 100.0f];
    NSNumber * maxCount = [NSNumber numberWithInteger:manager.maxRedpacketCount];
    _warningTittle = @"";
    _submitEnable = (([self.price compare:minPrice] != NSOrderedAscending) && ([self.price compare:maxPrice] != NSOrderedDescending)) && self.price;
    
    switch (self.redPacketType) {
            
        case RPRedpacketTypeSingle: {
            self.packetCount = [NSDecimalNumber one];
        }
            
        case RPRedpacketTypeGroupRand:
        case RPRedpacketTypeGroupAvg: {
            break;
        }
            
        case RPRedpacketTypeGoupMember: {
            _submitEnable = self.memberList.count && self.price;
            break;
        }
            
        default:
            break;
    }
    
    if ([self.price compare:maxPrice] == NSOrderedDescending) {
        
        _warningTittle = [NSString stringWithFormat:@"单个红包金额不能超过%@元", @(manager.singlePayLimit)];
        _submitEnable = NO;
        
    }else if([self.packetCount compare:maxCount] == NSOrderedDescending) {
        
        _warningTittle = [NSString stringWithFormat:@"一次最多发%@个红包",maxCount];
        _submitEnable = NO;
        
    }else if(self.packetCount.integerValue < 1){
        
        _warningTittle = @"请输入红包个数";
        _submitEnable = NO;
        
    }else if([self.price compare:minPrice] == NSOrderedAscending){
        
        _submitEnable = NO;
        if (self.inputMoney.integerValue > 0) {
            
            _warningTittle = [NSString stringWithFormat:@"单个红包金额最少不能少于%.2f元",manager.redpacketMinMoney];
            
        }else if ([self.inputMoney compare:@(0)] == NSOrderedSame && self.checkChangeWarningTitle) {
            
            _warningTittle = @"金额输入错误";
            
        }
        
    }
}

- (void)alterRedpacketPlayType {

    switch (self.redPacketType) {
        case RPRedpacketTypeGroupRand: {
            if (self.packetCount) {
                NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                                   decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                   scale:0
                                                   raiseOnExactness:NO
                                                   raiseOnOverflow:NO
                                                   raiseOnUnderflow:NO
                                                   raiseOnDivideByZero:YES];
                
                _inputMoney = [self.totalMoney decimalNumberByDividingBy:self.packetCount withBehavior:roundUp];
                
            }
            
            self.redPacketType = RPRedpacketTypeGroupAvg;
            break;
        }
            
        case RPRedpacketTypeGroupAvg: {
            _inputMoney = self.totalMoney;
            self.redPacketType = RPRedpacketTypeGroupRand;
            break;
        }
            
        default:
            break;
    }
}

- (RPRedpacketModel *)messageModel {

    NSString *message = [self.congratulateTittle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (self.congratulateTittle > 0) {
        
        self.congratulateTittle = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }else{
        
        self.congratulateTittle = @"恭喜发财，大吉大利！";
        
    }
    
    if (self.redPacketType == RPRedpacketTypeSingle) {
        
        return [RPRedpacketModel generateSingleRedpacketInfo:self.redPacketType
                                                    receiver:self.conversationInfo
                                              redpacketMoney:rpString(@"%.2f", self.totalMoney.floatValue/100.0f)
                                                 andGreeting:self.congratulateTittle];
        
    } else if (self.redPacketType == RPRedpacketTypeGroupRand ||
               self.redPacketType == RPRedpacketTypeGroupAvg) {
        
        return [RPRedpacketModel generateGroupRedpacketInfo:self.redPacketType
                                                    groupID:self.conversationInfo.userID
                                             redpacketMoney:rpString(@"%.2f", self.totalMoney.floatValue/100.0f)
                                                      count:self.packetCount.integerValue
                                                andGreeting:self.congratulateTittle];
        
    } else if (self.redPacketType == RPRedpacketTypeGoupMember) {
        
        return [RPRedpacketModel generateGroupRedpacketInfo:self.redPacketType
                                                    groupID:self.conversationInfo.userID
                                                   receiver:self.memberList[0] redpacketMoney:rpString(@"%.2f", self.totalMoney.floatValue/100.0f)
                                                      count:self.packetCount.integerValue
                                                andGreeting:self.self.congratulateTittle];
        
    }
    
    return nil;
}

- (NSString *)congratulateTittle
{
    if (_congratulateTittle.length > 0) {
        
        return [_congratulateTittle stringByReplacingOccurrencesOfString:@"\n"
                                                              withString:@""];
    }
    
    return @"恭喜发财，大吉大利！";
}

@end
