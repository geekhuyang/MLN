//
//  MLNKVOHelperFactory.m
//  MLN
//
//  Created by tamer on 2020/2/17.
//

#import "MLNKVOHelperFactory.h"
#import "MLNKVObserverHelper.h"
#import "MLNKVOArrayObserverHelper.h"


@implementation MLNKVOHelperFactory

+ (MLNKVOBaseObserverHelper *)createHelperWithTargetObject:(NSObject *)targetObject keyPath:(NSString *)keyPath
{
    if ([targetObject isKindOfClass:[NSMutableArray class]]) {
        return [[MLNKVOArrayObserverHelper alloc] initWithTargetObject:targetObject keyPath:keyPath];
    }
    return [[MLNKVObserverHelper alloc] initWithTargetObject:targetObject keyPath:keyPath];
}

@end
