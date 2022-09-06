//
//  JHNewStoreSearchResultViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHNewStoreSearchResultSubViewController.h"
#import "JHNewStoreGoodsSearchResultViewController.h"
#import "JHStoreListViewController.h"
#import "JHC2CSearchResultViewController.h"
#import "ZQSearchViewController.h"

#import "PanNavigationController.h"
#import "JHSearchResultTopTextFieldView.h"

static CGFloat const TitleViewHeight = 44.f;
static CGFloat const MJFooterHeight = 50.f;
static CGFloat const RecommendTagsViewHeight =80.f;

@interface JHNewStoreSearchResultViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, JHNewStoreSearchResultSubViewControllerDelegate, ZQSearchViewDelegate>{
    CGFloat _lastContentOffset;//记录历史滑动位移
    
    CGFloat _tagsViewScrollYOffset;//动画位移距离
    CGFloat _tagsViewLastUpContentOffset;//记录最后一次上滑偏移量
    CGFloat _tagsViewlastDownContentOffset;//记录最后一次下滑偏移量
    
    CGFloat _titleViewScrollYOffset;//动画位移距离
    CGFloat _titleViewLastUpContentOffset;//记录最后一次上滑偏移量
    CGFloat _titleViewLastDownContentOffset;//记录最后一次下滑偏移量

}
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic,   copy) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *subVCArray;

@property (nonatomic, strong) JHSearchResultTopTextFieldView *topTextFieldView;
@end

@implementation JHNewStoreSearchResultViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //滑动返回到指定页面
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.popAssignViewController = self;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消滑动返回到指定页面
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.popAssignViewController = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化变量
    [self setInitialization];
    //顶部搜索框UI
    [self setupTopTextFieldView];
    
    [self setupTitleAndSubViews];
    //把自定义的navBarView置于顶层
    [self jhBringSubviewToFront];

}

- (void)setInitialization{
    _lastContentOffset = 0.0;
    _tagsViewScrollYOffset = 0.0;
    _tagsViewLastUpContentOffset = 0.0;
    _tagsViewlastDownContentOffset = 0.0;
    _titleViewScrollYOffset = 0.0;
    _titleViewLastUpContentOffset = 0.0;
    _titleViewLastDownContentOffset = 0.0;
}

#pragma mark - UI
- (void)setupTopTextFieldView{
    [self.jhNavView addSubview:self.topTextFieldView];
    [self.topTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(44);
        make.right.equalTo(self.view).offset(-12);
        make.centerY.equalTo(self.jhLeftButton);
        make.height.offset(30);
    }];
    
}

- (void)setupTitleAndSubViews{
    [self.view addSubview:self.titleCategoryView];
    [self.titleCategoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.height.offset(TitleViewHeight);
    }];
    
    UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xF2F2F2) addToSuperview:self.titleCategoryView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TitleViewHeight-0.5);
        make.left.right.equalTo(self.titleCategoryView);
        make.height.mas_equalTo(0.5);
    }];


    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self loadData];
}

#pragma mark - LoadData
- (void)loadData{
    self.titleArray = @[@"全部",@"直播",@"一口价",@"拍卖",@"店铺",@"集市"];
    self.subVCArray = [NSMutableArray arrayWithCapacity:self.titleArray.count];
    for (int i = 0; i < self.titleArray.count; i++) {
        if (i < self.titleArray.count-1) { //集市除外
           if (i == 4) { //店铺
                JHStoreListViewController *shopVC = [[JHStoreListViewController alloc] init];
                [self.subVCArray addObject:shopVC];
            } else {
                JHNewStoreGoodsSearchResultViewController *subGoodsVC =  [[JHNewStoreGoodsSearchResultViewController alloc]init];
                [self.subVCArray addObject:subGoodsVC];

            }
        }
    }
    
    self.titleCategoryView.titles = self.titleArray;
    self.titleCategoryView.listContainer = self.listContainerView;
    if (self.fromSource == JHSearchFromLive) {
        self.titleCategoryView.defaultSelectedIndex = 1;
    } else {
        self.titleCategoryView.defaultSelectedIndex = 0;
    }
    [self.titleCategoryView reloadData];
    
    

}

#pragma mark  - Action
///重写返回按钮方法
- (void)backActionButton:(UIButton *)sender{
    for (UIViewController*controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:self.class]) {
            int index = (int)[self.navigationController.viewControllers indexOfObject:controller];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
            break;
        }
    }
    
}

#pragma mark - Delegate
#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index < self.titleArray.count-1) { //集市除外
        if (index == 4) { //店铺
            JHStoreListViewController *shopVC = self.subVCArray[index];
            [self addNeedsPropertiesForSubViewController:shopVC itemAtIndex:index];
            return shopVC;
        } else {
            JHNewStoreGoodsSearchResultViewController *subGoodsVC = self.subVCArray[index];
            [self addNeedsPropertiesForSubViewController:subGoodsVC itemAtIndex:index];
            return subGoodsVC;
        }
    } else {
        return nil;
    }
    
}

