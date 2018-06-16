//
//  BARoomGiftModel.h
//  BulletAnalyzer
//
//  Created by Zj on 2018/6/16.
//  Copyright © 2018年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BARoomGiftModel : NSObject

/**
 礼物名称
 */
@property (nonatomic, copy) NSString *name;

/**
 礼物id
 */
@property (nonatomic, copy) NSString *ID;

/**
 价值
 */
@property (nonatomic, copy) NSString *pc;

/**
 类型, 1鱼丸 2鱼翅
 */
@property (nonatomic, copy) NSString *type;

@end
