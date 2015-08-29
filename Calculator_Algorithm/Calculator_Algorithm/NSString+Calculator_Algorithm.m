//
//  NSString+Calculator_Algorithm.m
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import "NSString+Calculator_Algorithm.h"

int isMin;

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
    NSLog(@"haveBracket去括号之前%@",haveBracket);
    if ([haveBracket hasPrefix:@"("]) {
        [haveBracket deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if ([haveBracket hasSuffix:@")"]) {
        [haveBracket deleteCharactersInRange:NSMakeRange([haveBracket length]-1, 1)];
    }
    NSLog(@"haveBracket去括号之后1:%@",haveBracket);
    haveBracket = [[NSMutableString alloc] initWithString:[haveBracket removePlusMinusSpecial]];
    NSLog(@"haveBracket去括号之后2:%@",haveBracket);
    haveBracket = [self removeStartMinus:haveBracket];
    NSLog(@"haveBracket去括号之后3:%@",haveBracket);
    return haveBracket;
}
/**
 *  仅仅用于处理开头为"-"的情况
 *
 *  @param str
 *
 *  @return 
 */
-(NSMutableString*)removeStartMinus:(NSMutableString*)str
{
    isMin = 0;
    
    if ([[str substringToIndex:1] isEqualToString:@"-"]) {
        isMin = 1;
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return str;
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
    if (isMin == 1) {
        mutArray[0] = [[NSNumber numberWithDouble:0] sub:mutArray[0]];
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
    NSLog(@"%@",self);
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
            NSLog(@"%@",digitArray[i]);
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
