//
//  JHPublishReportTrueCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportTrueCell.h"
#import "JHPublishReportCollectionView.h"
#import "JHPublishReportTrueOtherCell.h"
#import "JHPublishReportModel.h"
#import "JXCategoryView.h"

@interface JHPublishReportTrueCell ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, weak) JHPublishReportCollectionView *collectionView;


@property (nonatomic, weak) JXCategoryTitleView  *categoryView;

@end

@implementation JHPublishReportTrueCell

- (void)addSelfSubViews {
    
    _priceTf = [JHPublishReportTrueOtherCell creatTextFieldWithTitle:@"价格" placeHolder:@"请输入预估价格" top:15 addSupView:self.contentView];
    
    @weakify(self);
    [_priceTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if(self.priceBlock) {
            self.priceBlock(x);
        }
    }];
    
    _collectionView = [JHPublishReportCollectionView jh_viewWithColor:UIColor.redColor addToSuperview:self.contentView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(66);
    }];
}

- (JXCategoryTitleView *)categoryView
{
    if(!_categoryView)
    {
        JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 65, ScreenW, 30)];
        categoryView.backgroundColor = [UIColor whiteColor];
        categoryView.delegate = self;
        categoryView.titleSelectedColor = RGB515151;
        categoryView.titleColor = RGB515151;
        categoryView.titleSelectedFont = JHBoldFont(14);
        categoryView.titleFont = JHFont(14);
        categoryView.titleColorGradientEnabled = NO;
        categoryView.titleLabelZoomEnabled = NO;
        categoryView.averageCellSpacingEnabled = NO;
        
        JXCategoryIndicatorLineView *indicatorView = [[JXCategoryIndicatorLineView alloc] init];
        indicatorView.layer.cornerRadius = 2.0;
        indicatorView.indicatorColor = HEXCOLOR(0xFEE100);
        indicatorView.size = CGSizeMake(28, 4);
        categoryView.indicators = @[indicatorView];
        [self.contentView addSubview:categoryView];
        _categoryView = categoryView;
    }
    return _categoryView;
}

- (void)setSubCateArray:(NSMutableArray<JHReportCatePropertyModel *> *)subCateArray {
    if(IS_ARRAY(subCateArray)) {
        _subCateArray = subCateArray;
        JHReportCatePropertyModel *m = _subCateArray.firstObject;
        NSMutableArray *titles = [NSMutableArray new];
        if(IS_ARRAY(m.fieldValues)) {
            for (JHReportCatePropertyModel *m in _subCateArray) {
                [titles addObject:m.fieldName];
            }
        }
        self.collectionView.catePropertyModel = m;
        self.categoryView.titles = titles;
        [self.categoryView reloadData];
        [self.categoryView selectItemAtIndex:0];
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.subCateArray.count;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    self.collectionView.catePropertyModel = self.subCateArray[index];
}

@end
