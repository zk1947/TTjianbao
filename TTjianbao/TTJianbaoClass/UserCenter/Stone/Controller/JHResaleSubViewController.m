//
//  JHResaleSubViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHResaleSubViewController.h"
#import "JHBuyPriceTableViewCell.h"
#import "JHUCOnSaleTableViewCell.h"
#import "JHSoldTableViewCell.h"
#import "JHBuyerPriceListModel.h"
#import "JHMyResaleListModel.h"
#import "JHGoodResaleListModel.h"
#import "JHEditPriceViewController.h"

#import "NSString+Common.h"


#define kBuyPriceCellIdentifier  @"BuyPriceCellIdentifier"
#define kOnSaleCellIdentifier    @"OnSaleCellIdentifier"
#define kSoldCellIdentifier        @"SoldCellIdentifier"

@interface JHResaleSubViewController () <JHUserCenterResaleDataDelegate, JHTableViewCellDelegate>
{
    JHResaleSubPageType pageType;
    JHScrollDirectType scrollDirect;//scrollDid处理后,与mj有点冲突,用方向区分一下
    NSUInteger pageIndex;
    NSString* channelId;
    UILabel* tipsView;
}

@property (nonatomic, strong) NSMutableArray* dataArr;
@property (nonatomic, strong) JHUserCenterResaleDataModel* dataModel;

@end

@implementation JHResaleSubViewController
@synthesize dataArr;

- (instancetype)initWithPageType:(JHResaleSubPageType)type channelId:(NSString*)mChannelId
{
    if(self = [super init])
    {
        pageType = type;
        channelId = mChannelId;
        self.dataArr = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //优先请求data
    [self requestData];
    //页面绘制
    self.view.backgroundColor = HEXCOLOR(0xf8f8f8);
    [self.view addSubview:self.jhTableView];
    [self.jhTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //tips
    [self drawTipsView];
    //加载更多
    [self addLoadMoreView];
}

- (void)drawTipsView
{
    if(!tipsView)
    {
        tipsView = [JHUIFactory createLabelWithTitle:@"在售N件原石  预计回血：￥0.00" titleColor:HEXCOLOR(0xFC4200) font:JHFont(12) textAlignment:NSTextAlignmentCenter];
        tipsView.backgroundColor = HEXCOLOR(0xFFEDE7);
        tipsView.frame = CGRectMake(10, 0, self.view.width - 10 * 2, 32);
        tipsView.layer.cornerRadius = 8;
        tipsView.layer.masksToBounds = YES;
        //set tableview header
        self.jhTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, tipsView.height+11)];
        self.jhTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        [self.jhTableView.tableHeaderView addSubview:tipsView];
    }
}

- (void)refreshTipsView
{
   //0件原石,就隐藏了
    if(![NSString isEmpty:self.dataModel.total] && [self.dataModel.total intValue] > 0 && ![NSString isEmpty:self.dataModel.totalPrice] && self.dataModel.totalPrice)
    {
        [tipsView setHidden:NO];
        tipsView.text = [NSString stringWithFormat:@"在售%@件原石  预计回血：￥%@", self.dataModel.total, self.dataModel.totalPrice];
        self.jhTableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.width, tipsView.height+11);
    }
    else
    {
        //隐藏tipsView
        [tipsView setHidden:YES];
        self.jhTableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.width, 0);
    }
}

//无数据界面
- (void)mayShowEmptyPage
{
    if([dataArr count] > 0)
    {
        [self hiddenDefaultImage];
        //关掉加载更多view
        [self hideLoadMoreView];
    }
    else
    {
        [self showDefaultImageWithView:self.jhTableView];
        [self hideLoadMoreWithNoData];
    }
}

