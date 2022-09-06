//
//  JHMainLiveRoomTabView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainLiveRoomTabView.h"
#import "JHMainLiveRoomTabSubviewController.h"
#import "JHSearchView.h"
#import "JHStonePopViewHeader.h"
#import "JHAnchorBreakPaperViewController.h"
#import "JHSendOrderProccessGoodServiceView.h"
#import "JHPutawayViewController.h"
#import "ChannelMode.h"
#import "CommonTool.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "JHEditPriceViewController.h"
#import "JHUCOnSaleListModel.h"
#import "JHBackUpLoadManage.h"
#import "JHPrinterManager.h"

@interface JHMainLiveRoomTabView () <JHTableViewCellDelegate>
{
    NSArray* tabTitleArray;
    JHSearchView* searchView;
    NSString* channelId;
}
@property (nonatomic, strong) NSMutableArray* pageControllers;
@end

@implementation JHMainLiveRoomTabView

- (void)drawSubviews:(NSString*)mChannelId
{
    [self setCornerForView];
    channelId = mChannelId;
    tabTitleArray = [NSArray arrayWithObjects:@"最近售出", @"待上架原石", @"宝友求看",  @"宝友下架", nil];
    //顶部tabs
    [self drawTabView];
    //search view
    [self drawSearchView];
    //page view controller
    [self drawPageViewController];
}

- (void)drawTabView
{
    NSInteger count = [tabTitleArray count];
    if(count > 0)
        [self.segmentView setTabSideMargin:(ScreenW - (60 + JHFit2Size(13, 24))*(count-1) - 75)/2.0];//3tab(60)+1tab(75)+3间隔24
    else
        [self.segmentView setTabSideMargin:(ScreenW - 75)/2.0];
    [self.segmentView setTabIntervalSpace:JHFit2Size(13, 24)];
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
            if(self.lastSegmentIndex < [self.pageControllers count])
            {
                JHMainLiveRoomTabSubviewController *controller = self.pageControllers[self.lastSegmentIndex];
                [controller refreshPageBySearch:text];
            }
        };
    }
}

- (void)drawPageViewController
{
    _pageControllers = [NSMutableArray array];
    for (int i = 0 ; i < tabTitleArray.count; i++ )
    {
        JHMainLiveRoomTabSubviewController *controller = [[JHMainLiveRoomTabSubviewController alloc] initWithPageType:i channelId:channelId];
        controller.delegate = self;
        [_pageControllers addObject:controller];
    }

    [self setPageViewController:_pageControllers  scrollViewTop:searchView.bottom+10];
}

- (void)backToTableviewTop:(NSUInteger)index
{
    [super backToTableviewTop: index];
    if(index < [_pageControllers count])
    {
        JHMainLiveRoomTabSubviewController* controller = _pageControllers[index];
        [controller callbackRefreshData];
    }
}

- (void)refreshTableWithTab:(JHMainLiveRoomTabType)type
{
    NSInteger index = type;//两种类型匹配对应
    if(index < [_pageControllers count])
    {
        JHMainLiveRoomTabSubviewController* controller = _pageControllers[index];
        [controller callbackRefreshData];
    }
}

#pragma mark - events ~ JHTableViewCellDelegate
- (void)pressButtonType:(RequestType)type dataModel:(JHLastSaleGoodsModel*)model indexPath:(NSIndexPath *)indexPath
{
     switch (type) {
        case RequestTypeResale: {
            JHPopForSaleView *resale = [[JHPopForSaleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            resale.model = model;
            resale.channelCategory = JHRoomTypeNameRestoreStone;
            [resale showAlert];
            [self hiddenAlert];
        }
            break;
        case RequestTypeSendBack:
        {//channelCategory???
            [JHMainLiveSendBackReqModel request:@"restoreStone" stoneId:model.stoneRestoreId finish:^(NSString *errorMsg) {
                if(errorMsg)
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                else {
                    [SVProgressHUD showSuccessWithStatus:@"寄回成功"];
                    [self hiddenAlert];

                }
            }];
        }
            break;
                
            case RequestTypeProcess: {
                                
                JHStoneDealPaperView *view = [[JHStoneDealPaperView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                view.channelCategory = self.channelCategory;
                [view setModel:model];
                [view showAlert];
                [self hiddenAlert];
            }
                break;

        case RequestTypeBreakPaper: {
            
            JHAnchorBreakPaperViewController *vc = [[JHAnchorBreakPaperViewController alloc] init];
            vc.stoneId = model.stoneRestoreId?:model.stoneId;
            vc.channelCategory = JHRoomTypeNameRestoreStone;
            vc.priceTotal = model.purchasePrice;
            [self.viewController.navigationController pushViewController:vc animated:YES];
            [self hiddenAlert];
        }
            break;
            
        case RequestTypePutShelf: {
            if(model.shelfState == JHShelvShowStatusShelveButton)
            {
                JHPutawayViewController *vc = [[JHPutawayViewController alloc] init];
                vc.isOnlyLibrary = !self.isAssitant;
                vc.stoneRestoreId = model.stoneRestoreId;
                JH_WEAK(self)
                vc.baseFinishBlock = ^(id sender) {
                    JH_STRONG(self)
                    [self refreshTableWithTab:JHMainLiveRoomTabTypeWillSale];
                };
                [self.viewController.navigationController pushViewController:vc animated:YES];
//                [self hiddenAlert];
            }
            else if(model.shelfState == JHShelvShowStatusShelveFail)
            {
                [[JHBackUpLoadManage shareInstance] startUpLoadWithStoneId:model.stoneRestoreId];
            }
        }
            break;
         
         case RequestTypeNotificationUser:
         {
             JHUCOnSaleListModel* m = (JHUCOnSaleListModel*)model;
             [JHResaleInformReqModel requestWithStoneId:m.stoneRestoreId finish:^(NSString *errorMsg) {
                    if(errorMsg)
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    else {
                        [SVProgressHUD showSuccessWithStatus:@"通知成功"];
                    }
                }];
         }
             break;
         
         case RequestTypeEdit:
         {
             JHUCOnSaleListModel* m = (JHUCOnSaleListModel*)model;
             JHEditPriceViewController *vc = [[JHEditPriceViewController alloc] init];
             vc.price = m.salePrice;
             vc.stoneId = m.stoneRestoreId;
             [[CommonTool findNearsetViewController:self].navigationController pushViewController:vc animated:YES];
             [self hiddenAlert];

         }
             break;
             
        case RequestTypePrintGoodCode:
        {
            [[JHPrinterManager sharedInstance] printStoneBarCode:model.goodsCode andResult:^(BOOL success, NSString *desc) {
                if(success)
                    [SVProgressHUD showSuccessWithStatus:@"打印成功"];
                else
                    [SVProgressHUD showErrorWithStatus:desc];
                    
            }];
        }
            break;
             
        default:
            break;
        }
}

@end
