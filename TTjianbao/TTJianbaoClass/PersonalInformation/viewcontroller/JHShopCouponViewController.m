//
//  JHShopCouponViewController.m
//  TTjianbao
//
//  Created by mac on 2019/7/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHShopCouponViewController.h"
#import "JHSaleCouponViewController.h"
#import "ShopCouponDetailViewController.h"
#import "JHVoucherCreateController.h"

@interface JHShopCouponViewController ()

@property (nonatomic, strong) NSNumber *validCount; //已生效
@property (nonatomic, strong) NSNumber *invalidCount; //已失效
@property (nonatomic, strong) NSNumber *grantCount; //已发放

//为了缓存列表
@property (nonatomic, strong) NSArray<NSString *> *mainTitles;
@property (nonatomic, strong) NSMutableDictionary <NSString *, JHSaleCouponViewController *> *listCache;;

@end

@implementation JHShopCouponViewController

- (void)backActionButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    JHVoucherCreateController *vc = [JHVoucherCreateController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _validCount = @(0);
    _invalidCount = @(0);
    _grantCount = @(0);
    _mainTitles = @[];
    _listCache = [NSMutableDictionary dictionary];
    
    [self configNaviBar];
    [self setupTitleCategoryView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self sendRequest];
}

- (void)configNaviBar {
//    [self  initToolsBar];
//    [self.navbar setTitle:@"代金券管理"];
    [self showNavView];
    self.title = @"代金券管理";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backActionButton) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navbar addrightBtn:@"添加" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-44, 0, 44, 44)];
//    self.navbar.rightBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0];
//    [self.navbar.rightBtn setTitleColor:kColor222 forState:UIControlStateNormal];
//    [self.navbar.rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self initRightButtonWithName:@"添加" action:@selector(rightBtnClicked)];
    [self.jhRightButton setTitleColor:kColor222 forState:UIControlStateNormal];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
}

- (void)sendRequest {
    NSString *url = FILE_BASE_STRING(@"/voucher/seller/count/auth");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject)
    {
        self.validCount = respondObject.data[@"executedCount"];
        self.invalidCount = respondObject.data[@"invalidCount"];
        self.grantCount = respondObject.data[@"grantCount"];
        [self refreshTitle];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)refreshTitle {
    NSString *title1 = [NSString stringWithFormat:@"已生效(%zd)", [_validCount integerValue]];
    NSString *title2 = [NSString stringWithFormat:@"已失效(%zd)", [_invalidCount integerValue]];
    NSString *title3 = [NSString stringWithFormat:@"已发放(%zd)", [_grantCount integerValue]];
    
    self.titles = @[title1, title2, title3];
    self.titleCategoryView.titles = self.titles;
    [self.titleCategoryView reloadData];
}

#pragma mark -
#pragma mark - JXCategoryView Methods

- (void)setupTitleCategoryView {
    self.titles = @[@"已生效(0)", @"已失效(0)", @"已发放(0)"];
    self.mainTitles = self.titles.mutableCopy; //为了缓存列表
    self.titleCategoryView.titles = self.titles;

    self.titleCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:13];
    self.titleCategoryView.titleColor = kColor666;
    self.titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:13];
    self.titleCategoryView.titleSelectedColor = kColor333;
    self.titleCategoryView.titleColorGradientEnabled = YES; //颜色渐变
    self.titleCategoryView.averageCellSpacingEnabled = YES; //将cell均分
    
    JXCategoryIndicatorLineView *indicatorView = self.indicatorView;
    indicatorView.indicatorWidth = 40;
    indicatorView.indicatorHeight = 3;
    indicatorView.verticalMargin = 5;
    self.titleCategoryView.indicators = @[indicatorView];
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index
{
    NSString *curTitle = self.mainTitles[index];
    //id<JXCategoryListContentViewDelegate> list = _listCache[curTitle];
    JHSaleCouponViewController *list = _listCache[curTitle];
    
    if (list) { //存在缓存的list
        [list refresh];
        return list;
        
    } else {
        JHSaleCouponViewController *listVC = [[JHSaleCouponViewController alloc] init];
        _listCache[curTitle] = listVC; //缓存已经初始化的列表
        //0失效，1.生效， 2发放
        listVC.state = (index == 0 ? 1 : (index == 1 ? 0 : 2));
        
        JH_WEAK(self)
        listVC.createBlock = ^(id sender) {
            JH_STRONG(self)
            [self rightBtnClicked];
        };

        listVC.countChangedBlock = ^(JHSaleCouponViewController *object, NSNumber *sender) {
            JH_STRONG(self)
            [self sendRequest];
        };
        
        return listVC;
    }
}

@end
