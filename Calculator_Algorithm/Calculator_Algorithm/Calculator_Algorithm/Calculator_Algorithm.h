//
//  Calculator_Algorithm.h
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

/**
 *  单例类，
 *
 *  @param strong  传入1×1.125+9×9×9×9×9×(9-12×9)+8-9+4×9×9×9×((9-3)×9)×9×9×9 类似这样的原字符串
 *  @param nonatomic nonatomic description
 *
 *  @return 返回  字符串类型的  结果
 */
#import <Foundation/Foundation.h>
#import "RegExCategories.h"
#import "NSString+Calculator_Algorithm.h"
#import "NSString+Special.h"
@interface Calculator_Algorithm : NSObject

@property (strong,nonatomic) NSString* str;

+ (Calculator_Algorithm *)calculatorAlgorithm;

-(NSString*)getResult;
@end
