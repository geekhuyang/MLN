//
//  MLNKVObserver.m
//  LuaNative
//
//  Created by tamer on 2020/1/15.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNBlockObserver.h"
#import <MLNBlock.h>
#import "UIViewController+MLNKVO.h"
#import "MLNKitHeader.h"
#import "MLNKitViewController.h"

@interface MLNBlockObserver ()

@property (nonatomic, copy) MLNViewControllerLifeCycleObserver observer;

@end
@implementation MLNBlockObserver

- (instancetype)initWithBloclk:(MLNBlock *)block
{
    if (self = [super init]) {
        _block = block;
        __weak typeof(self) wself = self;
        _observer = ^(MLNViewControllerLifeCycle state) {
            __strong typeof(wself) sself = wself;
            if (state == MLNViewControllerLifeCycleViewDidDisappear) {
                sself.active = NO;
            } else if (state == MLNViewControllerLifeCycleViewDidAppear) {
                sself.active = YES;
            }
        };
        MLNKitViewController *kitViewController = (MLNKitViewController *)MLN_KIT_INSTANCE([block luaCore]).viewController;
        [kitViewController mln_addLifeCycleObserver:_observer];
    }
    return self;
}

- (void)notifyLiveForKeyPath:(NSString *)keyPath newValue:(id)newValue oldValue:(id)oldValue
{
    [self.block addObjArgument:newValue];
    [self.block addObjArgument:oldValue];
    [self.block callIfCan];
}

@end
