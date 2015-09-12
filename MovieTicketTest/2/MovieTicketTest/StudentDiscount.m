#import "StudentDiscount.h"

@implementation StudentDiscount

- (void)getDiscount:(double)price
{
    NSLog(@"原价是：%lu",(unsigned long)price);
    price = price * 0.8;
    NSLog(@"享受学生价之后：%lu",(unsigned long)price);
}

@end
