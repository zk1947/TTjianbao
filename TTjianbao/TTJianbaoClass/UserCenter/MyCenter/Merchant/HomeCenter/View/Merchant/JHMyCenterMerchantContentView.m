//
//  JHMyCenterMerchantContentView.m
//  TTjianbao
//
//  Created by lihui on 2021/4/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantContentView.h"
#import "JHMyCenterMerchantViewModel.h"
#import "JHMyCenterUnionSignCell.h"
#import "JHMyCenterMerchantOrderCell.h"
#import "JHMyCenterMerchantCustomizeCell.h"
#import "JHMyCenterStoneReSaleCell.h"
#import "JHMyCenterMerchantShopCell.h"
#import "JHMyCenterMoneyTableCell.h"
#import "JHMyCenterRecycleTableCell.h"
#import "JHMyCenterMerchantServiceCell.h"
#import "JHLivingBlankTableCell.h"
#import "UserInfoRequestManager.h"

@interface JHMyCenterMerchantContentView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation JHMyCenterMerchantContentView

- (CGFloat)contentHeight {
    return self.tableView.contentSize.height;
}

- (instancetype)initWithContentData:(NSArray *)contentData {
    self = [super init];
    if (self) {
        _contentHeight = CGFLOAT_MIN;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"] && _contentHeight != self.tableView.contentSize.height) {
        _contentHeight = self.tableView.contentSize.height;
        if (self.changeHeightBlock) {
            self.changeHeightBlock(_contentHeight);
        }
    }
}

- (void)setContentData:(NSArray *)contentData {
    if (!contentData) {
        return;
    }
    _contentData = contentData;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.contentData.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMyCenterMerchantCellModel *model = SAFE_OBJECTATINDEX(self.contentData, indexPath.row);
    if(model){
        return model.cellHeight;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHMyCenterMerchantCellModel *model = SAFE_OBJECTATINDEX(self.contentData, indexPath.row);
    switch (model.cellType) {
        case JHMyCenterMerchantCellTypeOrder:
        {
            JHMyCenterMerchantOrderCell *cell = [JHMyCenterMerchantOrderCell dequeueReusableCellWithTableView:tableView];
            cell.buttonArray = model.buttonArray;
            cell.type = self.type;
            return cell;
        }
            break;
            
        case JHMyCenterMerchantCellTypeMoney:
        {
            JHMyCenterMoneyTableCell *cell = [JHMyCenterMoneyTableCell dequeueReusableCellWithTableView:tableView];
            cell.money        = self.withDrawMoney;
            cell.lastDayMoney = self.lastDayCompleteMoney;
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
            
        case JHMyCenterMerchantCellTypeRecyle:
        {
            ///回收
            JHMyCenterRecycleTableCell *cell = [JHMyCenterRecycleTableCell dequeueReusableCellWithTableView:tableView];
            BOOL showRecycleSquare = (self.type == JHMyCenterContentTypeStore &&
                                      [UserInfoRequestManager sharedInstance].user.hasOpenRecyle);
            cell.showRecycleSquare = showRecycleSquare;
            cell.buttonArray = model.buttonArray;
            return cell;
        }
            break;

        case JHMyCenterMerchantCellTypeShop:
        {
            JHMyCenterMerchantShopCell *cell = [JHMyCenterMerchantShopCell dequeueReusableCellWithTableView:tableView];
            cell.buttonArray = model.buttonArray;
            cell.title = @"我的工具";
            return cell;
        }
            break;
        case JHMyCenterMerchantCellTypeOpenNewService:
        {
            JHMyCenterMerchantServiceCell *cell = [JHMyCenterMerchantServiceCell dequeueReusableCellWithTableView:tableView];
            return cell;
        }
            break;
        case JHMyCenterMerchantCellTypeLivingBlank:
        {
            JHLivingBlankTableCell *cell = [JHLivingBlankTableCell dequeueReusableCellWithTableView:tableView];
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

-(UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentSize"];
}
@end