- (void)addNeedsPropertiesForSubViewController:(JHNewStoreSearchResultSubViewController *)subVC itemAtIndex:(NSInteger)index{
    subVC.titleTagIndex = index;
    subVC.delegate = self;
    subVC.searchTextfield = self.topTextFieldView;
    subVC.fromSource = self.fromSource;
    subVC.titleArray = self.titleArray;
    //来源搜索
    subVC.keyword = self.searchWord;
    subVC.keywordSource = self.searchSource;
    //来源分类
    subVC.cateId = self.topTextFieldView.isAddRecommendTags ? 0 : self.cateId;
}

#pragma mark - JXCategoryViewDelegate
//滚动/点击 都会走该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.titleCategoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
    }];
}

- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    if (index == 5) { //集市
        NSMutableString *searchString = [NSMutableString string];
        for (JHNewSearchResultRecommendTagsListModel *tagModel in self.topTextFieldView.tagsDataArray) {
            [searchString appendFormat:@"%@%@", @" ", tagModel.tagWord];//用空格连接搜索词
        }
        //移除支付串首位的空格
        NSRange range = {0,1};
        [searchString deleteCharactersInRange:range];

        ZQSearchFrom from = self.fromSource == JHSearchFromStore ? ZQSearchFromStore : ZQSearchFromLive;
        JHC2CSearchResultViewController *resultVC = [[JHC2CSearchResultViewController alloc]init];
        ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:from resultController:resultVC];
        vc.delegate = self;
        [vc beginToSearch:searchString keywordSource:@""];
        [self.navigationController pushViewController:vc animated:NO];
        return NO;
    }
    return YES;
}

#pragma mark - ZQSearchViewDelegate
- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    JHC2CSearchResultViewController *vc = (JHC2CSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data];
}

#pragma mark - JHNewStoreSearchResultSubViewControllerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView titleTagIndex:(NSInteger)index isShowRecommendTagsView:(BOOL)isShow{
    CGFloat fixHeight = TitleViewHeight;
    CGFloat contentHeight = TitleViewHeight*2;
    if (isShow) {
        fixHeight = RecommendTagsViewHeight;
        contentHeight = TitleViewHeight*4 + RecommendTagsViewHeight;
    }

    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - _lastContentOffset;
    _lastContentOffset = contentOffset;


    if (scrollView.contentSize.height >= hight + contentHeight) {//大于一页数据和非空数据判断
        //上滑
        if (offset > 0 && contentOffset > 0) {
            if (distanceFromBottom <= hight) {//到底部
                _tagsViewScrollYOffset = - fixHeight;
                if (isShow) {
                    _titleViewScrollYOffset = - TitleViewHeight;
                    [self titleViewScrollUp:contentOffset-fabs(_tagsViewScrollYOffset)];
                }
                
            } else {
                _tagsViewScrollYOffset = contentOffset - _tagsViewlastDownContentOffset;
                if (fabs(_tagsViewScrollYOffset) >= fixHeight) {
                    _tagsViewScrollYOffset = -fixHeight;

                    //推荐标签已经滑动消失->处理title滑动
                    if (isShow) {
                        [self titleViewScrollUp:contentOffset-fabs(_tagsViewScrollYOffset)];
                    }

                } else {
                    _tagsViewScrollYOffset = -fabs(_tagsViewScrollYOffset);
                }
            }
            _tagsViewLastUpContentOffset = contentOffset;

        }
        //下滑
        if (offset < 0 && distanceFromBottom > hight) {
            if (contentOffset <= 0) {//到顶部
                _tagsViewlastDownContentOffset = 0;
                _tagsViewScrollYOffset = 0;
                if (isShow) {
                    _titleViewScrollYOffset = 0;
                }
            }else{
                _tagsViewScrollYOffset = contentOffset - _tagsViewLastUpContentOffset;
                if (fabs(_tagsViewScrollYOffset) >= fixHeight) {
                    _tagsViewScrollYOffset = 0;
                    if (isShow) {
                        //推荐标签已经完全显示->处理title滑动
                        [self titleViewScrollDown:contentOffset-fabs(_tagsViewScrollYOffset)];
                    }
                }else{
                    CGFloat linjieHeight = fixHeight;
                    if (_tagsViewLastUpContentOffset <= fixHeight) {
                        linjieHeight = _tagsViewLastUpContentOffset;
                    }
                    _tagsViewScrollYOffset = -(linjieHeight-fabs(_tagsViewScrollYOffset));
                }
                //+scrollYOffset因为主动修改了scrollView.top为负数划出屏幕，滑动偏移量需要加上这个数
                _tagsViewlastDownContentOffset = contentOffset + _tagsViewScrollYOffset;

            }
        }


        CGFloat titleScrollOffset = _tagsViewScrollYOffset;
        CGFloat tagsScrollOffset = -RecommendTagsViewHeight;
        if (isShow) {
            titleScrollOffset = _titleViewScrollYOffset;
            tagsScrollOffset = _tagsViewScrollYOffset;
        }
        if (index == 4) { //店铺
        } else {
            JHNewStoreGoodsSearchResultViewController *subGoodsVC =  self.subVCArray[index];
            [subGoodsVC.recommendTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (index == 1) { //直播
                    make.bottom.equalTo(subGoodsVC.view.mas_top).offset(RecommendTagsViewHeight + tagsScrollOffset);

                }else {
                    make.bottom.equalTo(subGoodsVC.view.mas_top).offset(TitleViewHeight+RecommendTagsViewHeight+tagsScrollOffset);
                }
            }];
        }

        [self.titleCategoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight + titleScrollOffset);
        }];
        
