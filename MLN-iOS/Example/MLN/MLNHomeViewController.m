//
//  MLNViewController.h
//  MLN
//
//  Created by MoMo on 12/06/2019.
//  Copyright (c) 2019 MoMo. All rights reserved.
//

#import "MLNHomeViewController.h"
#import <MLN/MLNKit.h>
#import "MLNOfflineViewController.h"
#import "MLNHotReloadViewController.h"
#import "MLNMyRefreshHandler.h"
#import "MLNMyHttpHandler.h"
#import "MLNMyImageHandler.h"
#import <SDWebImage/SDImageCodersManager.h>
#import "MLNNavigatorHandler.h"
#import "MLNLuaGalleryViewController.h"
#import "MLNDemoListViewController.h"
#import "MLNStaticTest.h"
#import "MLNCollectionViewCell.h"
#import "MLNTestMe.h"
#import "MLNDataBinding.h"

#define kConsoleWidth 250.f
#define kConsoleHeight 280.f

@interface MLNHomeViewController () <MLNCollectionViewAdapterProtocol>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *loadingIndicatorBgView;

@property (weak, nonatomic) IBOutlet UILabel *toastLabel;
@property (weak, nonatomic) IBOutlet UIView *toastBgView;

///4个 button
@property (nonatomic, strong) NSArray *buttonsTitleArray;
@property (nonatomic, strong) NSArray *buttonsUrlArray;

@property (nonatomic, strong) MLNHotReloadViewController *luaVC;
@property (nonatomic, strong) MLNOfflineViewController *offlineViewController;
@property (nonatomic, strong) MLNHotReloadViewController *luaShow;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) MLNTestMe *model;

@end

@implementation MLNHomeViewController

MLN_VIEW_IMPORT(self.luaShow, label)
MLN_VIEW_IMPORT_WITH_ALIAS(self.luaShow, switch, mySwitch)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.model = [[MLNTestMe alloc] init];
    self.model.text = @"hello world!";
    
    self.luaShow = [[MLNHotReloadViewController alloc] init];
    self.luaShow.view.frame = CGRectMake(20, 20, 320, 200);
    [self addChildViewController:self.luaShow];
    [self.view addSubview:self.luaShow.view];
    [self.luaShow didMoveToParentViewController:self];
    
    [self.luaShow bindData:self.model key:@"userData"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.alpha = 0;
    [super viewWillDisappear:animated];
}

#pragma mark - accessor
- (void)hideToast {
    self.toastBgView.hidden = YES;
}

#pragma mark - action

- (IBAction)hotReloadAction:(id)sender {
//    MLNHotReloadViewController  *hotReloadVC = [[MLNHotReloadViewController alloc] initWithRegisterClasses:@[[MLNStaticTest class]] extraInfo:nil];
//    [self.navigationController pushViewController:hotReloadVC animated:YES];
    
//    MLNCollectionView *label = (MLNCollectionView *)[self.luaShow findViewById:@"collectionView"];
//    label.adapter = self;
//    [label lua_reloadData];
    
    self.model.text = @"热重载";
//    self.label.backgroundColor = [UIColor redColor];
//    self.mySwitch.backgroundColor = [UIColor redColor];
}

- (IBAction)demoListButtonAction:(id)sender {
//    MLNDemoListViewController *listVC = [[MLNDemoListViewController alloc] init];
//    listVC.model = self.model;
//    self.label.backgroundColor = [UIColor yellowColor];
//    [self.navigationController pushViewController:listVC animated:YES];
//     MLNCollectionView *label = (MLNCollectionView *)[self.luaShow findViewById:@"collectionView"];
//    label.adapter = self;
//    [label lua_reloadData];
    self.model.text = @"例子";
}

- (IBAction)meilishuoButtonAction:(id)sender {
//    MLNLuaGalleryViewController *viewController = [[MLNLuaGalleryViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
//     MLNCollectionView *label = (MLNCollectionView *)[self.luaShow findViewById:@"collectionView"];
//    label.adapter = self;
//    [label lua_reloadData];
    self.model.text = @"Demo工程";
//    self.label.backgroundColor = [UIColor blueColor];
}

@synthesize collectionView;


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [collectionView registerClass:[MLNCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    MLNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    [cell pushContentViewWithLuaCore:self.luaShow.kitInstance.luaCore];
    UIView *cv = [self.luaShow findViewById:@"cell"];
    [cell.luaContentView lua_addSubview:cv];
    MLNLabel *label = (MLNLabel *)[self.luaShow findViewById:@"cell_title"];
    NSString *txt = @"UNKOWN";
    if (self.type == 1) {
        txt = [NSString stringWithFormat:@"例子 - %@", indexPath];
    } else if (self.type == 2) {
        txt = [NSString stringWithFormat:@"Demo工程 - %@", indexPath];
    } else {
        txt = [NSString stringWithFormat:@"热重载 - %@", indexPath];
    }
    label.text = txt;
    
    MLNLabel *label_t = [[MLNLabel alloc] initWithLuaCore:self.luaShow.kitInstance.luaCore frame:CGRectMake(0, 0, 0, 0)];
    label_t.backgroundColor = [UIColor redColor];
    label_t.text = @"hi";
    label_t.lua_gravity = MLNGravityRight | MLNGravityBottom;
    [cv lua_addSubview:label_t];
    [cell requestLayoutIfNeed];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

- (NSString *)reuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}



@end
