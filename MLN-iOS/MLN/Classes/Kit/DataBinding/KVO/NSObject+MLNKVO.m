//
//  NSObject+MLNKVO.m
//  MLN
//
//  Created by tamer on 2020/1/20.
//

#import "NSObject+MLNKVO.h"

@implementation NSObject (MLNKVO)

- (BOOL)mln_containsKeyPath:(NSString *)keyPath
{
    // setter
    // @note ⚠️ 这里的key要考虑是不是isXXX，或者对应的getter方法是不是isXXX类型
    NSString *setterKey = [NSString stringWithFormat:@"set%@:",[keyPath capitalizedString]];
    NSString *noIsSetterKey = nil;
    if ([keyPath hasPrefix:@"is"]) {
        NSString *tmp = [keyPath substringWithRange:NSMakeRange(0, @"is".length)];
        noIsSetterKey = [NSString stringWithFormat:@"set%@:",[tmp capitalizedString]];
    }
    // getter
    NSString *getterKey = [NSString stringWithFormat:@"is%@",[keyPath capitalizedString]];
    if (!([self respondsToSelector:NSSelectorFromString(keyPath)] ||
          [self respondsToSelector:NSSelectorFromString(getterKey)]) ||
        !([self respondsToSelector:NSSelectorFromString(setterKey)] ||
          [self respondsToSelector:NSSelectorFromString(noIsSetterKey)])) {
        return NO;
    }
    return YES;
}

@end
