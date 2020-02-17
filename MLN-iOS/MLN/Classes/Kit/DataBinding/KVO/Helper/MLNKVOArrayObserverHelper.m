//
//  MLNKVOArrayObserverHelper.m
//  MLN
//
//  Created by tamer on 2020/2/17.
//

#import "MLNKVOArrayObserverHelper.h"
#import "NSMutableArray+MLNKVO.h"

@interface MLNKVOArrayObserverHelper ()

@property (nonatomic, copy) MLNKVOObserverHandler handler;

@end
@implementation MLNKVOArrayObserverHelper

- (instancetype)initWithTargetObject:(NSObject *)targetObject keyPath:(NSString *)keyPath
{
    if (self = [super  initWithTargetObject:targetObject keyPath:keyPath]) {
        __weak typeof(self) wself = self;
        self.handler = ^(MLNArrayChangeType type, NSMutableArray * _Nonnull newArray, NSArray * _Nonnull oldArray) {
            __weak typeof(wself) sself = wself;
        };
        [(NSMutableArray *)targetObject mln_addObserverHandler:self.handler];
    }
    return self;
}

- (void)dealloc
{
    [(NSMutableArray *)(self.targetObject) mln_removeObserverHandler:self.handler];
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
