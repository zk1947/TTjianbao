//
//  JHSQCollectViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQCollectViewController.h"
#import "JHSQCollectListViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JHNewStoreCollectionController.h"
#import "JHCollectMarketGoodsViewController.h"

#import "JHSQApiManager.h"
#define CategoryHeight (44)

@interface JHSQCollectViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong)  JXCategoryTitleView  *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) JHSQCollectListViewController *contentList;
//@property (nonatomic, strong) JHStoreCollectionController *storeList;
@property (nonatomic, strong) JHNewStoreCollectionController *storeList;
@property (nonatomic, strong) JHCollectMarketGoodsViewController *marketGoodsList;
@end

@implementation JHSQCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"收藏";
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
//    [self.navbar setTitle:@"收藏"];
   
    [self initCategoryView];
    
    [self getCollectStats];
   
}
-(void)initCategoryView{
    self.titles = [NSMutableArray arrayWithObjects:@"内容", @"商品", nil];
    //view
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, UI.statusAndNavBarHeight+CategoryHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight-CategoryHeight);
    [self.view addSubview:self.listContainerView];
    
    //categoryview
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, CategoryHeight)];
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.delegate = self;
    self.categoryView.titleColor = kColor666;
    self.categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
    self.categoryView.titleSelectedColor = kColor333;
    self.categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
    self.categoryView.defaultSelectedIndex = self.defaultSelectedIndex;
    //Indicator
    JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
    indicatorImageView.indicatorImageViewSize= CGSizeMake(15, 4);
    indicatorImageView.verticalMargin = 2;
    self.categoryView.indicators = @[indicatorImageView];
    
    
    self.categoryView.titles = self.titles;
    [self.view addSubview: self.categoryView];
    
}

//获取收藏统计数量
-(void)getCollectStats{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [JHSQApiManager getCollectStats:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            NSString *postTitle = [NSString stringWithFormat:@"内容 %@",respObj.data[@"post_num"]] ;
            [self.titles replaceObjectAtIndex:0 withObject:postTitle];
        }
        dispatch_group_leave(group);
    }];
    
//    dispatch_group_enter(group);
//    [JHSQApiManager getNewCollectCount:^(RequestModel *respObj, BOOL hasError) {
//        if (!hasError) {
//            NSString* goodsTitle = [NSString stringWithFormat:@"商城商品 %@",respObj.data[@"followCount"]];
//            [self.titles replaceObjectAtIndex:1 withObject:goodsTitle];
//        }
//        dispatch_group_leave(group);
//
//    }];
    dispatch_group_enter(group);
    [JHSQApiManager getC2CCollectCount:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            NSString *marketGoodsTitle = [NSString stringWithFormat:@"商品 %@",respObj.data[@"followCount"]];
            [self.titles replaceObjectAtIndex:1 withObject:marketGoodsTitle];
        }
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.categoryView.titles = self.titles;
        [self.categoryView reloadData];
    });
    
//getNewCollectCount
}
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"ddddddd%ld", (long)index);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"mmmmmmm%ld", (long)index);
}

#pragma mark - JXCategoryListContainerViewDelegate

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index==0) {
        if (!_contentList) {
            _contentList = [[JHSQCollectListViewController alloc] init];
             @weakify(self);
            _contentList.refreshCountBlock = ^{
              @strongify(self);
                [self getCollectStats];
            };
        }
        return _contentList;
    }
//    if (index==1) {
//        if (!_storeList) {
//            _storeList = [[JHNewStoreCollectionController alloc] init];
//        }
//
//        return _storeList;
//    }
    if (index == 1) {
        if (!_marketGoodsList) {
            _marketGoodsList = [[JHCollectMarketGoodsViewController alloc] init];
        }
        return _marketGoodsList;
        
    }
    return nil;
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}
@end
