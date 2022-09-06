//
//  JHRecycleSoldOutViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSoldOutViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorImageView.h"
#import "JHRecycleMineSoldViewController.h"
#import "JHWebViewController.h"
#import "JHRecycleSoldViewModel.h"
#import "UserInfoRequestManager.h"

static const CGFloat JHheightForHeaderInSection = 44.;

@interface JHRecycleSoldOutViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 容器*/
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
/** 控制器*/
@property (nonatomic, strong) NSMutableArray *vcArr;
/** */
@property (nonatomic, strong) JHRecycleMineSoldViewController *moneyVc;
/** url*/
@property (nonatomic, copy) NSString *urlString;

@end

@implementation JHRecycleSoldOutViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.categoryView selectItemAtIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"我卖出的";
    [self configUI];
    [self getUrlStringData];
}

///获取存金通地址
- (void)getUrlStringData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"mobile"] = [UserInfoRequestManager sharedInstance].user.mobile;
    [JHRecycleSoldViewModel getGoldUrlString:params Completion:^(NSError * _Nullable error, NSString * _Nullable urlString) {
        if (!error) {
            self.urlString = urlString;
        }
    }];
}

- (void)configUI {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(JHheightForHeaderInSection);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];

    self.categoryView.titles = @[@"钱币回收", @"黄金钻石回收"];
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.defaultSelectedIndex = 0;
    [self.categoryView reloadData];
}

#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if (index == 1) {
        if (self.urlString.length > 0) {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = self.urlString;
//            webView.isNeedPop = YES;
            webView.isHiddenNav = YES;
            webView.view.backgroundColor = UIColor.whiteColor;
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }
    }
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 1;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
//    return self.vcArr[index];
    return self.moneyVc;
}
- (JXCategoryTitleView *)categoryView {
   if (_categoryView == nil) {
       _categoryView = [[JXCategoryTitleView alloc] init];
       _categoryView.backgroundColor = [UIColor clearColor];
       _categoryView.titleColor = kColor999;
       _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14.];
       _categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:14.];
       _categoryView.titleSelectedColor = HEXCOLOR(0x222222);
       _categoryView.averageCellSpacingEnabled = NO;
       _categoryView.contentEdgeInsetLeft = 17.;
       _categoryView.cellSpacing = 30;
       _categoryView.delegate = self;
       
//       JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
//       indicatorImgView.indicatorImageView.backgroundColor = HEXCOLOR(0xfee100);
//       indicatorImgView.indicatorImageViewSize = CGSizeMake(21, 3);
//       indicatorImgView.layer.cornerRadius = 1.5;
//       indicatorImgView.clipsToBounds = YES;
//       indicatorImgView.verticalMargin = 8;
//       _categoryView.indicators = @[indicatorImgView];
   }
   return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
   if (!_listContainerView) {
       _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
       _listContainerView.scrollView.scrollEnabled = NO;
   }
   return _listContainerView;
}

- (NSMutableArray *)vcArr {
    if (_vcArr == nil) {
        _vcArr = [NSMutableArray array];
//        JHRecycleMineSoldViewController *moneyVc = [[JHRecycleMineSoldViewController alloc] init];
//        [_vcArr addObject:moneyVc];
//        JHRecycleGoldViewController *goldVc = [[JHRecycleGoldViewController alloc] init];
//        [_vcArr addObject:goldVc];
    }
    return _vcArr;
}

- (JHRecycleMineSoldViewController *)moneyVc {
    if (_moneyVc == nil) {
        _moneyVc = [[JHRecycleMineSoldViewController alloc] init];
    }
    return _moneyVc;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return self.categoryView;
}


@end
