//
//  MLNListViewObserverProtocol.h
//  MLN
//
//  Created by tamer on 2020/2/17.
//

#ifndef MLNListViewObserverProtocol_h
#define MLNListViewObserverProtocol_h

#import <UIKit/UIKit.h>
#import "MLNLiveKVObserverProtocol.h"

typedef enum : NSUInteger {
    MLNListViewChangeTypeAdd,
    MLNListViewChangeTypeInsert,
    MLNListViewChangeTypeDelete,
    MLNListViewChangeTypeReplace,
} MLNListViewChangeType;

@protocol MLNListViewObserverProtocol <MLNLiveKVObserverProtocol>

@property (nonatomic, weak, readonly) UIView *listView;

- (void)notifyListChangeWithKeyPath:(NSString *)keyPath type:(MLNListViewChangeType)type indexPath:(NSIndexPath *)indexPath newValue:(id)newValue oldValue:(id)oldValue;

@end

#endif /* MLNListViewObserverProtocol_h */