#pragma mark - request
- (JHUserCenterResaleDataModel*)dataModel
{
    if(!_dataModel)
    {
        _dataModel = [JHUserCenterResaleDataModel new];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

- (void)requestData
{
    [SVProgressHUD show];
    pageIndex = 0;
    [self.dataModel requestByPage:pageType channelId:channelId pageIndex:pageIndex];
}

- (void)loadMore
{
    if(scrollDirect == JHScrollDirectTypeUp)//上拉才是加载更多
        [self.dataModel requestByPage:pageType channelId:channelId pageIndex:++pageIndex];
    else
        [self hideLoadMoreView];//关掉加载更多view
}

//JHResaleLiveRoomTabDataDelegate
- (void)responseData:(NSMutableArray*)dataArray error:(NSString*)errorMsg
{
    [SVProgressHUD dismiss];
    if(errorMsg)
    {
        //
    }
    else
    {
        if(pageIndex > 0)
            [self.dataArr addObjectsFromArray:dataArray];
        else
            self.dataArr = [NSMutableArray arrayWithArray:dataArray];
        [self.jhTableView reloadData];
        //刷新table上面的tips view
        [self refreshTipsView];
    }
    [self mayShowEmptyPage];
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (pageType)
    {
        case JHResaleSubPageTypeBuyPrice:
        default:
            {
                JHBuyPriceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kBuyPriceCellIdentifier];
                if(!cell)
                {
                    cell = [[JHBuyPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBuyPriceCellIdentifier];
                    [cell setCellThemeType:JHCellThemeTypeDefault];
                    cell.delegate = self;
                }
                [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
            
        case JHResaleSubPageTypeOnSale:
            {
                JHUCOnSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kOnSaleCellIdentifier];
                if(!cell)
                {
                    cell = [[JHUCOnSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOnSaleCellIdentifier];
                    cell.delegate = self;
                }
                
                [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
        
        case JHResaleSubPageTypeSold:
            {
                JHSoldTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSoldCellIdentifier];
                if(!cell)
                {
                    cell = [[JHSoldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSoldCellIdentifier];
                    cell.delegate = self;
                }
                
                [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(pageType == JHResaleSubPageTypeSold)
        return kSoldTableCellHeight;
    else if(pageType == JHResaleSubPageTypeOnSale)
        return kUCOnSaleTableCellHeight;
    else
    {
        //根据出价用户个数增加高度，每个用户出价高度为(40+10)
        JHBuyerPriceModel* model = dataArr[indexPath.row];
        NSUInteger n = model.customerOfferList.count > 0 ? (model.customerOfferList.count - 1) : 0;
        return kBuyPriceTableCellHeight + n * kBuyerPriceViewHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* stoneId = @"";
    if(JHResaleSubPageTypeBuyPrice == pageType)
    {
        JHBuyerPriceModel* model = [dataArr objectAtIndex:indexPath.row];
        stoneId = model.stoneRestoreId;
        if(model.resaleFlag)
        {
            [JHRouterManager pushPersonReSellDetailWithStoneResaleId:stoneId];
            return;
        }
    }
    else if(JHResaleSubPageTypeOnSale == pageType)
    {
        JHUCOnSaleListModel* model = [dataArr objectAtIndex:indexPath.row];
        stoneId = model.stoneRestoreId ? : model.stoneId;
    }
    else if(JHResaleSubPageTypeSold == pageType)
    {
        JHUCSoldListModel* model = [dataArr objectAtIndex:indexPath.row];
        stoneId = model.stoneId;
    }
    [JHRouterManager pushStoneDetailWithStoneId:stoneId complete:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    scrollDirect = self.scrollDirectType;
}

- (void)callbackRefreshData
{
    [self requestData];//重新请求数据
}

#pragma mark - JHTableViewCellDelegate
- (void)pressButtonType:(RequestType)type dataModel:(id)model indexPath:(NSIndexPath *)indexPath
{
    if(RequestTypeCellCancelResale == type)
    {
        __weak JHUCOnSaleListModel* m = model;
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"取消寄售后将无法再次寄售，是否确认取消寄售？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [JHCancelResaleReqModel requestCancelWithStoneId:m.stoneId channelId:@"" channelCategory:@"restoreStone" fail:^(NSString *errorMsg) {
                if(errorMsg)
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                else
                    [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            }];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else if(RequestTypeAgreePrice == type)
    {
        __weak JHBuyerPriceDetailModel* m = model;//这个model不是cellModel
    
        NSString* tipText = [NSString stringWithFormat: @"是否确认接受此出价 ¥%@？", m.offerPrice ? : @"0.0"];

        if([m.offerPrice integerValue] < [m.salePrice integerValue])
            tipText = @"此价格低于一口价！是否接受按此价格成交？";
        
        JH_WEAK(self)
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:tipText message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JH_STRONG(self)
            
            JHGoodOrderSaveReqModel *reqm = [JHGoodOrderSaveReqModel new];
            reqm.stoneRestoreOfferId = m.stoneRestoreOfferId;
            reqm.channelCategory = JHRoomTypeNameRestoreStone;
            reqm.stoneId = m.stoneRestoreId;
            reqm.orderCategory = @"restoreOrder";
            reqm.orderPrice = m.offerPrice;
            //个人(原石)转售
            if(m.resaleFlag == 1)
            {
                //resaleOrder-个人转售订单, resaleIntentionOrder-个人转售意向金订单
                reqm.orderCategory = @"resaleOrder";
                reqm.channelCategory = @"";
            }
            else
            {
                reqm.orderCategory = @"restoreOrder";
                reqm.channelCategory = JHRoomTypeNameRestoreStone;
            }
            [JHMainLiveSmartModel request:reqm response:^(id respData, NSString *errorMsg) {
                
               if(errorMsg)
                   [SVProgressHUD showErrorWithStatus:errorMsg];
               else
               {
                   [SVProgressHUD showSuccessWithStatus:@"接受成功"];
                   [self callbackRefreshData];
               }
            }];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else if(RequestTypeRejectPrice == type)
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
                    [self callbackRefreshData];
                }
            }];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else if(RequestTypeEnterLive == type)
    {
        JHUCOnSaleListModel* m = model;
        if(![NSString isEmpty:m.channelId])
            [JHRootController EnterLiveRoom:m.channelId fromString:@""];
        else
            DDLogInfo(@"RequestTypeEnterLive->channelId is nil");
    }
    else if(RequestTypeEdit == type)
    {
        JHUCOnSaleListModel* m = model;
        JHEditPriceViewController *vc = [[JHEditPriceViewController alloc] init];
        vc.stoneId = m.stoneRestoreId?:m.stoneId;
        vc.price = m.salePrice;
        JH_WEAK(self)
        vc.baseFinishBlock = ^(id sender) {
            JH_STRONG(self)
            [self callbackRefreshData];
        };
        [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}

@end
