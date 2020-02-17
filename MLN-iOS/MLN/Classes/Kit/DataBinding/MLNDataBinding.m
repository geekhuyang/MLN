//
//  MLNDataBinding.m
//  LuaNative
//
//  Created by tamer on 2020/1/15.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNDataBinding.h"
#import "MLNKVOHelperFactory.h"
#import "MLNDataHandler.h"
#import "NSObject+MLNKVO.h"
#import <pthread.h>

@interface MLNDataBinding () {
    pthread_mutex_t _lock;
}

@property (nonatomic, strong) NSMutableDictionary *dataMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, MLNKVOBaseObserverHelper *> *observerHelperMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, MLNDataHandler *> *dataHandlerMap;

@end
@implementation MLNDataBinding

- (instancetype)init
{
    if (self = [super init]) {
        _dataMap = [NSMutableDictionary dictionary];
        _observerHelperMap = [NSMutableDictionary dictionary];
        _dataHandlerMap = [NSMutableDictionary dictionary];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc
{
    pthread_mutex_destroy(&_lock);
}

/// 指定数据-key的映射关系
- (void)bindData:(NSObject *)data key:(NSString *)key
{
    pthread_mutex_lock(&_lock);
    [self.dataMap setObject:data forKey:key];
    pthread_mutex_unlock(&_lock);
}

/// 更新指定数据，（添加数据缓存功能，避免重复解析数据）
- (void)updateDataForKeyPath:(NSString *)keyPath value:(id)value
{
    NSString *dataHandlerKey = [self dataHandlerKeyWithKeyPath:keyPath];
    NSAssert(dataHandlerKey, @"KeyPath不符合规则");
    MLNDataHandler *dataHandler = [self.dataHandlerMap objectForKey:dataHandlerKey];
    NSString *key = nil;
    if (!dataHandler) {
        id data = nil;
        BOOL success = [self parseByKeyPath:keyPath retData:&data retKey:&key];
        if (success) {
            dataHandler = [[MLNDataHandler alloc] initWithData:data dataHandlerKey:dataHandlerKey];
            [self.dataHandlerMap setObject:dataHandler forKey:dataHandlerKey];
        }
    }
    [dataHandler updateDataForKeyPath:keyPath value:value];
}

/// 获取指定数据，（添加数据缓存功能，避免重复解析数据）
- (id __nullable)dataForKeyPath:(NSString *)keyPath
{
    NSString *dataHandlerKey = [self dataHandlerKeyWithKeyPath:keyPath];
    NSAssert(dataHandlerKey, @"KeyPath不符合规则");
    // 获取缓存
    MLNDataHandler *dataHandler = [self.dataHandlerMap objectForKey:dataHandlerKey];
    NSString *key = nil;
    if (!dataHandler) {
        id data = nil;
        BOOL success = [self parseByKeyPath:keyPath retData:&data retKey:&key];
        if (success) {
            dataHandler = [[MLNDataHandler alloc] initWithData:data dataHandlerKey:dataHandlerKey];
            [self.dataHandlerMap setObject:dataHandler forKey:dataHandlerKey];
        }
    }
    return [dataHandler dataForKeyPath:keyPath];
}

/// 添加对应数据的监听者
- (void)addDataObserver:(NSObject<MLNKVObserverProtocol> *)observer forKeyPath:(NSString *)keyPath
{
    NSParameterAssert(keyPath);
    NSParameterAssert(observer);
    if (!keyPath || !observer) {
        return;
    }
    // cache
    pthread_mutex_lock(&_lock);
    MLNKVOBaseObserverHelper *helper = [self.observerHelperMap objectForKey:keyPath];
    pthread_mutex_unlock(&_lock);
    if (helper) {
        [helper addObserver:observer];
        return;
    }
    // new
    id data = nil;
    NSString *key = nil;
    BOOL success = [self parseByKeyPath:keyPath retData:&data retKey:&key];
    if (success) {
        helper = [MLNKVOHelperFactory createHelperWithTargetObject:data keyPath:key];
        [helper addObserver:observer];
        pthread_mutex_lock(&_lock);
        [self.dataMap setValue:helper forKey:keyPath];
        pthread_mutex_unlock(&_lock);
    }
}

/// 从“user.config. ... device.name” 中获取“user.config. ... device”的device 对象和 “name” key
/// @param keyPath 原有key，“user.config. ... device.name”
/// @param retData 对应的数据， “user.config. ... device”的device
/// @param retKey 对应的key，“name” key
/// @return 是否能正常解析
- (BOOL)parseByKeyPath:(NSString *)keyPath retData:(id *)retData retKey:(NSString **)retKey
{
    if (retData == NULL || retKey == NULL) {
        return NO;
    }
    NSArray<NSString *> *keyPathArray = [keyPath componentsSeparatedByString:@"."];
    if (keyPathArray.count > 1) {
        NSString *firstKey = keyPathArray.firstObject;
        pthread_mutex_lock(&_lock);
        id data = [self.dataMap objectForKey:firstKey];
        pthread_mutex_unlock(&_lock);
        NSString *akey = nil;
        if (data) {
            for (int i = 1; i < keyPathArray.count; i++) {
                akey = [keyPathArray objectAtIndex:1];
                if (!akey) {
                    return NO;
                }
                if (![data mln_containsKeyPath:akey]) {
                    return NO;
                }
                if ([data isKindOfClass:[NSArray class]]) {
                    data = [(NSArray *)data objectAtIndex:[akey integerValue]];
                } else if (i == keyPathArray.count - 2) {
                    data = [data valueForKey:akey];
                }
            }
        }
        *retData = data;
        *retKey = akey;
        return YES;
    }
    return NO;
}

/// 从“user.config. ... device.name” 中获取“user.config. ... device.”
/// @param keyPath  类似“user.config. ... device.name”字符串
/// @return  获取类似“user.config. ... device.”的字符串
- (NSString *)dataHandlerKeyWithKeyPath:(NSString *)keyPath
{
    NSArray<NSString *> *keyPathArray = [keyPath componentsSeparatedByString:@"."];
    if (keyPathArray.count <= 1) {
        return nil;
    }
    NSMutableString *ret = [NSMutableString string];
    for (NSString *word in keyPathArray) {
        // key是否符合规则，要么为属性，要么为数字下标
        if (![self isPropertyName:word] && ![self isNumber:word]) {
            return nil;
        }
        // 至最后一个字符串停止
        if ([word isEqualToString:keyPathArray.lastObject]) {
            return ret.copy;
        }
        [ret appendFormat:@"%@.", word];
    }
    return ret.copy;
}

- (BOOL)isPropertyName:(NSString *)word
{
    NSString *reg = @"^[_|a-z|A-Z][_|a-z|A-Z|0-9]*$";
    NSRange rang = [word rangeOfString:reg options:NSRegularExpressionSearch];
    if (rang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isNumber:(NSString *)word
{
    NSString *reg = @"^[0-9]+$";
    NSRange rang = [word rangeOfString:reg options:NSRegularExpressionSearch];
    if (rang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
