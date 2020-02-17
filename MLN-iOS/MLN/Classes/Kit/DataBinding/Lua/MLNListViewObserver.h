//
//  MLNListViewObserver.h
//  MLN
//
//  Created by tamer on 2020/2/14.
//

#import "MLNBaseLiveKVObserver.h"
#import "MLNListViewObserverProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLNListViewObserver : MLNBaseLiveKVObserver <MLNListViewObserverProtocol>

- (instancetype)initWithListView:(UIView *)listView;

@end

NS_ASSUME_NONNULL_END
