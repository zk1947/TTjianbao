//
//  JHRecyclePriceController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorImageView.h"
#import "JHRecyclePriceHistoryListController.h"

static const CGFloat JHheightForHeaderInSection = 45;

@interface JHRecyclePriceController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 容器*/
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
/** 控制器*/
@property (nonatomic, strong) NSMutableArray *vcArr;
@end

@implementation JHRecyclePriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出价记录";
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(JHheightForHeaderInSection);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];

    self.categoryView.titles = @[@"全部", @"中标", @"待用户确认出价", @"失效"];
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.defaultSelectedIndex = 0;
    [self.categoryView reloadData];
}

#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.vcArr.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}
- (JXCategoryTitleView *)categoryView {
   if (_categoryView == nil) {
       _categoryView = [[JXCategoryTitleView alloc] init];
       _categoryView.backgroundColor = [UIColor clearColor];
       _categoryView.titleColor = HEXCOLOR(0x222222);
       _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
       _categoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldDIN size:14];
       _categoryView.titleSelectedColor = HEXCOLOR(0x222222);
       _categoryView.cellSpacing = 10;
       _categoryView.delegate = self;
       
       JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
       indicatorImgView.indicatorImageView.backgroundColor = HEXCOLOR(0xfee100);
       indicatorImgView.indicatorImageViewSize = CGSizeMake(21, 3);
       indicatorImgView.layer.cornerRadius = 1.5;
       indicatorImgView.clipsToBounds = YES;
       indicatorImgView.verticalMargin = 8;
       _categoryView.indicators = @[indicatorImgView];
   }
   return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
   if (!_listContainerView) {
       _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
   }
   return _listContainerView;
}

- (NSMutableArray *)vcArr {
    if (_vcArr == nil) {
        _vcArr = [NSMutableArray array];
        JHRecyclePriceHistoryListController *Vc1 = [[JHRecyclePriceHistoryListController alloc] init];
        Vc1.bidStatus = @"";
        [_vcArr addObject:Vc1];
        JHRecyclePriceHistoryListController *Vc2 = [[JHRecyclePriceHistoryListController alloc] init];
        Vc2.bidStatus = @"3";
        [_vcArr addObject:Vc2];
        JHRecyclePriceHistoryListController *Vc3 = [[JHRecyclePriceHistoryListController alloc] init];
        Vc3.bidStatus = @"0";
        [_vcArr addObject:Vc3];
        JHRecyclePriceHistoryListController *Vc4 = [[JHRecyclePriceHistoryListController alloc] init];
        Vc4.bidStatus = @"6";
        [_vcArr addObject:Vc4];
    }
    return _vcArr;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return self.categoryView;
}

@end
