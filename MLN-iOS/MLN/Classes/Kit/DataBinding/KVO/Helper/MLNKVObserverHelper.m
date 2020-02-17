//
//  MLNKVObserverHelper.m
//  LuaNative
//
//  Created by tamer on 2020/1/15.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNKVObserverHelper.h"

@interface MLNKVObserverHelper ()
@end
@implementation MLNKVObserverHelper

- (instancetype)initWithTargetObject:(NSObject *)targetObject keyPath:(NSString *)keyPath
{
    if (self = [super initWithTargetObject:targetObject keyPath:keyPath]) {
        [targetObject addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.targetObject removeObserver:self forKeyPath:self.keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.targetObject == object && [keyPath isEqualToString:self.keyPath]) {
        id newValue = [change objectForKey:@"new"];
        id oldValue = [change objectForKey:@"old"];
        if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
            for (NSObject<MLNKVObserverProtocol> *obs in _obsMSet) {
                [obs notify:keyPath newValue:newValue oldValue:oldValue];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSObject<MLNKVObserverProtocol> *obs in self->_obsMSet) {
                    [obs notify:keyPath newValue:newValue oldValue:oldValue];
                }
            });
        }
    }
}

@end
