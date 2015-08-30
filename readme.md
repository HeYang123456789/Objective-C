##本小项目的目的是，处理任意数字任意符号组成合理的算式字符串(带括号)
类似NSString* str = @"((8×12÷3-99-3)+(8×(1-30-29)+3))+(8×3÷3-9+3)" -> NSString* result = @"-529"字符串式子
并由它数学上基本的正确计算结果，最后返回NSString类型的结果。

下面是这个小项目的主业务逻辑的 主流程图 链接：
![baidu](http://images2015.cnblogs.com/blog/784420/201508/784420-20150830143019328-1320473262.png)



**这是整个小项目中计算的核心算法:**   对于任意长度的任意多个符号合理的式子进行计算

(不包括括号的算法，例如直接处理：8×12÷3-99-3)

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
