#import "ChildrenDiscount.h"

@implementation ChildrenDiscount

- (void)getDiscount:(double)price
{
    NSLog(@"原价是：%lu",(unsigned long)price);
    if (price >= 20) {
        price = price - 10;
        NSLog(@"享受儿童价之后：%lu",(unsigned long)price);
    }
}

@end
