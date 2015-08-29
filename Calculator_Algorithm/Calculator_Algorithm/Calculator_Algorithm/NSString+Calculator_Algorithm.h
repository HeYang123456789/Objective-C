//
//  NSString+Calculator_Algorithm.h
//  OC_Regex
//
//  Created by HEYANG on 15/8/27.
//  Copyright (c) 2015年 HEYANG. All rights reserved.
//



/**
 *  处理 类似(8×1÷3-9+3)这样形式的式子
 *
 *  需要收藏的字符 ： \\([\\.\\d\\×\\÷\\+\\-]+\\)
 *
 *  另外可能需要改进，因为需要扩展新的算法，比如开方，幂等科学计算器算法
 *
 *  @param Calculator_Algorithm Calculator_Algorithm description
 *
 *  @return 返回 字符串形式的结果
 */
#import <Foundation/Foundation.h>
#import "RegExCategories.h"
#import "NSNumber+Operation.h"
#import "NSString+Special.h"
@interface NSString (Calculator_Algorithm)

-(NSMutableString*)removeBracket;
-(NSArray*)getDigitStringArray;
-(NSArray*)getOperationArray;
-(NSString*)getStringFromNumber:(NSNumber*)number;
-(NSNumber*)getFourOperationsResult;
-(NSString*)getStringResult;
@end
