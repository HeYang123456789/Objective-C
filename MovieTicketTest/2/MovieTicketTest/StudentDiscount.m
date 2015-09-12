//
//  StudentDiscount.m
//  MovieTicketTest
//
//  Created by HEYANG on 15/9/12.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import "StudentDiscount.h"

@implementation StudentDiscount

- (void)getDiscount:(double)price
{
    NSLog(@"原价是：%lu",(unsigned long)price);
    price = price * 0.8;
    NSLog(@"享受学生价之后：%lu",(unsigned long)price);
}

@end
