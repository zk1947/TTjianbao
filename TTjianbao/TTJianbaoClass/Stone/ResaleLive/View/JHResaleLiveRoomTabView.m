//
//  JHResaleLiveRoomTabView.m
//  TTjianbao
//  Description:回血直播间tab：@"原石回血", @"我的回血", @"买家出价",  @"我的出价"
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHResaleLiveRoomTabView.h"
#import "JHRestoneTableViewCell.h"
#import "JHOfferPriceViewController.h"
#import "JHMyResaleListModel.h"
#import "JHGoodResaleListModel.h"
#import "JHOrderConfirmViewController.h"
#import "CommonTool.h"
#import "JHMyPriceListModel.h"
#import "JHBuyerPriceListModel.h"
#import "OrderMode.h"
#import "JHEditPriceViewController.h"
#import "JHOrderPayViewController.h"

@interface JHResaleLiveRoomTabView ()<JHTableViewCellDelegate>
{
    NSArray* tabTitleArray;
    NSString* channelId;
    NSMutableArray *controllers;
    JHActionBlock callbackAction;
}

@end

@implementation JHResaleLiveRoomTabView

- (void)drawSubviews:(NSString*)mChannelId action:(JHActionBlock)action
{
    channelId = mChannelId;
    callbackAction = action;
    //@"原石回血", @"我的回血", @"买家出价",  @"我的出价"
    tabTitleArray = [NSArray arrayWithObjects:@"原石回血", @"我的回血", @"买家出价",  @"我的出价", nil];
    
    [self setTabPageBackgroud];
    [self setCornerForViewWithTop:0.0];//上边圆角

    //顶部tabs
    [self drawTabView];
    //page view controller
    [self drawPageViewController];
}

- (void)setTabPageBackgroud
{
    self.backgroundColor = HEXCOLORA(0x000000, 0.7);
    UIImage *image = [UIImage imageNamed:@"resale_live_tab_bg"];
    image = [image stretchableImageWithLeftCapWidth:floorf(375/2.0) topCapHeight:floorf(203-2)];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
}

- (void)drawTabView
{
    NSInteger count = [tabTitleArray count];
    if(count > 0)
        [self.segmentView setTabSideMargin:(ScreenW - (60*count) - (JHFit2Size(16, 29))*(count-1))/2.0];//3tab(60)+2间隔(29)
    else
        [self.segmentView setTabSideMargin:(ScreenW)/2.0];
    [self.segmentView setTabIntervalSpace:(JHFit2Size(16, 29))];
    [self.segmentView setSegmentThemeType:JHSegmentThemeTypeClearColor];
    [self.segmentView setSegmentTitle:tabTitleArray];
    [self.segmentView setSegmentIndicateImageWithTopOffset:6];
    CGRect frame = self.segmentView.frame;
    frame.origin.y = 20;
    self.segmentView.frame = frame;
    [self.segmentView setCurrentIndex:0];
    //添加一条分隔线
    JHCustomLine* bottomLine = [[JHCustomLine alloc] initWithFrame:CGRectMake(5, self.segmentView.height-1, self.segmentView.width-5*2, 1) andColor:HEXCOLORA(0xFFFFFF, 0.2)];
    [self.segmentView addSubview:bottomLine];
}

- (void)drawPageViewController
{
    controllers = [NSMutableArray array];
    for (int i = 0 ; i < tabTitleArray.count; i++ )
    {
        JHResaleLiveRoomTabSubviewController *controller = [[JHResaleLiveRoomTabSubviewController alloc] initWithPageType:i channelId:channelId];
        controller.delegate = self;
        controller.customAction = callbackAction;
        [controllers addObject:controller];
    }

    [self setPageViewController:controllers  scrollViewTop:self.segmentView.bottom];
}

- (void)backToTableviewTop:(NSUInteger)index
{
    if (![JHRootController isLogin] && index > 0)
    {
        [JHRootController presentLoginVC:^(BOOL result)
        {
            if (result)
            {
                [self backToTableviewTopExt:index];
                [[NSNotificationCenter defaultCenter] postNotificationName:JHNotifactionNameLiveLoginFinish object:nil];

            }
        }];
    }
    else
    {
        [self backToTableviewTopExt:index];
    }
}

