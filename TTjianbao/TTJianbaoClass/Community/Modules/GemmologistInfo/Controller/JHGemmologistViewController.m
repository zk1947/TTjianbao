//
//  JHGemmologistViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGemmologistViewController.h"
#import "JHGemmologistHeaderView.h"
#import "JXPagerView/JXPagerView.h"
#import "JXCategoryBaseView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JHGemmologistHistoryViewController.h"
#import "JHUserInfoCommentListController.h"
#import "JHUserInfoPostController.h"

#import "JHAnchorInfoModel.h"
#import "JHEasyPollSearchBar.h"
#import "JHSQHelper.h"
#import "JHSQSearchViewController.h"

#define kLeftSpace 40
#define kRightSpace 15
#define kSearchBarWidth  (ScreenW - kLeftSpace - kRightSpace)

static NSString *const kOtherPlaceholder = @"搜索TA的内容";
static NSString *const kMinePlaceholder = @"搜索我的内容";
static const CGFloat JHheightForHeaderInSection = 50;

@interface JHGemmologistViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>
{
    ///记录导航栏的透明度
    CGFloat _alphaValue;
}
@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;
@property (nonatomic, strong) JXPagerView *pagingView;
/** 表头部分*/
@property (nonatomic, strong) JHGemmologistHeaderView * gemmologistHeaderView;
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@property (nonatomic, assign) BOOL popPan;

@end

