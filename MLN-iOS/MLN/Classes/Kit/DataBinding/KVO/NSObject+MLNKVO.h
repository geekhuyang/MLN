//
//  NSObject+MLNKVO.h
//  MLN
//
//  Created by tamer on 2020/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MLNKVO)

- (BOOL)mln_containsKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
