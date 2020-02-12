//
//  MLNBaseReuseModel.h
//  MLN
//
//  Created by tamer on 2020/2/7.
//

#import <Foundation/Foundation.h>
#import "MLNBaseLiveKVObserver.h"
#import "MLNReuseModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface MLNBaseReuseModel : MLNBaseLiveKVObserver <MLNReuseModelProtocol>

@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
