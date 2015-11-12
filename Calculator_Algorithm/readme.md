## 本小项目的目的是，处理任意数字任意符号组成合理的算式字符串(带括号)
例如NSString* str = @"((8×12÷3-99-3)+(8×(1-30-29)+3))+(8×3÷3-9+3)" -> NSString* result = @"-529"字符串式子
并由它数学上基本的正确计算结果，最后返回NSString类型的结果。

下面是这个小项目的主业务逻辑的 主流程图：
![baidu](http://images2015.cnblogs.com/blog/784420/201508/784420-20150830143019328-1320473262.png)

### 本项目采用可以灵活匹配需要的子字符串的正则表达式匹配

* 1.先用类别对NSRegularExpression进行自我简易封装

```
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
```

* 2.然后用类别扩展将NSRegularExpression简易封装进NSString类中


```
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
...后面有很多...自己看源代码
```

* 3.最后使用示例

```
    if ([newStr isMatchWithPattern:@"^\\+"]) {
        newStr = [newStr replaceWithPattern:@"^\\+" withBlock:^NSString *(NSString *match) {
            return @"";
        }];
    }
```


**这是整个小项目中计算的核心算法:**   对于任意长度的任意多个符号合理的式子进行计算

(不包括括号的算法，例如直接处理：8×12÷3-99-3，先将这个字符串提取为存储数值的数组和存储符号的数组，然后用下面的核心算法计算)

```

//================="+""-""×""÷"四则运算的核心算法===================
-(NSNumber*)getFourOperationsResult
{
    NSArray* digitArray = [self getNumberArrayFromStringArray];
    NSArray* operation = [self getOperationArray];
    
    if (digitArray.count == 1) {
        return digitArray[0];
    }
    NSNumber* left = [[NSNumber alloc]initWithDouble:0];
    NSNumber* right = digitArray[0];
    NSNumber* sign = [[NSNumber alloc]initWithDouble:1];
    NSLog(@"%@",self);
    for (int i=0; i<operation.count; i++) {
        NSString* ope = operation[i];
        if ([ope isEqualToString:@"+"]) {
            left = [left add:[sign mul:right]];
            sign = [[NSNumber alloc]initWithDouble:1];
                right = digitArray[i+1];
        }
        if ([ope isEqualToString:@"-"]) {
            left = [left add:[sign mul:right]];
            sign = [[NSNumber alloc]initWithDouble:-1];
            NSLog(@"%@",digitArray[i]);
            right = digitArray[i+1];
        }
        if ([ope isEqualToString:@"×"]) {
            right = [right mul:digitArray[i+1]];
        }
        if ([ope isEqualToString:@"÷"]) {
            right = [right divide:digitArray[i+1]];
        }
    }
    return [left add:[sign mul:right]];
}
//================="+""-""×""÷"四则运算的核心算法===================
```

这个算法还有一个java版本的代码：<http://www.cnblogs.com/goodboy-heyang/p/4728042.html>
图解这个算法是：
![Syntax highlighting example](http://images0.cnblogs.com/blog2015/784420/201508/131749287702597.png)
**提醒：**
java的代码算法用的数值数组和符号数组都是从下表1开始的，而本项目中就是上面的"+""-""×""÷"四则运算的核心算法用的着两个数组是从下标0开始的，希望这个细节不影响理解程序逻辑。

***本小项目使用了一个设计模式(设计原则):严格的单例类***
将之前的所有的算法都封装在这个单例类中，这个单例类只提供使用的接口，类似java里封装的set和get传入和返回得到结果。这样用户端就可以直接通过这个单例类创建对象，然后传入原字符串，就可以得到最后的结果。


```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* str = @"((8×12÷3-99-3)+(8×(1-30-29)+3))+(8×3÷3-9+3)";
        //使用单例类
        Calculator_Algorithm *ca = [Calculator_Algorithm calculatorAlgorithm];
        [ca setStr:str];
        NSLog(@"result:%@",[ca getResult]);
    }
    return 0;
}
```

**严格的单例类**
为什么说是严格的单例类呢？

*  1.单例模式人人用过,严格的单例模式很少有人用过

*  2.严格的单例模式指的是无法通过常规的 alloc init 方法来生成对象,派生出来的子类也不能产生出对象,而只能通过单例的方法获取到对象

  ***严格单例类的核心代码*** 和本小项目的源代码有所不同，但是主体部分是一样的，下面代码时转载来自大神的博客<http://www.cnblogs.com/YouXianMing/p/4709209.html#3256420>
  
  另外还可以直接到我的博文里有更详细的单例模式的讲解<http://www.cnblogs.com/goodboy-heyang/p/4920471.html>
  
```
#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+ (Singleton *)sharedInstance;

@end
```

```

#import "Singleton.h"

#define  STR_SINGLETON  @"STR_SINGLETON"

static Singleton *_sharedSingleton = nil;

@implementation Singleton

+ (Singleton *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedSingleton = (Singleton *)STR_SINGLETON;
        _sharedSingleton = [[Singleton alloc] init];
    });

    return _sharedSingleton;
}

- (instancetype)init {
    
    NSString *string = (NSString *)_sharedSingleton;
    if ([string isKindOfClass:[NSString class]] && [string isEqualToString:STR_SINGLETON]) {
        
        self = [super init];
        if (self) {
            
        }
        
        return self;
        
    } else {
    
        return nil;
    }
}

@end
```