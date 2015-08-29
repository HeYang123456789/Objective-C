//
//  Calculator_Algorithm.m
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import "Calculator_Algorithm.h"

#define STR_SINGLETON @"STR_SINGLETON"

static Calculator_Algorithm *_calculatorAlgorithm = nil;

@implementation Calculator_Algorithm

/**
 *  计算的主业务逻辑
 *  单例类
 */
+ (Calculator_Algorithm *)calculatorAlgorithm {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _calculatorAlgorithm = (Calculator_Algorithm *)STR_SINGLETON;
        _calculatorAlgorithm = [[Calculator_Algorithm alloc] init];
    });
    
    return _calculatorAlgorithm;
}

- (instancetype)init {
    
    NSString *string = (NSString *)_calculatorAlgorithm;
    if ([string isKindOfClass:[NSString class]] && [string isEqualToString:STR_SINGLETON]) {
        
        self = [super init];
        if (self) {
            
        }
        
        return self;
        
    } else {
        
        return nil;
    }
}

//原字符串入口，获取"待计算的式子"字符串  默认已经有set和get方法了
//-(void)setCalculatorString:(NSString*)str
//{
//    _str = str;
//}
//-(NSString*)getResult
//{
//    return _str;
//}
-(void)run
{
    NSLog(@"开始的字符串：%@",_str);
    while ([_str isMatchWithPattern:@"\\([\\d\\.\\+\\-\\×\\÷]+\\)"]) {
        _str = [_str removePlusMinusSpecial];
        _str = [_str replaceWithPattern:@"\\([\\d\\.\\+\\-\\×\\÷]+\\)" withBlock:^NSString *(NSString *match) {
            //这里就需要import "NSString+Calculator_Algorithm.h"
            return [match getStringResult];
        }];
        NSLog(@"匹配子括号后替换之后%@",_str);
    }
}
-(NSString*)getResult
{
    [self run];
    NSLog(@"最后处理之前：%@",_str);
    _str = [_str removePlusMinusSpecial];
    NSLog(@"最后处理之后：%@",_str);
    _str = [_str getStringResult];
    
    return _str;
}
@end

