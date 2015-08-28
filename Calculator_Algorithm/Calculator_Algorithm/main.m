//
//  main.m
//  Calculator_Algorithm
//
//  Created by HEYANG on 15/8/28.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calculator_Algorithm.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* str = @"1×1.125+9×9×9×9×9×9×9×9×9×9×9×9×9×9×9×9×9×9×9";
        //使用单例类
        Calculator_Algorithm *ca = [Calculator_Algorithm calculatorAlgorithm];
        [ca setStr:str];
        NSLog(@"%@",[ca getResult]);;
    }
    return 0;
}
