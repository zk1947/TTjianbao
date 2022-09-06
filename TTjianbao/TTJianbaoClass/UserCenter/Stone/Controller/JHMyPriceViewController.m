//
//  JHMyPriceViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyPriceViewController.h"
#import "JHMyPriceTableViewCell.h"
#import "JHMyPriceListModel.h"
#import "JHOfferPriceViewController.h"
#import "JHOrderConfirmViewController.h"
#import "CommonTool.h"
#import "JHTableViewExt.h"

#import "BYTimer.h"
#import "JHOrderPayViewController.h"

#import "TTjianbaoBussiness.h"
#define kMyPriceCellIdentifier  @"MyPriceCellIdentifier"

@interface JHMyPriceViewController ()<UITableViewDelegate, UITableViewDataSource, JHTableViewCellDelegate>
{
    NSMutableArray* dataArr;
    NSUInteger pageIndex;
    BYTimer *timer;
}
@property (nonatomic, strong) JHTableViewExt* tableView;

@end

@implementation JHMyPriceViewController

- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init
{
    if(self = [super init])
    {
        [self loadNew];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
//    [self setupToolBarWithTitle:@"我的出价"];
    self.title = @"我的出价";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight+11); //与nav11像素间隔
        make.height.mas_equalTo(self.view.height-UI.statusAndNavBarHeight);
    }];
    [self.tableView addRefreshView];
    [self.tableView addLoadMoreView];
    [self updateCellTimeStatus];//timer
}

#pragma mark - subviews
- (UITableView*)tableView
{
    if(!_tableView)
    {
        _tableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];//HEXCOLOR(0xf8f8f8);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _tableView;
}

//无数据界面
- (void)mayShowEmptyPage
{
    if([dataArr count] > 0)
    {
        [self hiddenDefaultImage];
        [self hideRefreshMoreWithData:YES];
    }
    else
    {
        [self showDefaultImageWithView:self.tableView];
        [self hideRefreshMoreWithData:NO];
    }
}

-(void)updateCellTimeStatus
{
    if (!timer)
    {
        timer=[[BYTimer alloc]init];
    }
    JH_WEAK(self)
    [timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        [self updateTime];
    }];
    
}

-(void)updateTime
{
    NSArray* cellArr = [self.tableView visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMyPriceTableViewCell class]])
        {
            JHMyPriceTableViewCell *cell=(JHMyPriceTableViewCell *)obj;
            JHMyPriceListModel* model = cell.cellModel;
            if ([CommHelp dateRemaining:model.offerDetail.expireTime] > 0)
            {
                cell.retainTimeText = [CommHelp getHMSWithSecond:[CommHelp dateRemaining:model.offerDetail.expireTime]];
            }
            else
            {
                cell.retainTimeText = @"0:0:0";
            }
        }
    }
}

#pragma mark - request
- (void)request
{
    JHMyPriceListReqModel* model = [JHMyPriceListReqModel new];
    model.channelId = @"";
    model.pageIndex = pageIndex;
    JH_WEAK(self)
    [JH_REQUEST asynPost:model success:^(id respData) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        NSArray* arr = [JHMyPriceListModel convertData:respData];
        if(pageIndex > 0)
            [dataArr addObjectsFromArray:arr];
        else
            dataArr = [NSMutableArray arrayWithArray:arr];
        [self.tableView reloadData];
        
        [self mayShowEmptyPage];
    } failure:^(NSString *errorMsg) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        [self mayShowEmptyPage];
    }];
}

- (void)loadNew
{
    [SVProgressHUD show];
    pageIndex = 0;
    [self request];
}

- (void)loadMore
{
    pageIndex++;
    [self request];
}

- (void)hideRefreshMoreWithData:(BOOL)hasData
{
    [self.tableView hideRefreshView];
    if(hasData)
        [self.tableView hideLoadMoreView];
    else
        [self.tableView hideLoadMoreWithNoData];
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    JHMyPriceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMyPriceCellIdentifier];
    if(!cell)
    {
        cell = [[JHMyPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyPriceCellIdentifier];
        [cell setCellThemeType:JHCellThemeTypeDefault];
        cell.delegate = self;
    }
    
    [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offset = kMyPriceTableCellRetainTimeHeight;
    if(indexPath.row < [dataArr count])
    {
        JHMyPriceListModel* model = dataArr[indexPath.row];
        if(model.offerDetail.offerState == 2)
            offset = 0.0;
    }

    return kMyPriceTableCellHeight - offset;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMyPriceListModel* model = [dataArr objectAtIndex:indexPath.row];
    if(model.resaleFlag)
    {
        [JHRouterManager pushPersonReSellDetailWithStoneResaleId:model.stoneRestoreId];
    }
    else
    {
        [JHRouterManager pushStoneDetailWithStoneId:model.stoneRestoreId complete:nil];
    }
}

- (void)pressButtonType:(RequestType)type dataModel:(JHMyPriceListModel*_Nullable)model indexPath:(NSIndexPath *_Nullable)indexPath
{
    switch (type)
    {
        case RequestTypeRePutPrice:
            {
                JHOfferPriceViewController *vc = [[JHOfferPriceViewController alloc] init];
                vc.stoneRestoreId = model.stoneRestoreId;
                vc.resaleFlag = model.resaleFlag;
                [self.navigationController pushViewController:vc animated:YES];
            }
             break;
        
        case RequestTypeWillPrice:
            {//不需要区分个人转售，传订单号自动区分开
                if (model.offerDetail.toPay) {
                    JHOrderPayViewController * order = [[JHOrderPayViewController alloc]init];
                    order.orderId = model.orderId;
                    [self.navigationController pushViewController:order animated:YES];
                } else {
                    JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
                    order.orderId = model.orderId;
                    order.fromString=JHConfirmFromMyOffer;
                    [self.navigationController pushViewController:order animated:YES];
                }
                
            }
            break;
        
        case RequestTypeCancelPrice:
            {
                [JHMyCancelPriceReqModel requestWithStoneModel:model finish:^(NSString *errorMsg) {
                    if(errorMsg)
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    else
                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                }];
            }
            break;
        default:
            break;
    }
}


@end
