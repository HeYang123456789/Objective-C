//
//  NSNumber+Operation.m
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import "NSNumber+Operation.h"

@implementation NSNumber (Operation)
-(NSNumber*)add:(NSNumber*)anotherNumber
{
    return [NSNumber numberWithDouble:[self doubleValue]+[anotherNumber doubleValue]];
}
-(NSNumber*)sub:(NSNumber*)anotherNumber
{
    return [NSNumber numberWithDouble:[self doubleValue]-[anotherNumber doubleValue]];
}
-(NSNumber*)mul:(NSNumber*)anotherNumber
{
    return [NSNumber numberWithDouble:[self doubleValue]*[anotherNumber doubleValue]];
}
-(NSNumber*)divide:(NSNumber*)anotherNumber
{
    return [NSNumber numberWithDouble:[self doubleValue]/[anotherNumber doubleValue]];
}

@end
