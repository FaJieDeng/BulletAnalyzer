//
//  BAGiftModel.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAGiftModel.h"
#import "BAUserModel.h"
#import "BABulletModel.h"
#import "MJExtension.h"

@interface BAGiftModel()
@property (nonatomic, assign, getter=isstatusReady) BOOL statusReady;

@end

@implementation BAGiftModel

MJCodingImplementation

- (void)setIc:(NSString *)ic{
    _ic = ic;
    
    if (_ic.length) {
        NSString *urlStr = [ic stringByReplacingOccurrencesOfString:@"@S" withString:@"/"];
        urlStr = [BADouyuImgBaicUrl stringByAppendingString:urlStr];
        _iconSmall = [urlStr stringByAppendingString:BADouyuImgSmallSuffix];
        _iconMiddle = [urlStr stringByAppendingString:BADouyuImgMiddleSuffix];
        _iconBig = [urlStr stringByAppendingString:BADouyuImgBigSuffix];
    }
}


- (void)setGs:(NSString *)gs{
    _gs = gs;
    
    self.statusReady = self.type.length;
}


- (void)setType:(NSString *)type{
    [super setType:type];
    
    self.statusReady = _gs.length;
}


- (void)setStatusReady:(BOOL)statusReady{
    _statusReady = statusReady;

    if (statusReady) {

        if ([self.type isEqualToString:BAInfoTypeSuperGift]) {

            switch (_gs.integerValue) {
                case 5: //火箭
                    _giftType = BAGiftTypeRocket;
                    _superRocket = NO;
                    break;

                case 6: //超级火箭
                    _giftType = BAGiftTypeRocket;
                    _superRocket = YES;
                    break;

                default:
                    break;
            }
        } else if ([self.type isEqualToString:BAInfoTypeSmallGift]) {

            _superRocket = NO;
            switch (_gs.integerValue) {
                case 1: //鱼丸礼物
                    _giftType = BAGiftTypeFishBall;
                    break;

                case 2: //怂 稳 呵呵 点赞 粉丝荧光棒 辣眼睛
                case 3: //免费礼物(暂时不做筛选)
                    _giftType = BAGiftTypeCostGift;
                    break;

                case 4: //办卡及主播特殊礼物
                    _giftType = BAGiftTypeCard;
                    break;
                    
                case 5: //飞机
                    _giftType = BAGiftTypePlane;
                    break;

            }
        }
    }
}


- (void)setSn:(NSString *)sn{
    _sn = sn;
    
    if (sn.length) {
        self.nn = sn;
    }
}


- (void)setLev:(NSString *)lev{
    _lev = lev;
    
    switch (lev.integerValue) {
        case 1: //低级酬勤
            _giftType = BAGiftTypeDeserveLevel1;
            break;
            
        case 2: //中级酬勤
            _giftType = BAGiftTypeDeserveLevel2;
            break;
            
        case 3: //高级酬勤
            _giftType = BAGiftTypeDeserveLevel3;
            break;
            
        default:
            break;
    }
}


- (void)setNn:(NSString *)nn{
    if (nn.length) {
        _nn = nn;
        
        CGRect nameRect = [[nn stringByAppendingString:@":"] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : BACommonFont(16)} context:nil];
        
        _nameWidth = nameRect.size.width;
    }
}

@end
