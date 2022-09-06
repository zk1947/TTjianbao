//
//  JHGoodManagerListChannelViewController.m
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListChannelViewController.h"
#import "JHGoodManagerFilterMoneyTableViewCell.h"
#import "JHGoodManagerFilterTimeTableViewCell.h"
#import "JHGoodManagerFilterCagetoryTableViewCell.h"
#import "JHGdoodManagerFilterHeaderView.h"
#import "JHGoodManagerListChannelBottomView.h"
#import "objc/message.h"
#import "objc/runtime.h"

#import "JHGoodManagerFilterBusiness.h"
#import "JHGoodManagerFilterModel.h"
#import "JHGoodManagerSingleton.h"
#import "IQKeyboardManager.h"

#import "BaseNavViewController.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SLIP_ORIGIN_FRAME CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - _sideSlipLeading, SCREEN_HEIGHT)
#define SLIP_DISTINATION_FRAME CGRectMake(_sideSlipLeading, 0, SCREEN_WIDTH - _sideSlipLeading, SCREEN_HEIGHT)

//class
NSString * const FILTER_NAVIGATION_CONTROLLER_CLASS = @"BaseNavViewController";
const CGFloat ANIMATION_DURATION_DEFAULT = 0.3f;
const CGFloat SIDE_SLIP_LEADING_DEFAULT = 60;

id (*objc_msgSendGetCellIdentifier)(id self, SEL _cmd) = (void *)objc_msgSend;
CGFloat (*objc_msgSendGetCellHeight)(id self, SEL _cmd) = (void *)objc_msgSend;
id (*objc_msgSendCreateCellWithIndexPath)(id self, SEL _cmd, NSIndexPath *) = (void *)objc_msgSend;

@interface JHGoodManagerListChannelViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,   weak) UIViewController                      *sponsor;
@property (nonatomic,   weak) BaseNavViewController                *filterNavigation;
@property (nonatomic, strong) UIView                                *backCover;
@property (nonatomic,   copy) SideSlipFilterCommitBlock              commitBlock;
@property (nonatomic,   copy) SideSlipFilterResetBlock               resetBlock;
@property (nonatomic, strong) UITableView                           *filterTableView;
@property (nonatomic, strong) JHGoodManagerListChannelBottomView    *bottomView;
@property (nonatomic, strong) NSMutableArray                        *dataSourceArray;
@property (nonatomic, strong) NSMutableArray                        *cellArray;
@property (nonatomic, strong) JHGoodManagerFilterMoneyTableViewCell *moneyCell;
@property (nonatomic, strong) JHGoodManagerFilterTimeTableViewCell  *timeCell;
@end

@implementation JHGoodManagerListChannelViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithSponsor:(UIViewController *)sponsor
                    resetBlock:(SideSlipFilterResetBlock)resetBlock
                    commitBlock:(SideSlipFilterCommitBlock)commitBlock {
    self = [super init];
    if (self) {
//        NSAssert(sponsor.navigationController, @"ERROR: sponsor must have the navigationController");
        _sponsor = sponsor;
        _resetBlock = resetBlock;
        _commitBlock = commitBlock;
        BaseNavViewController *filterNavigation = [[NSClassFromString(FILTER_NAVIGATION_CONTROLLER_CLASS) alloc] initWithRootViewController:self];
//        filterNavigation.view.userInteractionEnabled = NO;
        [filterNavigation setNavigationBarHidden:YES];
        filterNavigation.navigationBar.translucent = NO;
        [filterNavigation.view setFrame:SLIP_ORIGIN_FRAME];
        self.filterNavigation = filterNavigation;
        self.filterNavigation.isForbidDragBack = YES;
    
        [self configureStatic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)configureStatic {
    self.animationDuration = ANIMATION_DURATION_DEFAULT;
    self.sideSlipLeading = SIDE_SLIP_LEADING_DEFAULT;
}

- (void)configureUI {
    self.bottomView = [[JHGoodManagerListChannelBottomView alloc] init];
    self.bottomView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight +59.f);
    }];
    @weakify(self);
    [self.bottomView goodManagerListChannelBottomAction:^(JHGoodManagerListChannelBottomBtnStyle style) {
        @strongify(self);
        if (style == JHGoodManagerListChannelBottomBtnStyle_reset) {
            /// 重置
            [self channelFilterResetAllStatus];
        } else {
            /// 确认
            [self channelFilterConfirm];
        }
    }];
    
    [self.view addSubview:self.filterTableView];
    [self.filterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44.f);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)show {
    [_sponsor.navigationController.view addSubview:self.backCover];
    [_sponsor.navigationController addChildViewController:self.navigationController];
    [_sponsor.navigationController.view addSubview:self.navigationController.view];
    
    [_backCover setHidden:YES];
    [UIView animateWithDuration:_animationDuration animations:^{
        [self.navigationController.view setFrame:SLIP_DISTINATION_FRAME];
    } completion:^(BOOL finished) {
        [_backCover setHidden:NO];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:_animationDuration animations:^{
        [self.navigationController.view setFrame:SLIP_ORIGIN_FRAME];
    } completion:^(BOOL finished) {
        [_backCover removeFromSuperview];
        [self.navigationController.view removeFromSuperview];
        [self.navigationController removeFromParentViewController];
    }];
}

- (void)clickBackCover:(id)sender {
    [self dismiss];
}

- (void)reloadData {
    [self.dataSourceArray removeAllObjects];
    [self.cellArray removeAllObjects];
    [JHGoodManagerFilterBusiness getChannelFilterSuccessBlock:^(RequestModel * _Nullable respondObject) {
        [self.dataSourceArray removeAllObjects];
        NSArray *arr = [JHGoodManagerFilterModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        JHGoodManagerFilterModel *model = [[JHGoodManagerFilterModel alloc] init];
        model.cateName = @"全部";
        [self.dataSourceArray addObject:model];

        [self.dataSourceArray addObjectsFromArray:arr];
        [self.filterTableView reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.dataSourceArray removeAllObjects];
    }];
}

- (void)channelFilterResetAllStatus {
    [self resetAllRequestModel];
    /// 价格区间重置
    [self.moneyCell resetAllStatus];
    
    /// 发布时间重置
    [self.timeCell resetAllStatus];
    
    /// 分类重置
    for (JHGoodManagerFilterCagetoryTableViewCell *cell in self.cellArray) {
        [cell setTitleLabelBackgroundColorSelect:NO];
        [cell resetAllTitleLabelStatus];
    }
}

- (void)channelFilterConfirm {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST" object:nil];
    [self dismiss];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellArray;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JHGdoodManagerFilterHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JHGdoodManagerFilterHeaderView class])];
    if (!headerView) {
        headerView = [[JHGdoodManagerFilterHeaderView alloc] initWithReuseIdentifier:NSStringFromClass([JHGdoodManagerFilterHeaderView class])];
    }
    if (section == 0) {
        [headerView setViewModel:@"价格区间（元）"];
    } else if (section == 1) {
        [headerView setViewModel:@"发布时间"];
    } else {
        [headerView setViewModel:@"分类"];
    }
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSourceArray.count >0) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray.count >0) {
        if (section < 2) {
            return 1;
        }
        return self.dataSourceArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.moneyCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerFilterMoneyTableViewCell class])];
        if (!self.moneyCell) {
            self.moneyCell = [[JHGoodManagerFilterMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerFilterMoneyTableViewCell class])];
        }
        return self.moneyCell;
    } else if (indexPath.section == 1) {
        self.timeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerFilterTimeTableViewCell class])];
        if (!self.timeCell) {
            self.timeCell = [[JHGoodManagerFilterTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerFilterTimeTableViewCell class])];
        }
        @weakify(self);
        self.timeCell.timePickerDidClickedBlock = ^{
            @strongify(self);
            [self.moneyCell keyboardDismiss];
        };
        return self.timeCell;
    } else {
        NSString *str = [NSString stringWithFormat:@"%@_%ld",NSStringFromClass([JHGoodManagerFilterCagetoryTableViewCell class]),(long)indexPath.row];
        JHGoodManagerFilterCagetoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHGoodManagerFilterCagetoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [self.cellArray addObject:cell];
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        cell.didSelectBlock = ^{
            for (JHGoodManagerFilterCagetoryTableViewCell *cell in self.cellArray) {
                /// 先重置状态
                [self resetCagetoryRequestModel];
                [cell setTitleLabelBackgroundColorSelect:NO];
                [cell resetAllTitleLabelStatus];
            }
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >1) {
        for (JHGoodManagerFilterCagetoryTableViewCell *cell in self.cellArray) {
            /// 先重置状态
            [self resetCagetoryRequestModel];
            [cell setTitleLabelBackgroundColorSelect:NO];
            [cell resetAllTitleLabelStatus];

            JHGoodManagerFilterCagetoryTableViewCell *cellSel = [tableView cellForRowAtIndexPath:indexPath];
            
            JHGoodManagerFilterModel *model = self.dataSourceArray[indexPath.row];
            if (!isEmpty(model.cateId)) {
                [JHGoodManagerSingleton shared].firstCategoryId  = model.cateId;
            }
            if (cell == cellSel) {
                [cellSel setTitleLabelBackgroundColorSelect:YES];
            } else {
                [cell setTitleLabelBackgroundColorSelect:NO];
            }
        }
    }
}


/// 重置分类
- (void)resetCagetoryRequestModel {
    [JHGoodManagerSingleton shared].firstCategoryId  = @"";
    [JHGoodManagerSingleton shared].secondCategoryId = @"";
    [JHGoodManagerSingleton shared].thirdCategoryId  = @"";
}


/// 重置所有
- (void)resetAllRequestModel {
    [self resetCagetoryRequestModel];
    [JHGoodManagerSingleton shared].minPrice         = @"";
    [JHGoodManagerSingleton shared].maxPrice         = @"";
    [JHGoodManagerSingleton shared].publishStartTime = @"";
    [JHGoodManagerSingleton shared].publishEndTime   = @"";
}

#pragma mark -
- (UITableView *)filterTableView {
    if (!_filterTableView) {
        _filterTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _filterTableView.dataSource                     = self;
        _filterTableView.delegate                       = self;
        _filterTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _filterTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _filterTableView.estimatedRowHeight             = 10.f;
        
        _filterTableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _filterTableView.estimatedSectionHeaderHeight   = 0.1f;
            _filterTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_filterTableView registerClass:[JHGoodManagerFilterMoneyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerFilterMoneyTableViewCell class])];
        
        [_filterTableView registerClass:[JHGoodManagerFilterTimeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerFilterTimeTableViewCell class])];
                
        if ([_filterTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_filterTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_filterTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_filterTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _filterTableView;
}

- (UIView *)backCover {
    if (!_backCover) {
        _backCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backCover setBackgroundColor:HEXCOLORA(0x000000, 0.4f)];
        [_backCover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackCover:)]];
    }
    return _backCover;
}

- (BaseNavViewController *)filterNavigation {
    return objc_getAssociatedObject(_sponsor, _cmd);
}

- (void)setFilterNavigation:(BaseNavViewController *)filterNavigation {
    //让sponsor持有filterNavigation
    objc_setAssociatedObject(_sponsor, @selector(filterNavigation), filterNavigation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
