
#import <Foundation/Foundation.h>
#import "MovieTicket.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        MovieTicket *ticket = [[MovieTicket alloc] initWithPrice:60];

        [ticket getDiscountAfterType:@"VIP"];
        
    }
    return 0;
}
