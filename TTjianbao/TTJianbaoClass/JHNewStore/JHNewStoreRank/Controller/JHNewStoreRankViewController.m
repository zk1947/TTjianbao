//
//  JHNewStoreRankViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreRankViewController.h"
#import "JHNewStoreRankListViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHStoreRankTagModel.h"
#import "JHStoreRankListViewModel.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

static const CGFloat JHheightForHeaderInSection = 45;

@interface JHNewStoreRankViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
/** 控制器*/
@property (nonatomic, strong) NSMutableArray<JHNewStoreRankListViewController *> *vcArr;
/** 标题*/
@property (nonatomic, strong) NSArray *titles;
/** tagModel*/
@property (nonatomic, strong) JHStoreRankTagModel *tagModel;
/** 背景图*/
@property (nonatomic, strong) YYAnimatedImageView *backImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *rankTitleLabel;
/** 左麦穗*/
@property (nonatomic, strong) UIImageView *leftImageView;
/** 右麦穗*/
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation JHNewStoreRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xf5f5f8);
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self jhSetLightStatusBarStyle];
    [self configUI];
    [self loadData];
    [self jhBringSubviewToFront];
    [JHAllStatistics jh_allStatisticsWithEventId:@"dpbdPageView" params:@{@"page_name":@"店铺榜单"} type:JHStatisticsTypeSensors];
}

- (void)configUI {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.rankTitleLabel];
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.rightImageView];
    [self.view addSubview:self.categoryView];

    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(ScreenW * 260 / 375);
    }];
    
    [self.rankTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(56);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 66);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rankTitleLabel.mas_left).offset(-4);
        make.centerY.mas_equalTo(self.rankTitleLabel.mas_centerY);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(30);
    }];

    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rankTitleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.rankTitleLabel.mas_centerY);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(30);
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.rankTitleLabel.mas_bottom).offset(7);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(JHheightForHeaderInSection);
    }];
    
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.rankId;
    [SVProgressHUD show];
    [JHStoreRankListViewModel getRankTagList:params Completion:^(NSError * _Nullable error, JHStoreRankTagModel * _Nullable model) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.tagModel = model;
            self.title = self.tagModel.topTitleName;
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.tagModel.bgImgUrl]];
            self.rankTitleLabel.text = self.tagModel.showName;
            [self setUI];
        }
    }];
}

- (void)setUI {
    NSMutableArray *titleArray = [NSMutableArray array];
    for (JHStoreRankTagListModel *model in self.tagModel.tagList) {
        [titleArray addObject:model.tagName];
        JHNewStoreRankListViewController *listVc = [[JHNewStoreRankListViewController alloc] init];
        listVc.tagId = model.tagId;
        [self.vcArr addObject:listVc];
    }
    self.titles = titleArray;
    self.categoryView.titles = self.titles;
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    self.listContainerView.backgroundColor = [UIColor clearColor];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.categoryView.defaultSelectedIndex = 0;
    [self.categoryView reloadData];
}

#pragma mark -
#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [JHAllStatistics jh_allStatisticsWithEventId:@"bdtabClick" params:@{@"tab_name":self.titles[index]} type:JHStatisticsTypeSensors];
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.vcArr.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}

- (UILabel *)rankTitleLabel {
    if (_rankTitleLabel == nil) {
        _rankTitleLabel = [[UILabel alloc] init];
        _rankTitleLabel.textColor = [UIColor whiteColor];
        _rankTitleLabel.font = [UIFont fontWithName:kFontBoldDIN size:20];
        _rankTitleLabel.numberOfLines = 2;
        _rankTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankTitleLabel;
}

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"newStore_rank_maisui_left"];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"newStore_rank_maisui_right"];
    }
    return _rightImageView;
}


- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.titleColor = HEXCOLOR(0xffffff);
        _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
        _categoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldDIN size:14];
        _categoryView.titleSelectedColor = HEXCOLOR(0xffffff);
        _categoryView.cellSpacing = 10;
        _categoryView.delegate = self;
        
        JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImgView.indicatorImageView.backgroundColor = [UIColor whiteColor];
        indicatorImgView.indicatorImageViewSize = CGSizeMake(28, 3);
        indicatorImgView.layer.cornerRadius = 1.5;
        indicatorImgView.clipsToBounds = YES;
        indicatorImgView.verticalMargin = 8;
        _categoryView.indicators = @[indicatorImgView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (YYAnimatedImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[YYAnimatedImageView alloc] init];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
    }
    return _backImageView;
}

- (NSMutableArray<JHNewStoreRankListViewController *> *)vcArr {
    if (_vcArr == nil) {
        _vcArr = [NSMutableArray array];
    }
    return _vcArr;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return self.categoryView;
}

@end
