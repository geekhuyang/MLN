//
//  MLNListViewObserver.m
//  MLN
//
//  Created by tamer on 2020/2/14.
//

#import "MLNListViewObserver.h"

@implementation MLNListViewObserver

@synthesize listView = _listView;

- (instancetype)initWithListView:(UIView *)listView
{
    if (self = [super init]) {
        _listView = listView;
    }
    return self;
}

- (void)notifyLiveForKeyPath:(NSString *)keyPath newValue:(id)newValue oldValue:(id)oldValue
{
    
}

- (void)notify:(NSString *)keyPath newValue:(id)newValue oldValue:(id)oldValue {
    
}

- (void)notifyListChangeWithKeyPath:(NSString *)keyPath type:(MLNListViewChangeType)type indexPath:(NSIndexPath *)indexPath newValue:(id)newValue oldValue:(id)oldValue
{
    switch (type) {
        case MLNListViewChangeTypeInsert:
            
            break;
        default:
            if ([_listView respondsToSelector:@selector(reloadData)]) {
                [_listView performSelector:@selector(reloadData)];
            }
            break;
    }
}

- (void)updateTableView:(UITableView *)UITableView
{
    
}

- (void)updateCollectionview:(MLNListViewChangeType)type
{
    
}

@end
