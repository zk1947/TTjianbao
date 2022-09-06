//
//  JHLastSaleStoneView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHLastSaleStoneView.h"
#import "JHUIFactory.h"
#import "JHTableViewExt.h"
#import "JHLastSaleGoodsReqModel.h"
#import "JHStonePopViewHeader.h"

#import "JHAnchorBreakPaperViewController.h"
#import "JHSendOrderProccessGoodServiceView.h"
#import "JHPutawayViewController.h"

#import "JHPrinterManager.h"


#define kMLRTabLastSaleStoneIdentifier @"kMLRTabLastSaleStoneIdentifier"

@interface JHLastSaleStoneView () <UITableViewDelegate, UITableViewDataSource, JHTableViewCellDelegate>
{
    JHLastSaleCellType pageType;
    NSString* channelId;
    NSUInteger pageIndex;
}
@property (nonatomic, strong) JHLastSaleGoodsReqModel* reqModel;
@property (nonatomic, strong) NSMutableArray<JHLastSaleGoodsModel*>* dataArray;
@property (nonatomic, strong) UILabel* titleView;
@property (nonatomic, strong) JHTableViewExt* lastSaleTableView;
@property (nonatomic, strong) JHPopForSaleView *popSale;

@end

@implementation JHLastSaleStoneView

- (instancetype)initWithFrame:(CGRect)frame 
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        self.dataArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)drawSubviewsByPagetype:(JHLastSaleCellType)type channelId:(NSString*)mChannelId
{
    pageType = type;
    channelId = mChannelId;
    //优先请求数据
    [self loadNew];
    //页面绘制
    [self setCornerForView];
    
    [self addSubview:self.titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.width, 44));
    }];
    //个人中心需要隐藏title
    if(pageType == JHLastSaleCellTypeFromUserCenter)
    {
        [_titleView setHidden:YES];
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    [self addSubview:self.lastSaleTableView];
    [self.lastSaleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(self.width, self.height-self.titleView.height-10));
    }];
    [self.lastSaleTableView addRefreshView];
    [self.lastSaleTableView addLoadMoreView];
}

- (UILabel*)titleView
{
    if(!_titleView)
    {
        _titleView = [JHUIFactory createLabelWithTitle:@"最近售出原石" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(15) textAlignment:NSTextAlignmentCenter];
        _titleView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _titleView;
}

- (UITableView*)lastSaleTableView
{
    if(!_lastSaleTableView)
    {
        _lastSaleTableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _lastSaleTableView.backgroundColor = [UIColor clearColor];
        _lastSaleTableView.delegate = self;
        _lastSaleTableView.dataSource = self;
        _lastSaleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _lastSaleTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _lastSaleTableView;
}

//无数据界面
- (void)mayShowEmptyPage
{
    [SVProgressHUD dismiss];
    if([_dataArray count] > 0)
    {
        [self hiddenDefaultImage];
        [self hideRefreshMoreWithData:YES];
    }
    else
    {
        [self showDefaultImageWithView:self.lastSaleTableView];
        [self hideRefreshMoreWithData:NO];
    }
}

#pragma mark -
- (void)requestData:(NSUInteger)index
{
    self.reqModel = [[JHLastSaleGoodsReqModel alloc] init];
    if(pageType == JHLastSaleCellTypeFromUserCenter)
    {
        self.reqModel.reqType = JHLastSaleGoodsReqTypeLastSaleFromUserCenter;
    }
    else
    {
        self.reqModel.reqType = JHLastSaleGoodsReqTypeStoneSale;
        _reqModel.channelId = channelId;
    }
    
    _reqModel.pageIndex = index;
    _reqModel.keyword = @"";
    JH_WEAK(self)
    [JH_REQUEST asynPost:_reqModel success:^(id respData) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        NSArray* arr = [JHLastSaleGoodsModel convertData:respData];
        if(pageIndex > 0)
            [self.dataArray addObjectsFromArray:arr];
        else
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        
        [self.lastSaleTableView reloadData];
        
        [self mayShowEmptyPage];
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD dismiss];
        [self mayShowEmptyPage];
    }];
}

#pragma mark - load data
- (void)loadNew
{
    pageIndex = 0;
    [SVProgressHUD show];
    [self requestData:pageIndex];
}

- (void)loadMore
{
    [self requestData:++pageIndex];
}

- (void)hideRefreshMoreWithData:(BOOL)hasData
{
    [_lastSaleTableView hideRefreshView];
    if(hasData)
        [_lastSaleTableView hideLoadMoreView];
    else
        [_lastSaleTableView hideLoadMoreWithNoData];
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    JHLastSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMLRTabLastSaleStoneIdentifier];
    if(!cell)
    {
        cell = [[JHLastSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMLRTabLastSaleStoneIdentifier];
        cell.delegate = self;
        if(pageType == JHLastSaleCellTypeFromUserCenter)
            [cell setupSubviewsByType:JHLastSaleCellTypeFromUserCenter];
        else
            [cell setupSubviewsByType:JHLastSaleCellTypeBuyer];
    }
    
    [cell updateCell:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(pageType == JHLastSaleCellTypeFromUserCenter)
        return 110+kCellMargin;
    
    CGFloat offset = 0.0;
    if(indexPath.row < [self.dataArray count])
    {
        JHLastSaleGoodsModel* model = [self.dataArray objectAtIndex:indexPath.row];
        if(model.sendButton == 0 && model.saleButton == 0 && model.processButton == 0 && model.splitButton == 0 && model.printButton == 0)
        {
            offset = kLastSaleCellButtonHeight;//四个按钮都不显示时,高度缩减
        }
    }

    return 150+kCellMargin-offset;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(pageType == JHLastSaleCellTypeFromUserCenter)
    {
        JHLastSaleGoodsModel* model = [self.dataArray objectAtIndex:indexPath.row];
        [JHRouterManager pushStoneDetailWithStoneId:model.stoneRestoreId ? : model.stoneId complete:nil];
    }
}

#pragma mark - events ~ JHTableViewCellDelegate
- (void)pressButtonType:(RequestType)type dataModel:(JHLastSaleGoodsModel*)model indexPath:(NSIndexPath *)indexPath
{
    switch (type) {
        case RequestTypeResale: {
            JHPopForSaleView *resale = [[JHPopForSaleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            resale.model = model;
            resale.channelCategory = self.channelCategory;
            [resale showAlert];
            [self hiddenAlert];
        }
            break;
        case RequestTypeSendBack: {//channelCategory???
            [JHMainLiveSendBackReqModel request:self.channelCategory stoneId:model.stoneRestoreId?:model.stoneId finish:^(NSString *errorMsg) {
                if(errorMsg)
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                else
                {
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
            vc.channelCategory = self.channelCategory;
            vc.priceTotal = model.purchasePrice;
            [self.viewController.navigationController pushViewController:vc animated:YES];
            [self hiddenAlert];
        }
            break;
            
        case RequestTypePrintGoodCode:
        {
            [JHStoneLivePrintCodeModel requestWithModel:model response:^(NSString *errorMsg) {
                   if(errorMsg)
                       [SVProgressHUD showErrorWithStatus:errorMsg];
                   else
                       [SVProgressHUD showSuccessWithStatus:@"打印成功"];
               }];
        }
            break;
            
        default:
            break;
    }
    
}

@end
