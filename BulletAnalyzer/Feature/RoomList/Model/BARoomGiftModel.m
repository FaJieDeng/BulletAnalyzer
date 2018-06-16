//
//  BARoomGiftModel.m
//  BulletAnalyzer
//
//  Created by Zj on 2018/6/16.
//  Copyright © 2018年 Zj. All rights reserved.
//

#import "BARoomGiftModel.h"
#import "MJExtension.h"

@implementation BARoomGiftModel

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