- (void)backToTableviewTopExt:(NSUInteger)index
{
    [super backToTableviewTop: index];
    if(index < [controllers count])
    {
        JHResaleLiveRoomTabSubviewController* controller = controllers[index];
        [controller callbackRefreshData];
    }
}

- (void)refreshTableWithTab:(JHResaleLiveRoomTabType)type
{
    NSInteger index = type;//两种类型匹配对应
    if(index < [controllers count])
    {
        JHResaleLiveRoomTabSubviewController* controller = controllers[index];
        [controller callbackRefreshData];
    }
}

//收缩page controller
- (void)shrinkPageviewController:(BOOL)shrink
{
    if(shrink)
    {
        [self.segmentView setHidden:YES];
        [self setPageViewControllerScrollViewTop:18 isScroll:NO];//当前view‘s top+18
    }
    else
    {
        [self.segmentView setHidden:NO];
        [self setPageViewControllerScrollViewTop:self.segmentView.bottom isScroll:YES];
    }
    //是否隐藏cell下半部分:出价记录
    if([controllers count] > 0 && self.lastSegmentIndex == 0)
    {
        JHResaleLiveRoomTabSubviewController* controller = controllers[0];
        [controller refreshStoneResaleWithHiddenRecord:shrink];
    }
}

#pragma mark - JHTableViewCellDelegate
- (void)pressButtonType:(RequestType)type dataModel:(id)model indexPath:(NSIndexPath *)indexPath {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC:^(BOOL result) {
            if (result) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JHNotifactionNameLiveLoginFinish object:nil];

            }
           }];
        return;
    }
    
    switch (type)
    {
        case RequestTypeCellCancelResale:
        {
            __weak JHGoodResaleListModel* m = model;
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"取消寄售后将无法再次寄售，是否确认取消寄售？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [JHCancelResaleReqModel requestCancelWithStoneId:m.stoneRestoreId channelId:channelId channelCategory:@"restoreStone" fail:^(NSString *errorMsg) {
                    if(errorMsg)
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    else
                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                }];
            }]];
            [self.viewController presentViewController:alertVc animated:YES completion:nil];
            
            [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_cancelsale variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
        }
            break;
           
        case RequestTypeOnePrice:
        {
            JHGoodResaleListModel* m = model;
            JHGoodOrderSaveReqModel *reqm = [JHGoodOrderSaveReqModel new];
            reqm.channelCategory = JHRoomTypeNameRestoreStone;
            reqm.stoneId = m.stoneRestoreId;
            reqm.orderCategory = @"restoreOrder";
            reqm.orderPrice = m.salePrice;
            [JHMainLiveSmartModel request:reqm response:^(id respData, NSString *errorMsg) {
                                
                if(errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }
                else
                {
                    JHGoodOrderSaveModel* model = [JHGoodOrderSaveModel mj_objectWithKeyValues:respData];
                    JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
                    order.fromString=JHConfirmFromRestoreWorkOrder;
                    order.orderId = model.orderId;
                    [[CommonTool findNearsetViewController:self].navigationController pushViewController:order animated:YES];
                    [((BaseView*)self.superview) hiddenAlert];
                }
            }];
        }
            break;
        case RequestTypeoOfferPrice:
            {
                JHGoodResaleListModel* m = model;
                JHOfferPriceViewController *vc = [[JHOfferPriceViewController alloc] init];
                vc.stoneRestoreId = m.stoneRestoreId;
                [self.viewController.navigationController pushViewController:vc animated:YES];
                [((BaseView*)self.superview) hiddenAlert];
            }
            break;
            
        case RequestTypeRePutPrice:
            {
                 JHMyPriceListModel* priceModel = model;
                 JHOfferPriceViewController *vc = [[JHOfferPriceViewController alloc] init];
                 vc.stoneRestoreId = priceModel.stoneRestoreId;
                 [self.viewController.navigationController pushViewController:vc animated:YES];
                
                [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_reoffer variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
             }
             break;
        
        case RequestTypeWillPrice:
            {
                JHMyPriceListModel* m = model;
                if (m.offerDetail.toPay) {
                    JHOrderPayViewController * order = [[JHOrderPayViewController alloc]init];
                    order.orderId = m.orderId;
                    [[CommonTool findNearsetViewController:self].navigationController pushViewController:order animated:YES];
                } else {
                    JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
                    order.orderId = m.orderId;
                    [[CommonTool findNearsetViewController:self].navigationController pushViewController:order animated:YES];
                }
                
                [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_payleft variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
            }
            break;
        
        case RequestTypeCancelPrice:
            {
                JHMyPriceListModel* m = model;
                [JHMyCancelPriceReqModel requestWithStoneModel:m finish:^(NSString *errorMsg) {
                    if(errorMsg)
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    else
                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                }];
            }
            break;
            
        case RequestTypeSeeSee:
            {
                JHGoodResaleListModel* m = model;
                [JHGoodSeeSaveReqModel requestWithStoneId:m.stoneRestoreId finish:^(id respData, NSString *errorMsg) {
                    if(errorMsg)
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    else
                    {
                        if(self.lastSegmentIndex < [controllers count])
                        {
                            JHGoodSeeSaveModel*seeModel = respData;
                            m.selfSeek = 1;
                            m.seekCount = seeModel.seekCount;
                            m.seekCustomerImgList = [NSArray arrayWithArray:seeModel.seekCustomerImgList];
                            JHResaleLiveRoomTabSubviewController* controller = controllers[self.lastSegmentIndex];
                            [controller refreshStoneResaleCell:indexPath model:m];
                        }
                    }
                }];
            }
            break;
            
        case RequestTypeAgreePrice:
            {
                __weak JHBuyerPriceDetailModel* m = model;//这个model不是cellModel
                
                NSString* tipText = [NSString stringWithFormat: @"是否确认接受此出价 ¥%@？", m.offerPrice ? : @"0.0"];
                
                if([m.offerPrice integerValue] < [m.salePrice integerValue])
                    tipText = @"此价格低于一口价！是否接受按此价格成交？";
                
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:tipText message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    JHGoodOrderSaveReqModel *reqm = [JHGoodOrderSaveReqModel new];
                    reqm.stoneRestoreOfferId = m.stoneRestoreOfferId;
                    reqm.channelCategory = JHRoomTypeNameRestoreStone;
                    reqm.stoneId = m.stoneRestoreId;
                    reqm.orderCategory = @"restoreOrder";
                    reqm.orderPrice = m.offerPrice;
                    
                    [JHMainLiveSmartModel request:reqm response:^(id respData, NSString *errorMsg) {
                        if(errorMsg)
                            [SVProgressHUD showErrorWithStatus:errorMsg];
                        else
                            [SVProgressHUD showSuccessWithStatus:@"接受成功"];
                    }];
                }]];
                [self.viewController presentViewController:alertVc animated:YES completion:nil];
                
                [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_receiveoffer variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
            }
            break;
            
        case RequestTypeRejectPrice:
            {
                __weak JHBuyerPriceDetailModel* m = model;
                JH_WEAK(self)
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat: @"是否确认拒绝此出价 ¥%@？", m.offerPrice ? : @"0.0"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [JHBuyerRejectPriceReqModel requestWithStoneModel:m finish:^(NSString *errorMsg) {
                        JH_STRONG(self)
                        if(errorMsg)
                            [SVProgressHUD showErrorWithStatus:errorMsg];
                        else
                        {
                            [SVProgressHUD showSuccessWithStatus:@"拒绝成功"];
                            [self refreshTableWithTab:JHResaleLiveRoomTabTypeBuyPrice];
                        }
                    }];
                }]];
                [self.viewController presentViewController:alertVc animated:YES completion:nil];
                
                [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_refuseOffer variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
            }
            break;
        
        case RequestTypeEdit:
        {
            JHGoodResaleListModel* m = model;
            JHEditPriceViewController *vc = [[JHEditPriceViewController alloc] init];
            vc.stoneId = m.stoneRestoreId;
            vc.price = m.salePrice;
            JH_WEAK(self)
            vc.baseFinishBlock = ^(id sender) {
                JH_STRONG(self)
                [self refreshTableWithTab:JHResaleLiveRoomTabTypeOnSale];
            };
            [[CommonTool findNearsetViewController:self].navigationController pushViewController:vc animated:YES];
            
            [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_changeprice variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
         }
             break;
        default:
            break;
    }
}

@end
