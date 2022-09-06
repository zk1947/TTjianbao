//
//  JHPurchaseStoneViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseStoneViewController.h"
#import "JHOrderDetailViewController.h"
#import "UserInfoRequestManager.h"

@interface JHPurchaseStoneViewController () <JHPurchaseStoneViewDelegate, JHPurchaseStoneModelDelegate>
{
    NSMutableArray* dataArr;
    NSUInteger pageIndex;
}

@property (nonatomic, strong) JHPurchaseStoneView* purchaseStoneView;
@property (nonatomic, strong) JHPurchaseStoneModel* dataModel;
@end

@implementation JHPurchaseStoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //优先请求数据
    [self reloadNewData:YES];
    //绘制
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    //title
      if(_pageType == JHStonePageTypeSendOrder)
          self.title = @"寄回原石";
      else if(_pageType == JHStonePageTypeStoneOrder)
          self.title = @"原石订单";
      else
          self.title = @"买入原石";
    //view
    [self.view addSubview:self.purchaseStoneView];
    [_purchaseStoneView setupView];
    [_purchaseStoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight+9);
        make.height.mas_equalTo(self.view.height-UI.statusAndNavBarHeight-9);
    }];
    
    //设置数据显示
    [_purchaseStoneView updateData:dataArr pageType:_pageType];
}

- (JHPurchaseStoneView*)purchaseStoneView
{
    if(!_purchaseStoneView)
    {
        _purchaseStoneView = [JHPurchaseStoneView new];
        _purchaseStoneView.backgroundColor = [UIColor clearColor];
        _purchaseStoneView.delegate = self;
    }
    return _purchaseStoneView;
}
//无数据界面
- (void)mayShowEmptyPage:(NSArray*)dataArray
{
    if([dataArr count] > 0)
    {
        [self hiddenDefaultImage];
        if([dataArray count] < kListPageSize)
            [self.purchaseStoneView hideRefreshMoreWithData:NO];
        else
            [self.purchaseStoneView hideRefreshMoreWithData:YES];
    }
    else
    {
        [self showDefaultImageWithView:self.purchaseStoneView];
        [self.purchaseStoneView hideRefreshMoreWithData:NO];
    }
}

#pragma mark - request
- (JHPurchaseStoneModel*)dataModel
{
    if(!_dataModel)
    {
        _dataModel = [JHPurchaseStoneModel new];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

- (void)reloadNewData:(BOOL)isNew
{
    if(isNew)
    {
        pageIndex = 0;
        [SVProgressHUD show];
    }
    else
        ++pageIndex;
    [self request:pageIndex];
}

- (void)request:(NSUInteger)pageIndex
{
    [self.dataModel requestWithType:_pageType pageIndex:pageIndex];
}

- (void)responseData:(NSArray*)dataArray error:(NSString*)errorMsg
{
    if(!errorMsg)
    {
        NSArray* arr = dataArray;
        if(pageIndex > 0)
        {
            [dataArr addObjectsFromArray:arr];
        }
        else
        {
            dataArr = [NSMutableArray arrayWithArray:arr];
        }
        
        [self.purchaseStoneView updateData:dataArr pageType:_pageType];
    }

    [self mayShowEmptyPage:dataArray];
    [SVProgressHUD dismiss];
}

- (void)gotoOrderDetailPage:(JHPurchaseStoneListModel*)model
{
    JHOrderDetailViewController* detail = [JHOrderDetailViewController new];
    detail.orderId = model.orderId;
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.blRole_restoreAnchor||
        user.blRole_restoreAssistant) {
        detail.isSeller=YES;
    }
    detail.stoneId = model.stoneId;
    detail.orderCategoryType = [OrderMode orderCategoryTypeConvert:model.orderCategory];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)gotoStoneResellPage:(JHPurchaseStoneListModel*)model
{

    [JHRouterManager pushPersonReSellPublishWithSourceOrderId:model.orderId sourceOrderCode:model.orderCode flag:1 editSuccessBlock:^{
        model.resaleStatus = 2;
        model.resaleButtonText = @"转售中";
        [self.purchaseStoneView.pTableView reloadData];
    }];
}

- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}

@end