@implementation JHGemmologistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vie
//    self.titles = @[@"鉴定视频 0", @"评过0", @"发过 0", @"赞过 0"];
    self.titles = @[@"鉴定视频 0"];
    self.categoryView.titles = self.titles;
    JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImgView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
    indicatorImgView.indicatorImageViewSize = CGSizeMake(15, 4);
    indicatorImgView.verticalMargin = 4;
    self.categoryView.indicators = @[indicatorImgView];
    
    [self.view addSubview:self.pagingView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    /** 加载数据*/
    [self fetchAnchorInfo];
    [self getHistoryStasticsInfo];
    [self setupNav];
    
    //埋点
    [JHGrowingIO trackEventId:JHEventAssayerprofile variables:@{JHKeyPagefrom:_pageFrom?:JHPageFromOther}];
}
#pragma mark - NavigationBar
- (void)setupNav {
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackWhiteShadowImg withHImage:kNavBackWhiteShadowImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self showNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
//    self.navbar.ImageView.backgroundColor = [UIColor clearColor];
    
    ///搜索框
    _searchBar = [JHSQHelper searchBar];
    _searchBar.placeholder = kOtherPlaceholder;
    [self.jhNavView addSubview:_searchBar];
    _searchBar.frame = CGRectMake(kLeftSpace, 0, kSearchBarWidth, kSearchBarHeight);
    CGPoint point = _searchBar.center;
    point.y = UI.statusAndNavBarHeight - UI.navBarHeight/2.0;//self.jhLeftButton.centerY;
    _searchBar.center = point;
    @weakify(self);
    _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
        @strongify(self);
        [self enterSearchPage];
    };
}
- (BOOL)isSelf {
    if ([self.anchorId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        return YES;
    }
    return NO;
}
///进入搜索界面
- (void)enterSearchPage {
    JHSQSearchViewController * vc =  [[JHSQSearchViewController alloc]init];
    vc.user_id = [self.anchorId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 加载数据
- (void)fetchAnchorInfo {
    //请求鉴定师的信息的接口
    [HttpRequestTool getWithURL:[COMMUNITY_FILE_BASE_STRING(@"/user/homePage/") stringByAppendingString:self.anchorId] Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHAnchorHomeModel *model = [JHAnchorHomeModel mj_objectWithKeyValues:respondObject.data];
        self.gemmologistHeaderView.model = model;
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}
/** 获取数量*/
- (void)getHistoryStasticsInfo {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/user/history?type=0&user_id=%@"), self.anchorId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        RequestModel *model = (RequestModel *)respondObject;
        [self updateCategoryValue:model];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
- (void)updateCategoryValue:(RequestModel *)respObj {
    NSDictionary *dic = respObj.data;
    NSString *determine = [NSString stringWithFormat:@"鉴定视频 %ld", (long)[dic[@"appraise_num"] integerValue]];
//    NSString *comment = [NSString stringWithFormat:@"评过 %ld", (long)[dic[@"comment_num"] integerValue]];
//    NSString *publish = [NSString stringWithFormat:@"发过 %ld", (long)[dic[@"publish_num"] integerValue]];
//    NSString *like = [NSString stringWithFormat:@"赞过 %ld", (long)[dic[@"liked_num"] integerValue]];
//    self.titles = @[determine, comment, publish, like];
    self.titles = @[determine];
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];
}
#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.gemmologistHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.gemmologistHeaderView.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JHheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        [JHGrowingIO trackEventId:@"profile_appraisal_click"];
        JHGemmologistHistoryViewController *historyViewController = [[JHGemmologistHistoryViewController alloc] init];
        historyViewController.anchorId = self.anchorId;
        return historyViewController;
    }else if (index == 1){
        JHUserInfoCommentListController *commentVC = [[JHUserInfoCommentListController alloc] init];
        commentVC.userId = self.anchorId;
        return commentVC;
    }else if (index == 2){
        JHUserInfoPostController *publishVC = [[JHUserInfoPostController alloc] init];
        publishVC.userId = self.anchorId;
        publishVC.infoType = JHPersonalInfoTypePublish;
        return publishVC;
    }else{
        JHUserInfoPostController *likeVC = [[JHUserInfoPostController alloc] init];
        likeVC.userId = self.anchorId;
        likeVC.infoType = JHPersonalInfoTypeLike;
        return likeVC;
    }
}

#pragma mark - JXCategoryViewDelegate
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
    [self.gemmologistHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
    ///改变导航栏透明度
    CGFloat thresholdDistance = 100;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat ignoreOffsetY = 30.0; //忽略滑动的偏移量
    _alphaValue = (offsetY - ignoreOffsetY) / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    [self updateNaviBar];
}

- (void)updateNaviBar {
    BOOL isHidden = _alphaValue <= 0.5;
    [UIView animateWithDuration:0.25 animations:^{
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
        [self.jhLeftButton setImage:(isHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg) forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if(index == 0) {
        [JHGrowingIO trackEventId:@"profile_appraisal_click"];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXPagerMainTableViewGestureDelegate
//解决左右滑动冲突
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView* view = gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:view];
    if (loc.y < self.gemmologistHeaderView.height + JHheightForHeaderInSection) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
#pragma  mark -UI绘制
- (JHGemmologistHeaderView *)gemmologistHeaderView{
    if (_gemmologistHeaderView == nil) {
        _gemmologistHeaderView = [[JHGemmologistHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
        _gemmologistHeaderView.isFromLivingRoom = self.isFromLivingRoom;
        JH_WEAK(self);
        _gemmologistHeaderView.changeHeightBlock = ^(CGFloat viewHeight) {
            JH_STRONG(self);
            self.gemmologistHeaderView.height = viewHeight;
            [self.pagingView reloadData];
        };
        
        _gemmologistHeaderView.followClickBlock = ^(BOOL follow) {
            JH_STRONG(self);
            if (self.finishFollow) {
                self.finishFollow(self.anchorId, follow);
            }
        };
    }
    return _gemmologistHeaderView;
}

- (JXCategoryTitleView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, JHheightForHeaderInSection)];
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.titleColor = RGB(102, 102, 102);
        _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        _categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _categoryView.titleSelectedColor = RGB(51, 51, 51);
        _categoryView.cellSpacing = 5;
    }
    return _categoryView;
}

- (JXPagerView *)pagingView{
    if (_pagingView == nil) {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.mainTableView.gestureDelegate = self;
        _pagingView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _pagingView.pinSectionHeaderVerticalOffset = UI.statusAndNavBarHeight;
    }
    return _pagingView;
}
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pagingView.mainTableView.scrollEnabled = YES;
    _popPan = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pagingView.mainTableView.scrollEnabled = NO;
    _popPan = NO;
}
@end
