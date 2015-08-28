//
//  NSString+Calculator_Algorithm.m
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import "NSString+Calculator_Algorithm.h"

@implementation NSString (Calculator_Algorithm)
//不可变转为可变
-(NSMutableString*)stringToMutableString
{
    return [NSMutableString stringWithString:self];
}
//可变转为不可变
//删除可变字符串中目标子字符串

//去两边括号
-(NSMutableString*)removeBracket
{
    
    NSMutableString *haveBracket = [self stringToMutableString];
    if ([haveBracket hasPrefix:@"("]) {
        [haveBracket deleteCharactersInRange:[haveBracket rangeOfString:@"("]];
    }
    if ([haveBracket hasSuffix:@")"]) {
        [haveBracket deleteCharactersInRange:[haveBracket rangeOfString:@")"]];
    }
    return haveBracket;
}
//=======================拆分为数据字符数组，和符号字符数组
-(NSArray*)getDigitStringArray
{
    return [[self removeBracket] matchesToArrayWithPattern:@"[\\d\\.]+"];
}
-(NSArray*)getOperationArray
{
    return  [[self removeBracket] matchesToArrayWithPattern:@"[\\×\\÷\\+\\-]"];
}

//=======================数据字符 转为 NSNumber数据类型  支持整数和小数
-(NSNumber*)getNumberFromString
{
    return [NSNumber numberWithDouble:[self doubleValue]];
}
-(NSString*)getStringFromNumber:(NSNumber*)number
{
    return [NSString stringWithFormat:@"%@",number];
}
//=======================将数据字符的集合 转为 NSNumber集合
-(NSMutableArray*)getNumberArrayFromStringArray
{
    NSMutableArray* mutArray = [[NSMutableArray alloc]init];
    for (NSString* numberStr in [self getDigitStringArray]) {
        [mutArray addObject:[numberStr getNumberFromString]];
    }
    return mutArray;
}
//=======================四则运算
-(NSNumber*)getFourOperationsResult
{
    NSArray* digitArray = [self getNumberArrayFromStringArray];
    NSArray* operation = [self getOperationArray];
    
    if (digitArray.count == 1) {
        return digitArray[0];
    }
    NSNumber* left = [[NSNumber alloc]initWithDouble:0];
    NSNumber* right = digitArray[0];
    NSNumber* sign = [[NSNumber alloc]initWithDouble:1];
    for (int i=0; i<operation.count; i++) {
        NSString* ope = operation[i];
        if ([ope isEqualToString:@"+"]) {
            left = [left add:[sign mul:right]];
            sign = [[NSNumber alloc]initWithDouble:1];
            right = digitArray[i+1];
        }
        if ([ope isEqualToString:@"-"]) {
            left = [left add:[sign mul:right]];
            sign = [[NSNumber alloc]initWithDouble:-1];
            right = digitArray[i+1];
        }
        if ([ope isEqualToString:@"×"]) {
            right = [right mul:digitArray[i+1]];
        }
        if ([ope isEqualToString:@"÷"]) {
            right = [right divide:digitArray[i+1]];
        }
    }
    return [left add:[sign mul:right]];
}
//=======================最后获取结果要转为NSString
-(NSString*)getStringResult
{
    return [NSString stringWithFormat:@"%@",[self getFourOperationsResult]];
}

@end
