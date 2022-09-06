//
//  JHGreetViewController.m
//  TTjianbao
//
//  Created by YJ on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGreetViewController.h"
#import "JXCategoryTitleView.h"
#import "JXPagerView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JHMyNewsViewController.h"
#import "JHMyCommentsViewController.h"
#import "JHUserInfoCommentListController.h"
#import "JHUserInfoPostController.h"
#import "JHMessageSubListController.h"

static const CGFloat kCategoryTitleHeight = 48.f;

@interface JHGreetViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation JHGreetViewController

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jhTitleLabel.text = @"@我的";
    
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [self configCategoryView];

    [self clearMsgNum];
}

- (void)clearMsgNum
{
    NSString *url = FILE_BASE_STRING(@"/mc/app/mc/auth/msg/at");
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog("111");
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog("error");
    }];
}

- (void)configCategoryView
{
    _titles = @[@"@我的动态", @"@我的评论"];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, kCategoryTitleHeight)];
    self.categoryView.titles = _titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kColor333;
    self.categoryView.titleColor = kColor666;
    self.categoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldDIN size:15];
    self.categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomEnabled = NO;
    if ([self.pageIndex integerValue] < 2)
    {
        self.categoryView.defaultSelectedIndex = [self.pageIndex integerValue];
    }
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kColorMain;
    lineView.indicatorWidth = 15;
    lineView.verticalMargin = 6;
    self.categoryView.indicators = @[lineView];
    
    UIView *separateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    separateLineView.backgroundColor = kColorF5F6FA;
    [self.categoryView addSubview:separateLineView];
    
    [self.view addSubview:self.pagingView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
}

- (JXPagerView *)pagingView
{
    if (_pagingView == nil)
    {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.mainTableView.gestureDelegate = self;
        //_pagingView.isListHorizontalScrollEnabled = NO;
        _pagingView.frame = CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, kScreenHeight - UI.statusAndNavBarHeight);
    }
    return _pagingView;
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView
{
    return [UIView new];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView
{
    return 0.01;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView
{
    return kCategoryTitleHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView
{
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView
{
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        JHMyNewsViewController *newsVC = [[JHMyNewsViewController alloc] init];
        newsVC.infoType = JHPersonalInfoTypePublish;
        return newsVC;
    }
    else
    {
        JHMyCommentsViewController *commentsVC = [[JHMyCommentsViewController alloc] init];
        return commentsVC;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
