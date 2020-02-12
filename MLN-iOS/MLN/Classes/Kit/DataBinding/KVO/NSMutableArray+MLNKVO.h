//
//  NSMutableArray+MLNKVO.h
//  MLN
//
//  Created by tamer on 2020/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MLNArrayChangeTypeAdd,
    MLNArrayChangeTypeInsert,
    MLNArrayChangeTypeDelete,
    MLNArrayChangeTypeReplace,
} MLNArrayChangeType;

typedef void(^MLNKVOObserverHandler)(MLNArrayChangeType type, NSMutableArray *newArray, NSArray *oldArray);

@interface NSMutableArray (MLNKVO)

- (void)mln_addObserverHandler:(MLNKVOObserverHandler)handler;
- (void)mln_removeObserverHandler:(MLNKVOObserverHandler)handler;
- (void)mln_clearObserverHandlers;

@end

NS_ASSUME_NONNULL_END
