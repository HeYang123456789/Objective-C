//
//  NSNumber+Operation.h
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  对NSNumber进行了类别扩展，实现了NSNumber的加减乘除运算
 */
@interface NSNumber (Operation)
-(NSNumber*)add:(NSNumber*)anotherNumber;
-(NSNumber*)sub:(NSNumber*)anotherNumber;
-(NSNumber*)mul:(NSNumber*)anotherNumber;
-(NSNumber*)divide:(NSNumber*)anotherNumber;
@end
