#import <Foundation/Foundation.h>

@interface MovieTicket : NSObject

//需要的属性 票价：price 持票人的年龄：userAge 是否是VIP；isVIP
@property (nonatomic) double price;

/**
 *  方法： 1、初始化方法，直接初始化票价
 */
- (instancetype)initWithPrice:(double)price;

- (double)getDiscountAfterType:(NSString*)type;

@end
