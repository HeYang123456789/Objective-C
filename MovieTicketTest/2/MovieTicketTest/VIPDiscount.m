#import "VIPDiscount.h"

@implementation VIPDiscount

- (void)getDiscount:(double)price
{
    NSLog(@"原价是：%lu",(unsigned long)price);
    price = price/2;
    NSLog(@"==增加积分==");
    NSLog(@"享受VIP之后：%lu",(unsigned long)price);
}


@end
