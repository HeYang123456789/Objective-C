#import "MovieTicket.h"

@implementation MovieTicket


- (instancetype)initWithPrice:(double)price
{
    self = [super init];
    if (self) {
        _price = price;
    }
    return self;
}
- (double)getDiscountAfterType:(NSString*)type
{
    double discount = self.price;
    NSLog(@"原价是：%lu",(unsigned long)discount);
    if ([type isEqualToString:@"Student"]) {
        discount = discount * 0.8;
        NSLog(@"享受学生价之后：%lu",(unsigned long)discount);
        return discount;
    }
    if ([type isEqualToString:@"Children"]&&discount>=20) {
        discount = discount - 10;
        NSLog(@"享受儿童价之后：%lu",(unsigned long)discount);
        return discount;
    }
    if ([type isEqualToString:@"VIP"]) {
        discount = discount/2;
        NSLog(@"==获得积分==");
        NSLog(@"享受VIP之后：%lu",(unsigned long)discount);
        return discount;
    }
    return discount;
}
@end