//        NSLog(@"===aaa===%f=====%f",tagsScrollOffset,titleScrollOffset);
//        [self.listContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view).offset(_scrollYOffset);
//        }];
    }
}


///标题向上滑动
- (void)titleViewScrollUp:(CGFloat)offset{
    _titleViewScrollYOffset = offset - _titleViewLastDownContentOffset;
    if (fabs(_titleViewScrollYOffset) >= TitleViewHeight) {
        _titleViewScrollYOffset = -TitleViewHeight;
    } else {
        _titleViewScrollYOffset = -fabs(_titleViewScrollYOffset);
    }
    _titleViewLastUpContentOffset = offset;
}
///标题向下滑动
- (void)titleViewScrollDown:(CGFloat)offset{
    if (offset <= 0) {
        _titleViewScrollYOffset = 0;
    } else {
        _titleViewScrollYOffset = offset - _titleViewLastUpContentOffset;
        if (fabs(_titleViewScrollYOffset) >= TitleViewHeight) {
            _titleViewScrollYOffset = 0;
        } else {
            CGFloat linjieHeight = TitleViewHeight;
            if (_titleViewLastUpContentOffset <= TitleViewHeight) {
                linjieHeight = _titleViewLastUpContentOffset;
            }
            _titleViewScrollYOffset = -(linjieHeight-fabs(_titleViewScrollYOffset));
        }
        //+scrollYOffset因为主动修改了scrollView.top为负数划出屏幕，滑动偏移量需要加上这个数
        _titleViewLastDownContentOffset = offset + _titleViewScrollYOffset;

    }
}

#pragma mark - Lazy

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc]init];
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontBoldPingFang size:15];
        _titleCategoryView.titleColor = HEXCOLOR(0x999999);
        _titleCategoryView.backgroundColor = UIColor.whiteColor;
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:15];
        _titleCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
        _titleCategoryView.delegate = self;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = HEXCOLOR(0xFFD70F);
        lineView.indicatorWidth = 16;
        lineView.indicatorHeight = 3;
        lineView.verticalMargin = 0.5;
        _titleCategoryView.indicators = @[lineView];

    }
    return _titleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
}
- (JHSearchResultTopTextFieldView *)topTextFieldView{
    if (!_topTextFieldView) {
        _topTextFieldView = [[JHSearchResultTopTextFieldView alloc] init];
        _topTextFieldView.searchText = self.searchWord;
        [_topTextFieldView jh_cornerRadius:15 borderColor:HEXCOLOR(0xE6E6E6) borderWidth:1.5];
        @weakify(self)
        _topTextFieldView.deleteAllTagsBlock = ^{
            @strongify(self)
            [self backActionButton:nil];
        };
        
        [_topTextFieldView jh_addTapGesture:^{
            @strongify(self)
            NSMutableString *searchTags = [NSMutableString string];
            if (self.topTextFieldView.tagsDataArray.count > 0) {
                for (JHNewSearchResultRecommendTagsListModel *tagModel in self.topTextFieldView.tagsDataArray) {
                    [searchTags appendFormat:@"%@%@", @" ", tagModel.tagWord];//用空格连接搜索词
                }
                //移除支付串首位的空格
                NSRange range = {0,1};
                [searchTags deleteCharactersInRange:range];
            }
            
            JHSearchViewController_NEW *searchVC = [[JHSearchViewController_NEW alloc] init];
            searchVC.fromSource = self.fromSource;
            searchVC.searchWord = searchTags;
            searchVC.placeholder = self.searchPlaceholder.length > 0 ? self.searchPlaceholder : searchTags;
            [self.navigationController pushViewController:searchVC animated:NO];
        }];
        
       
    }
    return _topTextFieldView;
}
@end
