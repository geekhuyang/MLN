//
//  MLNKVOHelperFactory.h
//  MLN
//
//  Created by tamer on 2020/2/17.
//

#import <Foundation/Foundation.h>
#import "MLNKVOBaseObserverHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLNKVOHelperFactory : NSObject

+ (MLNKVOBaseObserverHelper *)createHelperWithTargetObject:(NSObject *)targetObject keyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
