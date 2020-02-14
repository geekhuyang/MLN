//
//  NSMutableArray+MLNKVO.m
//  MLN
//
//  Created by tamer on 2020/2/7.
//

#import "NSMutableArray+MLNKVO.h"
#import <objc/runtime.h>

@implementation NSMutableArray (MLNKVO)

- (void)mln_notifyAllObserver:(MLNArrayChangeType)type new:(NSMutableArray *)new old:(NSMutableArray *)old
{
    NSMutableArray<MLNKVOObserverHandler> *obs = objc_getAssociatedObject(self, kMLNKVOObserverHandlers);
    if (obs && obs.count > 0) {
        for (MLNKVOObserverHandler handler in obs) {
            handler(type, new, old);
        }
    }
}

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

@implementation NSMutableArray (MLNListener)

+ (void)load
{
    Method origMethod1 = class_getInstanceMethod([self class], @selector(addObject:));
    Method swizzledMethod1 = class_getInstanceMethod([self class], @selector(mln_listener_addObject:));
    method_exchangeImplementations(origMethod1, swizzledMethod1);
    
    origMethod1 = class_getInstanceMethod([self class], @selector(insertObject:atIndex:));
    swizzledMethod1 = class_getInstanceMethod([self class], @selector(mln_listener_insertObject:atIndex:));
    method_exchangeImplementations(origMethod1, swizzledMethod1);
}

- (void)mln_listener_addObject:(id)anObject
{
    NSMutableArray *old = self.mutableCopy;
    [self mln_listener_addObject:anObject];
    [self mln_notifyAllObserver:MLNArrayChangeTypeAdd new:self old:old];
}

- (void)mln_listener_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    NSMutableArray *old = self.mutableCopy;
    [self mln_listener_insertObject:anObject atIndex:index];
    [self mln_notifyAllObserver:MLNArrayChangeTypeInsert new:self old:old];
}

/// -------------------------------- 待实现接口 -----------
//- (void)removeLastObject;
//- (void)removeObjectAtIndex:(NSUInteger)index;
//- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;
//- (void)addObjectsFromArray:(NSArray<ObjectType> *)otherArray;
//- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
//- (void)removeAllObjects;
//- (void)removeObject:(ObjectType)anObject inRange:(NSRange)range;
//- (void)removeObject:(ObjectType)anObject;
//- (void)removeObjectIdenticalTo:(ObjectType)anObject inRange:(NSRange)range;
//- (void)removeObjectIdenticalTo:(ObjectType)anObject;
//- (void)removeObjectsFromIndices:(NSUInteger *)indices numIndices:(NSUInteger)cnt API_DEPRECATED("Not supported", macos(10.0,10.6), ios(2.0,4.0), watchos(2.0,2.0), tvos(9.0,9.0));
//- (void)removeObjectsInArray:(NSArray<ObjectType> *)otherArray;
//- (void)removeObjectsInRange:(NSRange)range;
//- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<ObjectType> *)otherArray range:(NSRange)otherRange;
//- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<ObjectType> *)otherArray;
//- (void)setArray:(NSArray<ObjectType> *)otherArray;
//- (void)sortUsingFunction:(NSInteger (NS_NOESCAPE *)(ObjectType,  ObjectType, void * _Nullable))compare context:(nullable void *)context;
//- (void)sortUsingSelector:(SEL)comparator;
//
//- (void)insertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexes;
//- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<ObjectType> *)objects;


@end
