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
- (void)getDiscountAfterType:(NSString*)type
{
    if ([type isEqualToString:@"Student"]) {
        self.discount = [[StudentDiscount alloc] init];
        [self.discount getDiscount:self.price];
    }
    if ([type isEqualToString:@"Children"]) {
        self.discount = [[ChildrenDiscount alloc] init];
        [self.discount getDiscount:self.price];
    }
    if ([type isEqualToString:@"VIP"]) {
        self.discount = [[VIPDiscount alloc] init];
        [self.discount getDiscount:self.price];
    }
}
@end
