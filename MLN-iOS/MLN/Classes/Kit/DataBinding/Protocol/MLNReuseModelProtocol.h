//
//  MLNReuseModelProtocol.h
//  MLN
//
//  Created by tamer on 2020/2/7.
//

#ifndef MLNReuseModelProtocol_h
#define MLNReuseModelProtocol_h

#import <UIKit/UIKit.h>
#import "MLNLiveKVObserverProtocol.h"

@protocol MLNReuseModelProtocol <MLNLiveKVObserverProtocol>

- (NSString *)reuseIdentifier;
- (CGFloat)height;

@end


#endif /* MLNReuseModelProtocol_h */
