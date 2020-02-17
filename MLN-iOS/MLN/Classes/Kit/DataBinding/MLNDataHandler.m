//
//  MLNDataHandler.m
//  MLN
//
//  Created by tamer on 2020/1/19.
//

#import "MLNDataHandler.h"
#import "NSObject+MLNKVO.h"

@implementation MLNDataHandler

- (instancetype)initWithData:(id)data dataHandlerKey:(NSString *)dataHandlerKey
{
    if (self = [super init]) {
        _data = data;
        _dataHandlerKey = dataHandlerKey;
    }
    return self;
}

- (void)updateDataForKeyPath:(NSString *)keyPath value:(id)value
{
    NSString *key = [keyPath stringByReplacingOccurrencesOfString:self.dataHandlerKey withString:@""];
    [self.data setValue:value forKeyPath:key];
}

- (id __nullable)dataForKeyPath:(NSString *)keyPath
{
    NSString *key = [keyPath stringByReplacingOccurrencesOfString:self.dataHandlerKey withString:@""];
    if ([self.data isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self.data objectAtIndex:[keyPath integerValue]];
    }
    return [self.data valueForKeyPath:key];
}

@end
