//
//  main.m
//  Calculator_Algorithm
//
//  Created by HEYANG on 15/8/28.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//   ((8×12÷3-99-3)+(8×(1-30-29)+3))+(8×3÷3-9+3)

#import <Foundation/Foundation.h>
#import "Calculator_Algorithm.h"

#import "NSString+Special.h"

#import "RegExCategories.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* str = @"((8×12÷3-99-3)+(8×(1-30-29)+3))+(8×3÷3-9+3)";
//        NSString* str = @"+(+1--1×+6";
        //        NSString* str = @"2×+2×(-1)×2+(-1)×2×+2";
        NSLog(@"原式子：%@",str);
        //使用单例类
        Calculator_Algorithm *ca = [Calculator_Algorithm calculatorAlgorithm];
        [ca setStr:str];
        NSLog(@"result:%@",[ca getResult]);

        //测试第一个
//        NSMutableString *strmut = [NSMutableString stringWithString:str];
//        
//        NSLog(@"%@",[strmut removePlusMinus:strmut]);;
//        //测试第二个
//        NSLog(@"%@",[str removePlusMinusString:str]);
    }
    return 0;
}
