//
//  NSMutableArray+MLNKVO.m
//  MLN
//
//  Created by tamer on 2020/2/7.
//

#import "NSMutableArray+MLNKVO.h"
#import <objc/runtime.h>

@implementation NSMutableArray (MLNKVO)


- (void)mln_addObserverHandler:(MLNKVOObserverHandler)handler
{
    NSMutableArray<MLNKVOObserverHandler> *obs = [self observerHandlers];
    if (![obs containsObject:handler]) {
        [obs addObject:handler];
    }
}

- (void)mln_removeObserverHandler:(MLNKVOObserverHandler)handler
{
    if (handler) {
        NSMutableArray *obs = objc_getAssociatedObject(self, kMLNKVOObserverHandlers);
        [obs removeObject:handler];
    }
}

- (void)mln_clearObserverHandlers
{
    NSMutableArray *obs = objc_getAssociatedObject(self, kMLNKVOObserverHandlers);
    [obs removeAllObjects];
}

static const void *kMLNKVOObserverHandlers = &kMLNKVOObserverHandlers;
- (NSMutableArray<MLNKVOObserverHandler> *)observerHandlers
{
    NSMutableArray *obs = objc_getAssociatedObject(self, kMLNKVOObserverHandlers);
    if (!obs) {
        obs = [NSMutableArray array];
        objc_setAssociatedObject(self, kMLNKVOObserverHandlers, obs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obs;
}

@end
