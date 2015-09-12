#import <Foundation/Foundation.h>
#import "Discount.h"
#import "StudentDiscount.h"
#import "ChildrenDiscount.h"
#import "VIPDiscount.h"

@interface MovieTicket : NSObject

//需要的属性 票价：price 持票人的年龄：userAge 是否是VIP；isVIP
@property (nonatomic) double price;
@property (nonatomic,strong) Discount* discount;
/**
 *  方法： 1、初始化方法，直接初始化票价
 */
- (instancetype)initWithPrice:(double)price;

- (void)getDiscountAfterType:(NSString*)type;

@end
