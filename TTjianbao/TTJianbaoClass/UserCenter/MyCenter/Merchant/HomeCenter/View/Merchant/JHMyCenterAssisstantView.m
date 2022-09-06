//
//  JHMyCenterAssisstantView.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterAssisstantView.h"
#import "JHMyCenterMerchantInfoView.h"
#import "JHMyCenterMerchantViewModel.h"
#import "JHMyCenterUnionSignCell.h"
#import "JHMyCenterMerchantOrderCell.h"
#import "JHMyCenterMerchantCustomizeCell.h"
#import "JHMyCenterStoneReSaleCell.h"
#import "JHMyCenterMerchantShopCell.h"

@interface JHMyCenterAssisstantView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JHMyCenterMerchantInfoView *headerView;

@property (nonatomic, strong) JHMyCenterMerchantViewModel *viewModel;

@end

@implementation JHMyCenterAssisstantView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_BACKGROUND_COLOR;
        [self tableView];
    }
    return self;
}

-(void)reload{
    [self.headerView reload];
    [self.viewModel.dataArray removeAllObjects];
    [self.viewModel reloadAssistantArray];
    [self.viewModel.requestCommand execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.viewModel.dataArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMyCenterMerchantCellModel *model = SAFE_OBJECTATINDEX(self.viewModel.dataArray, indexPath.row);
    if(model){
        return model.cellHeight;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMyCenterMerchantCellModel *model = SAFE_OBJECTATINDEX(self.viewModel.dataArray, indexPath.row);
    
    switch (model.cellType) {
        case JHMyCenterMerchantCellTypeUnionSign:
        {
            JHMyCenterUnionSignCell *cell = [JHMyCenterUnionSignCell dequeueReusableCellWithTableView:tableView];
            return cell;
        }
            break;
            
        case JHMyCenterMerchantCellTypeOrder:
        {
            JHMyCenterMerchantOrderCell *cell = [JHMyCenterMerchantOrderCell dequeueReusableCellWithTableView:tableView];
            cell.buttonArray = model.buttonArray;
            return cell;
        }
            break;
            
        case JHMyCenterMerchantCellTypeCustomize:
        {
            JHMyCenterMerchantCustomizeCell *cell = [JHMyCenterMerchantCustomizeCell dequeueReusableCellWithTableView:tableView];
            cell.buttonArray = model.buttonArray;
            return cell;
        }
            break;
            
        case JHMyCenterMerchantCellTypeResale:
        {
            JHMyCenterStoneReSaleCell *cell = [JHMyCenterStoneReSaleCell dequeueReusableCellWithTableView:tableView];
            cell.buttonArray = model.buttonArray;
            return cell;
        }
            break;
            
        case JHMyCenterMerchantCellTypeShop:
        {
            JHMyCenterMerchantShopCell *cell = [JHMyCenterMerchantShopCell dequeueReusableCellWithTableView:tableView];
            cell.buttonArray = model.buttonArray;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self];
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.headerView;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.backgroundColor = APP_BACKGROUND_COLOR;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _tableView;
}

- (JHMyCenterMerchantInfoView *)headerView{
    if(!_headerView){
#ifdef JH_UNION_PAY
        _headerView = [[JHMyCenterMerchantInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 296 + UI.statusAndNavBarHeight)];
#else
        _headerView = [[JHMyCenterMerchantInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 392 + UI.statusAndNavBarHeight)];
#endif
    }
    return _headerView;
}

-(JHMyCenterMerchantViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [JHMyCenterMerchantViewModel new];
        [_viewModel reloadAssistantArray];
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self setHeaderViewData];
            [self.tableView reloadData];
        }];
    }
    return _viewModel;
}

-(void)setHeaderViewData
{
    double price = [[NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.totalMoney] doubleValue];
    
    self.headerView.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",price];
    
    self.headerView.incomeFreezeLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.account.incomeFreezeAccount];
    
#ifdef JH_UNION_PAY
    self.headerView.withdrawLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.account.alreadyIncomeAccount];
#else
    self.headerView.withdrawLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.account.withdrawAccount];
#endif
   
    self.headerView.oldIncomeFreezeLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.oldAccount.incomeFreezeAccount];
    
    self.headerView.oldWithdrawLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.oldAccount.withdrawAccount];
    
    self.headerView.dateNewTipLabel.text = [NSString stringWithFormat:@"%@及以后的数据",self.viewModel.dataSource.accountDate];
    
    self.headerView.oldDateTipLabel.text = [NSString stringWithFormat:@"%@以前的数据",self.viewModel.dataSource.accountDate];
}
#pragma mark --------------- scrollview ---------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scrollBlock) {
        self.scrollBlock(offsetY);
    }
}

@end
