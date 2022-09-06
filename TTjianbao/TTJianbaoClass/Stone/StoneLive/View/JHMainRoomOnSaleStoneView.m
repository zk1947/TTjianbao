//
//  JHMainRoomOnSaleStoneView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainRoomOnSaleStoneView.h"
#import "JHSearchView.h"
#import "JHLastSaleGoodsReqModel.h"
#import "JHStonePopViewHeader.h"
#import "JHLastSaleGoodsModel.h"
#import "JHEditPriceViewController.h"
#import "JHPutawayViewController.h"
#import "JHLastSaleTableViewCell.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "JHPutShelveModel.h"

@interface JHMainRoomOnSaleStoneView()<JHTableViewCellDelegate>
{
    NSArray* tabTitleArray;
    JHSearchView* searchView;
    JHMainLiveRoomTabType pageType;
}
@property (nonatomic, strong) NSMutableArray* pageControllers;
@end

@implementation JHMainRoomOnSaleStoneView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromReeditNotify:) name:JHNotificationShelveStatusChange object:nil];
    }
    return self;
}

- (void)drawSubviewsWithPageType:(JHMainLiveRoomTabType)type
{
    pageType = type;
    [self setCornerForView];

    tabTitleArray = [NSArray arrayWithObjects:@"寄售原石", nil];
    //顶部tabs
    [self drawTabView];
    //segment需要隐藏时，处理下坐标
    if(pageType == JHMainLiveRoomTabTypeResaleStone)
    {
        [self.segmentView setHidden:YES];
        self.segmentView.size = CGSizeZero;
    }
    //search view
    [self drawSearchView];
    //page view controller
    [self drawPageViewController];
}

- (void)drawTabView
{
    NSInteger count = [tabTitleArray count];
    if(count > 0)
        [self.segmentView setTabSideMargin:(ScreenW - 90*count - 29*(count-1))/2.0];
    else
        [self.segmentView setTabSideMargin:(ScreenW)/2.0];
    [self.segmentView setSegmentTitle:tabTitleArray];
    [self.segmentView setSegmentIndicateImageWithTopOffset:6];
    CGRect frame = self.segmentView.frame;
    frame.origin.y = 0;
    self.segmentView.frame = frame;
    [self.segmentView setCurrentIndex:0];
}

- (void)drawSearchView
{
    if(!searchView)
    {
        searchView = [JHSearchView new];
        [self addSubview:searchView];
        searchView.frame = CGRectMake(0, self.segmentView.bottom, self.width, 40);
        JH_WEAK(self)
        searchView.searchAction = ^(NSString* text) {
            JH_STRONG(self)
            if([self.pageControllers count] > 0)
            {
                JHMainLiveRoomTabSubviewController *controller = self.pageControllers[0];
                [controller refreshPageBySearch:text];
            }
        };
    }
}

- (void)drawPageViewController
{
    self.pageControllers = [NSMutableArray array];
    //只有一个tab
    for (int i = 0 ; i < tabTitleArray.count; i++ )
    {
        JHMainLiveRoomTabSubviewController *controller = [[JHMainLiveRoomTabSubviewController alloc] initWithPageType:pageType channelId:self.channelId];
        controller.delegate = self;
        [_pageControllers addObject:controller];
    }

    [self setPageViewController:_pageControllers  scrollViewTop:searchView.bottom+10];
}

- (void)refreshFromReeditNotify:(NSNotification*)notify
{
    if([self.pageControllers count] > 0)
    {
        JHPutShelveModel *model =(JHPutShelveModel*)notify.object;
        if(model.showStatus == JHShelvShowStatusSuccess)
        {
            JHMainLiveRoomTabSubviewController *controller = self.pageControllers[0];
            [controller callbackRefreshData];
        }
        else
        {
//            [SVProgressHUD showErrorWithStatus:@""];
        }
    }
}

#pragma mark - events ~ JHTableViewCellDelegate
- (void)pressButtonType:(RequestType)type dataModel:(JHLastSaleGoodsModel*)model indexPath:(NSIndexPath *)indexPath
{
    switch (type) {
        case RequestTypeEdit:
        {
            JHPutawayViewController *vc = [[JHPutawayViewController alloc] init];
            vc.stoneRestoreId = model.stoneRestoreId;
            vc.editType = JHStoneEditTypeReqData;
            [JHRouterManager.jh_getViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
