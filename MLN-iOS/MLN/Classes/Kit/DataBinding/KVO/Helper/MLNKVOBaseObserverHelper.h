//
//  MLNKVOBaseObserverHelper.h
//  MLN
//
//  Created by tamer on 2020/2/17.
//

#import <Foundation/Foundation.h>
#import "MLNKVObserverProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 抽象基类
@interface MLNKVOBaseObserverHelper : NSObject {
    @protected NSMutableSet<NSObject<MLNKVObserverProtocol> *> *_obsMSet;
}

@property (nonatomic, weak, readonly) NSObject *targetObject;
@property (nonatomic, strong, readonly) NSSet<NSObject<MLNKVObserverProtocol> *> *observerSet;
@property (nonatomic, copy, readonly) NSString *keyPath;

- (instancetype)initWithTargetObject:(NSObject *)targetObject keyPath:(NSString *)keyPath;

- (void)addObserver:(NSObject<MLNKVObserverProtocol> *)observer;

@end

NS_ASSUME_NONNULL_END
