//
//  JHCustomizeChooseListViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseListViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHCustomizeChooseCagetoryBackView.h"

#import "JHCustomizeOrderModel.h"
#import "JXCategoryIndicatorLineView.h"
#import "JHCustomizeChooseViewController.h"

#import "JHCustomizeOrderSubListViewController.h"
#import "JHCustomizeChooseBusiness.h"
#import "JHGrowingIO.h"
#import "UIScrollView+JHEmpty.h"


@interface JHCustomizeChooseListViewController ()<
JXCategoryListContainerViewDelegate,
JXCategoryViewDelegate>
//@property (nonatomic, strong) JXCategoryTitleView                                     *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView                             *listContainerView;
@property (nonatomic, strong) NSMutableArray<JHCustomizeChooseTemplatesModel *>       *cateArr;
@property (nonatomic, strong) NSMutableArray<JHCustomizeChooseViewController *>       *vcArr;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JHCustomizeChooseCagetoryBackView                       *categoryView;

@end

@implementation JHCustomizeChooseListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentIndex = 0;
    }
    return self;
}

- (NSMutableArray<JHCustomizeChooseTemplatesModel *> *)cateArr {
    if (!_cateArr) {
        _cateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cateArr;
}

- (NSMutableArray<JHCustomizeChooseViewController *> *)vcArr {
    if (!_vcArr) {
        _vcArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _vcArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.title = @"选择定制师";
    [self.jhRightButton setHidden:YES];
    [self initCategoryView];
    [self loadData];
    [JHGrowingIO trackEventId:@"dz_sqdz_in" variables:@{@"from":self.from}];
}

- (void)initCategoryView {
    UIView *shadowView             = [[UIView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight-1, ScreenW, 1)];
    shadowView.backgroundColor     = UIColor.whiteColor;
    shadowView.layer.shadowColor   = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
    shadowView.layer.shadowOffset  = CGSizeMake(0,2);
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius  = 5;
    shadowView.layer.cornerRadius  = 8;
    CGFloat categoryHeight         = 45.f;
    
    
    //view
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, UI.statusAndNavBarHeight+categoryHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight-categoryHeight);
    
    //categoryview
    JHCustomizeChooseCagetoryBackView *categoryView = [[JHCustomizeChooseCagetoryBackView alloc] initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, categoryHeight)];
    categoryView.listContainer        = self.listContainerView;
    categoryView.delegate             = self;
    categoryView.titleColor           = HEXCOLOR(0x999999);
    categoryView.titleFont            = [UIFont fontWithName:kFontNormal size:12];
    categoryView.titleSelectedColor   = HEXCOLOR(0x333333);
    categoryView.titleSelectedFont    = [UIFont fontWithName:kFontNormal size:12];
    categoryView.backgroundColor      = [UIColor colorWithRGB:0XF5F6FA];
    self.categoryView                 = categoryView;
    

//    JXCategoryIndicatorBackgroundView *indicatorView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    indicatorView.indicatorWidthIncrement            = 26;//背景色块的额外宽度
//    indicatorView.indicatorHeight                    = 26;
//    indicatorView.indicatorCornerRadius              = 4.f;
//    indicatorView.indicatorColor                     = kColorMain;
//    self.categoryView.indicators                     = @[indicatorView];

    [self.view insertSubview:shadowView belowSubview:self.jhNavView];
    [self.view insertSubview:self.categoryView belowSubview:shadowView];
    [self.view addSubview:self.listContainerView];
}

- (void)loadData {
    [SVProgressHUD show];
    @weakify(self);
    [JHCustomizeChooseBusiness getChooseCustomizeListCompletion:^(NSError * _Nullable error, JHCustomizeChooseListModel * _Nullable model) {
        [SVProgressHUD dismiss];
        [JHDispatch ui:^{
            @strongify(self);
            if (!model && error) {
                NSLog(@"错误");
                JHEmptyView *emptyView = [[JHEmptyView alloc] init];
                [self.view addSubview:emptyView];
                [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.jhNavView.mas_bottom);
                    make.left.right.bottom.equalTo(self.view);
                }];
                return;
            }
            [self.cateArr removeAllObjects];
            [self.cateArr addObjectsFromArray:model.templates];
            [self.vcArr removeAllObjects];
            for (JHCustomizeChooseTemplatesModel *mo in self.cateArr) {
                JHCustomizeChooseViewController *vc = [[JHCustomizeChooseViewController alloc]init];
                vc.ID                               = mo.ID;
                vc.name                             = mo.name;
                vc.img                              = mo.img;
                [self.vcArr addObject:vc];
            }
            self.categoryView.titles = [self.cateArr jh_map:^id _Nonnull(JHCustomizeChooseTemplatesModel * _Nonnull obj, NSUInteger idx) {
                return obj.name;
            }];
            self.categoryView.defaultSelectedIndex = model.defaultId;
            [self.categoryView reloadData];
        }];
    }];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateArr.count;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSString *tabName = [self.categoryView.titles objectAtIndex:index];
    JHCustomizeChooseTemplatesModel *mo =  self.cateArr[index];
    
    [JHGrowingIO trackPublicEventId:@"dz_tab_works_click" paramDict:@{
        @"tabname":NONNULL_STR(tabName),/// tab定制名称
        @"worksId":@(mo.ID)   /// 定制ID
    }];
}


@end
