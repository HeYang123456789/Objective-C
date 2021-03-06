//
//  RegExCategories.m
//
//  https://github.com/bendytree/Objective-C-RegEx-Categories
//
//
//  The MIT License (MIT)
// 
//  Copyright (c) 2013 Josh Wright <@BendyTree>
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "RegExCategories.h"

@implementation NSRegularExpression (ObjectiveCRegexCategories)

//=======================＝==创建Regular对象=============================//
- (id) initWithPattern:(NSString*)pattern
{
    return [self initWithPattern:pattern options:0 error:nil];
}

+ (NSRegularExpression*) rx:(NSString*)pattern
{
    return [[self alloc] initWithPattern:pattern];
}

+ (NSRegularExpression*) rx:(NSString*)pattern ignoreCase:(BOOL)ignoreCase
{
    return [[self alloc] initWithPattern:pattern options:ignoreCase?NSRegularExpressionCaseInsensitive:0 error:nil];
}

+ (NSRegularExpression*) rx:(NSString*)pattern options:(NSRegularExpressionOptions)options
{
    return [[self alloc] initWithPattern:pattern options:options error:nil];
}
//====================================================================//

- (BOOL) isMatch:(NSString*)matchee
{
    return [self numberOfMatchesInString:matchee options:0 range:NSMakeRange(0, matchee.length)] > 0;
}

- (int) indexOf:(NSString*)matchee
{
    NSRange range = [self rangeOfFirstMatchInString:matchee options:0 range:NSMakeRange(0, matchee.length)];
    return range.location == NSNotFound ? -1 : (int)range.location;
    //为什么这么写的原因：因为当没有匹配的对象的时候，返回的range.location == NSNotFound
}

- (NSArray*) split:(NSString *)str
{
    NSRange range = NSMakeRange(0, str.length);
    
    //get locations of matches
    NSMutableArray* matchingRanges = [NSMutableArray array];//创建空的可变数组
    NSArray* matches = [self matchesInString:str options:0 range:range];
    for(NSTextCheckingResult* match in matches) {
        [matchingRanges addObject:[NSValue valueWithRange:match.range]];
    }//这里得到的可变数组存储的元素 都是  匹配的range
    
    //invert ranges - get ranges of non-matched pieces
    NSMutableArray* pieceRanges = [NSMutableArray array];
    
    //add first range
    [pieceRanges addObject:[NSValue valueWithRange:NSMakeRange(0,
      (matchingRanges.count == 0 ? str.length : [matchingRanges[0] rangeValue].location))]];
    
    //add between splits ranges and last range
    for(int i=0; i<matchingRanges.count; i++){
        BOOL isLast = i+1 == matchingRanges.count;
        unsigned long startLoc = [matchingRanges[i] rangeValue].location + [matchingRanges[i] rangeValue].length;
        unsigned long endLoc = isLast ? str.length : [matchingRanges[i+1] rangeValue].location;
        [pieceRanges addObject:[NSValue valueWithRange:NSMakeRange(startLoc, endLoc-startLoc)]];
    }
    
    //use split ranges to select pieces
    NSMutableArray* pieces = [NSMutableArray array];
    for(NSValue* val in pieceRanges) {
        NSRange range = [val rangeValue];
        NSString* piece = [str substringWithRange:range];
        [pieces addObject:piece];
    }
    
    return pieces;
}

- (NSString*) replace:(NSString*)string with:(NSString*)replacement
{
    return [self stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:replacement];
}

