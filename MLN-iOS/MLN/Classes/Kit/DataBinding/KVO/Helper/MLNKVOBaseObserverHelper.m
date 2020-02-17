//
//  MLNKVOBaseObserverHelper.m
//  MLN
//
//  Created by tamer on 2020/2/17.
//

#import "MLNKVOBaseObserverHelper.h"

@interface MLNKVOBaseObserverHelper ()

@end
@implementation MLNKVOBaseObserverHelper

- (instancetype)initWithTargetObject:(NSObject *)targetObject keyPath:(NSString *)keyPath
{
    if (self = [super init]) {
        NSParameterAssert(targetObject);
        NSParameterAssert(keyPath);
        if (targetObject && keyPath) {
            _obsMSet = [NSMutableSet set];
            _targetObject = targetObject;
            _keyPath = keyPath;
        }
    }
    return self;
}

- (NSSet<NSObject<MLNKVObserverProtocol> *> *)observerSet
{
    return _obsMSet.copy;
}

- (void)addObserver:(NSObject<MLNKVObserverProtocol> *)observer
{
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        if (![_obsMSet containsObject:observer]) {
            [_obsMSet addObject:observer];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self->_obsMSet containsObject:observer]) {
                [self->_obsMSet addObject:observer];
            }
        });
    }
}

@end
