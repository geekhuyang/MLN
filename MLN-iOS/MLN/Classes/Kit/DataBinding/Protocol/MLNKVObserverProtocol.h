//
//  MLNKVObserverProtocol.h
//  MLN
//
//  Created by tamer on 2020/1/15.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MLNKVObserverProtocol_h
#define MLNKVObserverProtocol_h

@protocol MLNKVObserverProtocol <NSObject>

@property (nonatomic, weak, readonly) NSObject *targetObject;
- (void)notify:(NSString *)keyPath newValue:(id)newValue oldValue:(id)oldValue;

@end

#endif /* MLNKVObserverProtocol_h */