- (NSString*) replace:(NSString*)string withBlock:(NSString*(^)(NSString* match))replacer
{
    //no replacer? just return^没有外加代码块处理，就直接返回原字符串
    if (!replacer) return string;
    
    //copy the string so we can replace subsections
    NSMutableString* result = [string mutableCopy];
    
    //get matches
    NSArray* matches = [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    //总结：先获得
    //replace each match (right to left so indexing doesn't get messed up)
    for (int i=(int)matches.count-1; i>=0; i--) {
        NSTextCheckingResult* match = matches[i];
        NSString* matchStr = [string substringWithRange:match.range];
        NSString* replacement = replacer(matchStr);
        [result replaceCharactersInRange:match.range withString:replacement];
    }
    
    return result;
}

- (NSString*) replace:(NSString *)string withDetailsBlock:(NSString*(^)(RxMatch* match))replacer
{
    //no replacer? just return
    if (!replacer) return string;
    
    //copy the string so we can replace subsections
    NSMutableString* replaced = [string mutableCopy];
    
    //get matches
    NSArray* matches = [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //replace each match (right to left so indexing doesn't get messed up)
    for (int i=(int)matches.count-1; i>=0; i--) {
        NSTextCheckingResult* result = matches[i];
        RxMatch* match = [self resultToMatch:result original:string];
        NSString* replacement = replacer(match);
        [replaced replaceCharactersInRange:result.range withString:replacement];
    }
    
    return replaced;
}

- (NSArray*) matches:(NSString*)str
{
    NSMutableArray* matches = [NSMutableArray array];
    
    NSArray* results = [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult* result in results) {
        NSString* match = [str substringWithRange:result.range];
        [matches addObject:match];
    }
    
    return matches;
}

- (NSString*) firstMatch:(NSString*)str
{
    NSTextCheckingResult* match = [self firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
    
    if (!match) return nil;
    
    return [str substringWithRange:match.range];
}

- (RxMatch*) resultToMatch:(NSTextCheckingResult*)result original:(NSString*)original
{
    RxMatch* match = [[RxMatch alloc] init];
    match.original = original;
    match.range = result.range;
    match.value = result.range.length ? [original substringWithRange:result.range] : nil;
    
    //groups
    NSMutableArray* groups = [NSMutableArray array];
    for(int i=0; i<result.numberOfRanges; i++){
        RxMatchGroup* group = [[RxMatchGroup alloc] init];
        group.range = [result rangeAtIndex:i];
        group.value = group.range.length ? [original substringWithRange:group.range] : nil;
        [groups addObject:group];
    }
    match.groups = groups;
    
    return match;
}

- (NSArray*) matchesWithDetails:(NSString*)str
{
    NSMutableArray* matches = [NSMutableArray array];
    
    NSArray* results = [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult* result in results) {
        [matches addObject:[self resultToMatch:result original:str]];
    }
    
    return matches;
}

- (RxMatch*) firstMatchWithDetails:(NSString*)str
{
    NSArray* results = [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    if (results.count == 0)
        return nil;
    
    return [self resultToMatch:results[0] original:str];
}

@end



@implementation NSString (ObjectiveCRegexCategories)

//=========================通过NSString对象自己创建=========================//
- (NSRegularExpression*) toRx
{
    return [[NSRegularExpression alloc] initWithPattern:self];
}

- (NSRegularExpression*) toRxIgnoreCase:(BOOL)ignoreCase
{
    return [NSRegularExpression rx:self ignoreCase:ignoreCase];
}

- (NSRegularExpression*) toRxWithOptions:(NSRegularExpressionOptions)options
{
    return [NSRegularExpression rx:self options:options];
}
//====================================================================//

//=========================通过NSString对象自己匹配======================//
- (BOOL) isMatch:(NSRegularExpression*)rx
{
    return [rx isMatch:self];
}
//=================我补充的=================================
//1
- (BOOL) isMatchWithPattern:(NSString*)pattern
{
    return [self isMatch:[pattern toRx]];
}
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- (int) indexOf:(NSRegularExpression*)rx
{
    return [rx indexOf:self];
}
//=================我补充的=================================
- (int) indexOfWithPattern:(NSString*)pattern
{
    return [[pattern toRx] indexOf:self];
}
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- (NSArray*) split:(NSRegularExpression*)rx
{
    return [rx split:self];
}

- (NSString*) replace:(NSRegularExpression*)rx with:(NSString*)replacement
{
    return [rx replace:self with:replacement];
}

- (NSString*) replace:(NSRegularExpression *)rx withBlock:(NSString*(^)(NSString* match))replacer
{
    return [rx replace:self withBlock:replacer];
}
//=================我补充的=================================
//1
- (NSString*) replaceWithPattern:(NSString*)pattern withBlock:(NSString*(^)(NSString* match))replacer
{
    return [self replace:[pattern toRx] withBlock:replacer];
}
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- (NSString*) replace:(NSRegularExpression *)rx withDetailsBlock:(NSString*(^)(RxMatch* match))replacer
{
    return [rx replace:self withDetailsBlock:replacer];
}

- (NSArray*) matches:(NSRegularExpression*)rx
{
    return [rx matches:self];
}
//=================我补充的=================================
//1
- (NSArray*) matchesToArrayWithPattern:(NSString*)pattern
{
    return [self matches:[pattern toRx]];
}
- (NSArray*) matchesToArrayWithPattern:(NSString*)pattern ignoreCase:(BOOL)ignoreCase
{
    return [self matches:[pattern toRxIgnoreCase:ignoreCase]];
}
- (NSArray*) matchesToArrayWithPattern:(NSString*)pattern options:(NSRegularExpressionOptions)options
{
    return [self matches:[pattern toRxWithOptions:options]];
}
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- (NSString*) firstMatch:(NSRegularExpression*)rx
{
    return [rx firstMatch:self];
}
//=============我要补充的业务逻辑：判断字符串首个字符是不是匹配对象
//=================我补充的=================================
//2
- (NSString*) firstMatchToStringWithPattern:(NSString*)pattern
{
    return [self firstMatch:[NSRegularExpression rx:pattern]];
}
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- (NSArray*) matchesWithDetails:(NSRegularExpression*)rx
{
    return [rx matchesWithDetails:self];
}

- (RxMatch*) firstMatchWithDetails:(NSRegularExpression*)rx
{
    return [rx firstMatchWithDetails:self];
}

@end



@implementation RxMatch
@synthesize value, range, groups, original;
@end

@implementation RxMatchGroup
@synthesize value, range;
@end

