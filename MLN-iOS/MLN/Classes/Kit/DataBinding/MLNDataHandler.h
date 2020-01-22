//
//  MLNDataHandler.h
//  MLN
//
//  Created by tamer on 2020/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNDataHandler : NSObject

@property (nonatomic, weak, readonly) id data;
@property (nonatomic, copy) NSString *dataHandlerKey;

- (instancetype)initWithData:(id)data dataHandlerKey:(NSString *)dataHandlerKey;

- (void)updateDataForKeyPath:(NSString *)keyPath value:(id)value;
- (id __nullable)dataForKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
