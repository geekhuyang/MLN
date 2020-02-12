//
//  MLNLiveKVObserverProtocol.h
//  MLN
//
//  Created by tamer on 2020/1/16.
//

#ifndef MLNLiveKVObserverProtocol_h
#define MLNLiveKVObserverProtocol_h

#import "MLNKVObserverProtocol.h"

@protocol MLNLiveKVObserverProtocol <MLNKVObserverProtocol>

@property (nonatomic, assign, getter=isActive) BOOL active;

- (void)notifyLiveForKeyPath:(NSString *)keyPath newValue:(id)newValue oldValue:(id)oldValue;

@end

#endif /* MLNLiveKVObserverProtocol_h */
