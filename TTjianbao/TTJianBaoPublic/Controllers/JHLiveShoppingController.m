
//
//  JHLiveShoppingController.m
//  TTjianbao
//test
//  Created by YJ on 2020/12/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveShoppingController.h"
#import "JXPagerView/JXPagerView.h"
#import "JXCategoryBaseView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JHLivingShoppingView.h"
#import "JHLivingShoppingHeaderview.h"
#import "JHRefreshGifHeader.h"
#import "TTJianBaoColor.h"
#import "JHSQHelper.h"
#import "SGPageTitleView.h"
#import "JHShareInfo.h"
#import "JHChannleModel.h"
#import "JHBaseOperationView.h"
#import "JHChannelBannerView.h"
#import "BannerMode.h"
#import "JHChannelBannerModel.h"

#define CHANNEL_HEIGHT 95

@interface JHLiveShoppingController ()<JXPagerViewDelegate, JXCategoryViewDelegate,SGPageTitleViewDelegate,JXPagerMainTableViewGestureDelegate>
/** 标题集合*/
@property (nonatomic, strong) NSMutableArray <NSString *> *titles;
/** 滑动范围*/
@property (nonatomic, strong) JXPagerView *pagingView;
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 顶部view*/
@property (nonatomic, strong) JHLivingShoppingHeaderview *headerView;

@property (nonatomic, strong) NSMutableArray <JHLivingShoppingView*>*vcArr;

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (strong, nonatomic) JHShareInfo *shareInfo;
@property (strong, nonatomic) NSMutableArray *chanlleModelsArray;
@property (strong, nonatomic) JHChannelBannerView *bannerView;
@property (strong, nonatomic) NSMutableArray *urlsArray;
@property (nonatomic, strong) NSMutableArray *detailsIdArray;
@property (nonatomic, strong) NSMutableArray *bannerModelsArray;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) CGFloat banner_height;

@end

@implementation JHLiveShoppingController

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIView* view = gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:view];
    if (loc.y < (self.banner_height + CHANNEL_HEIGHT))
    {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    self.jhTitleLabel.text = self.titleStr;
    
    [self initRightButtonWithImageName:@"share_live" action:@selector(clickShareBtn)];
    
    self.currentIndex = 0;
    
    self.banner_height = 0;
    
    [self getChannelData];
    
}

//分享
- (void)clickShareBtn
{
    [JHBaseOperationView creatShareOperationView:self.shareInfo object_flag:nil];
}

- (void)getChannelData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.chanlleModelsArray = [NSMutableArray new];
    self.vcArr = [NSMutableArray array];
    self.bannerModelsArray = [NSMutableArray new];
    self.titles = [NSMutableArray new];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.groupId forKey:@"groupId"];
    NSString *url = FILE_BASE_STRING(@"/sellGroup/channelGroupOperation");
    //http://api-testc.ttjianbao.com/sellGroup/channelGroupOperation?groupId=10015
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSArray *dataArray = [NSArray new];
        dataArray = [respondObject.data valueForKey:@"sellChannelGroupDTO"];
                
        NSArray *definiDetailsArray = [NSArray new];
        NSDictionary *dic = [respondObject.data valueForKey:@"operationDefiniListResponse"];
        if ([self isDictionary:dic])
        {
            definiDetailsArray = [dic valueForKey:@"definiDetails"];
            
            if (definiDetailsArray.count > 0)
            {
                CGFloat scale = ScreenW/375;
                
                self.banner_height = scale * 150;
                
                [definiDetailsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                {
                    JHChannelBannerModel *model = [JHChannelBannerModel mj_objectWithKeyValues:obj];
                    [self.bannerModelsArray addObject:model];
                }];

                [self setBannerViewModels:self.bannerModelsArray];
            }
            else
            {
                self.banner_height = 0;
            }
        }
                
        NSDictionary *shareData = [respondObject.data valueForKey:@"shareData"];
        self.shareInfo = [JHShareInfo mj_objectWithKeyValues:shareData];
        
        if (dataArray.count > 0)
        {
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                JHChannleModel *model = [JHChannleModel mj_objectWithKeyValues:obj];
                model.isSelected = NO;
                
                [self.chanlleModelsArray addObject:model];
                
                [self.titles addObject:model.name];
                
                JHLivingShoppingView *listView = [[JHLivingShoppingView alloc] initWithFrame:self.view.bounds];
                
                [self.vcArr addObject:listView];
            }];
    
            [self setPageViewChannelModels:self.chanlleModelsArray];
            
        }
        [self configUI];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UITipView showTipStr:respondObject.message?:@"网络请求失败"];
    }];
}

- (BOOL)isDictionary:(NSDictionary *)dic
{
   if (dic != nil && ![dic isKindOfClass:[NSNull class]] && ![dic isEqual:[NSNull null]])
   {
       return YES;
   }
   else
   {
       return NO;
   }
}
- (void)setBannerViewModels:(NSMutableArray *)channleModelsArray
{
    self.bannerView.channelModelArray = channleModelsArray;
}

- (void)setPageViewChannelModels:(NSMutableArray *)models
{
    self.pageTitleView.selectedIndex = 0;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0 , ScreenW, CHANNEL_HEIGHT) delegate:self channelModels:models];
    
    [self.categoryView addSubview:self.pageTitleView];
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex
{
    self.currentIndex = selectedIndex;
    
    [self.categoryView selectItemAtIndex:selectedIndex];
    
    JHChannleModel *model = self.chanlleModelsArray[selectedIndex];
        
    if (!model.isSelected)
    {
        JHLivingShoppingView *listView = self.vcArr[selectedIndex];
        listView.text = model.name;
        listView.groupId = model.ID;
        listView.channelName = self.titleStr;
    }
    model.isSelected = YES;
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView repeatClickIndex:(NSInteger)index
{
    [self.categoryView selectItemAtIndex:index];
}

- (void)configUI
{
    [self.view addSubview:self.pagingView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.banner_height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return CHANNEL_HEIGHT;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.vcArr.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index
{
    JHLivingShoppingView *view = self.vcArr[index];
    return view;
}

- (JHLivingShoppingHeaderview *)headerView
{
    if (_headerView == nil)
    {
        _headerView = [[JHLivingShoppingHeaderview alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.banner_height)];
    }
    return _headerView;
}

- (JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil)
    {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, CHANNEL_HEIGHT)];
        _categoryView.backgroundColor = BACKGROUND_COLOR;
        _categoryView.titleColor = RGB(102, 102, 102);
        _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        _categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _categoryView.titleSelectedColor = RGB(51, 51, 51);
        _categoryView.cellSpacing = 15;
        _categoryView.titles = self.titles;
        JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImgView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
        indicatorImgView.indicatorImageViewSize = CGSizeMake(15, 4);
        indicatorImgView.verticalMargin = 4;
        _categoryView.indicators = @[indicatorImgView];
    }
    return _categoryView;
}

- (JXPagerView *)pagingView{
    if (_pagingView == nil) {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.mainTableView.gestureDelegate = self;
        _pagingView.backgroundColor = BACKGROUND_COLOR;
        _pagingView.isListHorizontalScrollEnabled = NO;
        _pagingView.frame = CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, kScreenHeight - UI.statusAndNavBarHeight);
    }
    return _pagingView;
}

- (JHChannelBannerView *)bannerView
{
    if (!_bannerView)
    {
        _bannerView = [[JHChannelBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.banner_height)];
        _bannerView.backgroundColor = BACKGROUND_COLOR;
        [self.headerView addSubview:_bannerView];
    }
    
    return _bannerView;
}

@end
