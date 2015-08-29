//
//  NSString+Special.m
//  Calculator_Algorithm
//
//  Created by HEYANG on 15/8/29.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import "NSString+Special.h"

@implementation NSString (Special)

-(NSString*)removePlusMinusSpecial
{
    NSString* newStr = self;
    if ([newStr isMatchWithPattern:@"^\\+"]) {
        newStr = [newStr replaceWithPattern:@"^\\+" withBlock:^NSString *(NSString *match) {
            return @"";
        }];
        NSLog(@"1:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"[\\×\\÷]\\+"]) {
        newStr = [newStr replaceWithPattern:@"[\\×\\÷]\\+" withBlock:^NSString *(NSString *match) {
            return [match substringToIndex:1];
        }];
        NSLog(@"2:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"[\\+\\-]\\+"]) {
        newStr = [newStr replaceWithPattern:@"[\\+\\-]\\+" withBlock:^NSString *(NSString *match) {
            return [match substringToIndex:1];
        }];
        NSLog(@"3:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"\\-\\-"]) {
        newStr = [newStr replaceWithPattern:@"\\-\\-" withBlock:^NSString *(NSString *match) {
            return @"+";
        }];
        NSLog(@"4:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"\\+\\-"]) {
        newStr = [newStr replaceWithPattern:@"\\+\\-" withBlock:^NSString *(NSString *match) {
            return @"-";
        }];
        NSLog(@"5:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"\\(\\+"]) {
        newStr = [newStr replaceWithPattern:@"\\(\\+" withBlock:^NSString *(NSString *match) {
            return @"(";
        }];
        NSLog(@"6:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"\\([\\d\\.]+\\)"]) {
        newStr = [newStr replaceWithPattern:@"\\([\\d\\.]+\\)" withBlock:^NSString *(NSString *match) {
            match = [match substringWithRange:NSMakeRange(1, [match length]-2)];
            return match;
        }];
        NSLog(@"7:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"\\(\\-[\\d\\.]+\\)"]) {
        newStr = [newStr replaceWithPattern:@"\\(\\-[\\d\\.]+\\)" withBlock:^NSString *(NSString *match) {
            match = [match substringWithRange:NSMakeRange(1, [match length]-2)];
            return match;
        }];
        NSLog(@"8:%@",newStr);
    }
    //因为 前面的“(-d)”变成-d 就有可能出现新的 "+-"和"--"，所以需要再一次进行判断处理
    if ([newStr isMatchWithPattern:@"\\-\\-"]) {
        newStr = [newStr replaceWithPattern:@"\\-\\-" withBlock:^NSString *(NSString *match) {
            return @"+";
        }];
        NSLog(@"9:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"\\+\\-"]) {
        newStr = [newStr replaceWithPattern:@"\\+\\-" withBlock:^NSString *(NSString *match) {
            return @"-";
        }];
        NSLog(@"10:%@",newStr);
    }
    //======================================难点===============================================
    //处理 "×-""÷-"
    if ([newStr isMatchWithPattern:@"[\\×\\÷]\\-"]) {
        newStr = [newStr replaceWithPattern:@"\\-[\\×\\÷\\d\\.]+[\\×\\÷]\\-" withBlock:^NSString *(NSString *match) {
            match = [match substringWithRange:NSMakeRange(1, [match length]-2)];
            match = [@"+" stringByAppendingString:match];
            return match;
        }];
        NSLog(@"11:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"[\\×\\÷]\\-"]) {
        newStr = [newStr replaceWithPattern:@"\\+[\\×\\÷\\d\\.]+[\\×\\÷]\\-" withBlock:^NSString *(NSString *match) {
            match = [match substringWithRange:NSMakeRange(1, [match length]-2)];
            match = [@"-" stringByAppendingString:match];
            return match;
        }];
        NSLog(@"12:%@",newStr);
    }
    if ([newStr isMatchWithPattern:@"[\\×\\÷]\\-"]) {
        newStr = [newStr replaceWithPattern:@"^[\\d\\.]+[\\×\\÷\\d\\.]*[\\×\\÷]\\-" withBlock:^NSString *(NSString *match) {
            match = [match substringToIndex:[match length]-1];
            match = [@"-" stringByAppendingString:match];
            return match;
        }];
        NSLog(@"13:%@",newStr);
    }//经过测试发现  还可能会出现 ：2×2×-1×2×-2   ->   2×2×+1×2×2   所以需要去"+"处理
    if ([newStr isMatchWithPattern:@"[\\×\\÷]\\+"]) {
        newStr = [newStr replaceWithPattern:@"[\\×\\÷]\\+" withBlock:^NSString *(NSString *match) {
            return [match substringToIndex:1];
        }];
        NSLog(@"14:%@",newStr);
    }
    //======================================难点===============================================
    //最后还是要处理开头可能会出现的“+”
    if ([newStr isMatchWithPattern:@"^\\+"]) {
        newStr = [newStr replaceWithPattern:@"^\\+" withBlock:^NSString *(NSString *match) {
            return @"";
        }];
    }
    return newStr;
}

@end
