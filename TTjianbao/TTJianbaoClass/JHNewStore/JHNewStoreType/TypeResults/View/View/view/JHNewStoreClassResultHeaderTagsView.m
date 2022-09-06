//
//  JHNewStoreClassResultHeaderTagsView.m
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreClassResultHeaderTagsView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHNewStoreClassResultSortMenuView.h"
#import "JHC2CClassMenuView.h"
#import "JHNewStoreClassResultFilterMenuView.h"

@interface JHNewStoreClassResultHeaderTagsView ()<JHC2CClassMenuViewDelegate, JHNewStoreClassResultFilterMenuViewDelegate>
@property (nonatomic,   copy) NSArray *sortArray;
@property (nonatomic, strong) NSMutableArray *selectNameArray;//记录所选择内容
@property (nonatomic, assign) NSInteger index;//选择的index
@property (nonatomic, assign) NSInteger lastIndex;//上次选择的index
@property (nonatomic, strong) JHNewStoreClassResultSortMenuView *sortMenuView;
@property (nonatomic, strong) JHC2CClassMenuView *classMenuView;
@property (nonatomic, strong) JHNewStoreClassResultFilterMenuView *filterMenuView;//筛选弹窗
@property (nonatomic, assign) BOOL isIncrease;

@end

@implementation JHNewStoreClassResultHeaderTagsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMenuView];
    }
    return self;
}


///进入当前页面时之前页面的弹窗收起
- (void)viewControllerWillAppear{
    UIButton *selectedBtn;
    //排序弹窗收起
    if (self.index == 0) {
        selectedBtn = [self viewWithTag:100+self.index];
        [self.sortMenuView dismiss];
        selectedBtn.selected = NO;
    }
    //分类弹窗收起
    if (self.tagArray.count == 4 && self.index == 2) {
        selectedBtn = [self viewWithTag:100+self.index];
        self.classMenuView.hidden = YES;
        selectedBtn.selected = NO;
    }
    //筛选弹窗收起
    if ((self.tagArray.count == 4 && self.index == 3) || (self.tagArray.count==3 && self.index == 2)) {
        selectedBtn = [self viewWithTag:100+self.index];
    }
    
    //标签形态改变
    if ([self.selectNameArray[self.index] length] <= 0) {
        [self buttonSelected:selectedBtn];
    } else {
        [selectedBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
        selectedBtn.titleLabel.font = JHBoldFont(13);
        [selectedBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    }
}

///所选标题index 0全部 1拍卖 2一口价
- (void)setTitleIndex:(NSInteger)titleIndex{
    _titleIndex = titleIndex;
    //排序
    self.sortArray = @[@"综合排序",@"马上开拍",@"最新上架"];
    if (titleIndex == 2) {//一口价
        self.sortArray = @[@"综合排序",@"最新上架"];
    }
    self.sortMenuView.sortDataArray = self.sortArray;
    //筛选
    self.filterMenuView.titleTagIndex = titleIndex;
    
}

///选择条件标题列表
- (void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    [self initSubviews:tagArray];
}

///分类弹窗请求参数赋值
- (void)setSubCateIds:(NSArray *)subCateIds{
    _subCateIds = subCateIds;
    self.classMenuView.subCateIds = subCateIds;
}

#pragma mark - UI
- (void)setupMenuView{
    _isIncrease = NO;
    self.sortType = JHNewStorePriceSortTypeDefault;
    self.selectNameArray = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
    //排序弹窗
    [self addSubview:self.sortMenuView];
    [self.sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(44);
        make.left.right.bottom.equalTo(self);
    }];

    //分类弹窗
    [self addSubview:self.classMenuView];
    [self.classMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(44);
        make.left.right.bottom.equalTo(self);
    }];
    self.classMenuView.hidden = YES;
    
    //筛选弹窗
    [JHKeyWindow addSubview:self.filterMenuView];
    [self.filterMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
    }];
}


- (void)initSubviews:(NSArray *)tagArray{
    UIView *bgView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    for (int i = 0; i < 2; i ++) {
        UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xF2F2F2) addToSuperview:bgView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i*43.5);
            make.left.right.equalTo(bgView);
            make.height.mas_equalTo(0.5);
        }];
    }

    for (int i = 0; i < tagArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:tagArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        btn.tag = 100+i;
        [btn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/tagArray.count, 44));
            make.left.equalTo(bgView).offset((ScreenWidth/tagArray.count)*i);
        }];
        if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"newStore_search_price_default_icon"] forState:UIControlStateNormal];
        }
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];

    }
    
}

#pragma mark - Action
///tags选择事件
- (void)clickSelectBtnAction:(UIButton *)sender{
    self.index = sender.tag - 100;

    if (self.index == 1 && !_isIncrease) {//升
        _isIncrease = YES;
    } else if (self.index == 1 && _isIncrease) {//降
        _isIncrease = NO;
    }
    //筛选
    if ((self.tagArray.count == 4 && self.index == 3) || (self.tagArray.count==3 && self.index == 2)) {
        [self.filterMenuView show];
    }
    
    //按钮点击互斥
    static UIButton *lastBtn;
    if (lastBtn != sender) {
        sender.selected = YES;
        lastBtn.selected = NO;
        //区分按钮选择后形态
        [self buttonSelected:sender];
        //记录上一次点击
        self.lastIndex = lastBtn.tag - 100;
        if (self.lastIndex != 1) {
            //判断上次筛选按钮是否选择了内容
            if ([self.selectNameArray[self.lastIndex] length] <= 0) {
                lastBtn.titleLabel.font = JHFont(13);
                [lastBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
                [lastBtn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
            } else {
                lastBtn.titleLabel.font = JHBoldFont(13);
                [lastBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
                [lastBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            }
        }
        lastBtn = sender;
        
        //排序和价格互斥：选择价格时，设置排序为初始状态
        if (self.index == 1) {
            UIButton *sortBtn = [self viewWithTag:100];
            sortBtn.titleLabel.font = JHFont(13);
            [sortBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [sortBtn setTitle:self.sortArray[0] forState:UIControlStateNormal];
            [sortBtn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
            [self.selectNameArray replaceObjectAtIndex:0 withObject:@""];
            //刷新排序弹窗内容
            self.sortMenuView.isReset = YES;
        }

    }
    //按钮重复点击处理
    else {
        sender.selected = !sender.selected;
        //区分按钮选择后形态
        [self buttonSelected:sender];
        //判断筛选按钮是否选择了内容
        if ([self.selectNameArray[self.index] length] > 0) {
            sender.titleLabel.font = JHBoldFont(13);
            [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            if (sender.selected) {
                [sender setImage:[UIImage imageNamed:@"newStore_search_up_icon"] forState:UIControlStateNormal];
            } else {
                
                [sender setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            }
        }

    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagsViewSelectedOfIndex:selected:)]) {
        [self.delegate tagsViewSelectedOfIndex:self.index selected:sender.selected];
    }

}

/// 排序回调
- (void)sortMenuViewBlock{
    //筛选后回调
    @weakify(self);
    self.sortMenuView.selectCompleteBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        UIButton *sortBtn = [self viewWithTag:100];
        sortBtn.selected = NO;
        if (selectIndex < 0) {//点击背景
            if ([self.selectNameArray[0] length] <= 0) {
                [self buttonSelected:sortBtn];
            } else {
                [sortBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
                sortBtn.titleLabel.font = JHBoldFont(13);
                [sortBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            }

        } else {
            //排序和价格互斥：选择排序时，设置价格为初始状态
            UIButton *priceBtn = [self viewWithTag:101];
            _isIncrease = NO;
            priceBtn.titleLabel.font = JHFont(13);
            [priceBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [priceBtn setImage:[UIImage imageNamed:@"newStore_search_price_default_icon"] forState:UIControlStateNormal];
            
            
            [self.selectNameArray replaceObjectAtIndex:0 withObject:self.sortArray[selectIndex]];
            //按钮形态改变
            [sortBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            [sortBtn setTitle:self.sortArray[selectIndex] forState:UIControlStateNormal];
            sortBtn.titleLabel.font = JHBoldFont(13);
            [sortBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [sortBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
             
        }
        //排序
        if (selectIndex > 0) {
            selectIndex += 2;
        }
        self.sortType = selectIndex;
        if (self.delegate && [self.delegate respondsToSelector:@selector(sortViewSelectedOfIndex:)]) {
            [self.delegate sortViewSelectedOfIndex:self.sortType];
        }
       
    };
}
///选中按钮形态变化
- (void)buttonSelected:(UIButton *)sender{
    if (sender.selected) {
        sender.titleLabel.font = JHBoldFont(13);
        [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"newStore_search_up_icon"] forState:UIControlStateNormal];
    } else {
        sender.titleLabel.font = JHFont(13);
        [sender setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
    }
    [self.sortMenuView dismiss];
    self.classMenuView.hidden = YES;
    
    if (self.index == 0) {
        if (sender.selected) {
            [self.sortMenuView show];
        } else {
            [self.sortMenuView dismiss];
        }
    }
    if (self.index == 1) {
        sender.titleLabel.font = JHBoldFont(13);
        [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        NSString *str = _isIncrease ? @"newStore_search_price_up_icon" : @"newStore_search_price_down_icon";
        [sender setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        
        self.sortType = _isIncrease ? JHNewStorePriceSortTypeIncrease : JHNewStorePriceSortTypeDecrease;
        //价格
        if (self.delegate && [self.delegate respondsToSelector:@selector(sortViewSelectedOfIndex:)]) {
            [self.delegate sortViewSelectedOfIndex:self.sortType];
        }
    }
    if (self.tagArray.count == 4 && self.index == 2) {
        if (sender.selected) {
            self.classMenuView.hidden = NO;
        } else {
            self.classMenuView.hidden = YES;
        }
    }
}

//超出本试图的view响应点击事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                return subView;
            }
        }
    }
    return view;
}

#pragma mark - LoadData


#pragma mark - Delegate
#pragma mark - JHC2CClassMenuViewDelegate
///分类筛选事件
- (void)classViewDidSelect:(JHNewStoreTypeTableCellViewModel *)subClassModel selectAllClass:(BOOL)selectAllClass dismissView:(BOOL)dismiss {
    UIButton *classBtn = [self viewWithTag:102];
    classBtn.selected = NO;
    if (dismiss) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(classViewDidSelect:selectAllClass:dismissView:)]) {
            [self.delegate classViewDidSelect:subClassModel selectAllClass:selectAllClass dismissView:dismiss];
        }
        //按钮形态改变
        if ([self.selectNameArray[2] length] <= 0) {
            [self buttonSelected:classBtn];
        } else {
            [classBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            classBtn.titleLabel.font = JHBoldFont(13);
            [classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            self.classMenuView.hidden = YES;
        }
        return;
    }
    else {
        CGFloat time = 0;
        NSString *selectClassName = @"分类";
        if (subClassModel.cateName.length > 0) {
            time = 0.2;
            selectClassName = subClassModel.cateName;
            if (selectClassName.length > 3) {
                selectClassName = [NSString stringWithFormat:@"%@…",[selectClassName substringToIndex:3]];

            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(classViewDidSelect:selectAllClass:dismissView:)]) {
                    [self.delegate classViewDidSelect:subClassModel selectAllClass:selectAllClass dismissView:dismiss];
                }
                
                [self.selectNameArray replaceObjectAtIndex:2 withObject:selectClassName];
                //按钮形态改变
                self.classMenuView.hidden = YES;
                [classBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
                [classBtn setTitle:selectClassName forState:UIControlStateNormal];
                classBtn.titleLabel.font = JHBoldFont(13);
                [classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
                [classBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];

            });
            
        }else{
            //重置
            if (self.delegate && [self.delegate respondsToSelector:@selector(classViewDidSelect:selectAllClass:dismissView:)]) {
                [self.delegate classViewDidSelect:subClassModel selectAllClass:selectAllClass dismissView:dismiss];
            }
            [self.selectNameArray replaceObjectAtIndex:2 withObject:@""];
            //按钮形态改变
            [classBtn setTitle:@"分类" forState:UIControlStateNormal];
            [self buttonSelected:classBtn];
            [classBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];

        }
    }
    
}

#pragma mark - JHNewStoreClassResultFilterMenuViewDelegate
///筛选弹窗点击事件
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex auction:(BOOL)isSelected lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice isFilteredInfo:(BOOL)isFiltered{
    
    UIButton *filterBtn = [self viewWithTag:100+self.index];
    filterBtn.selected = NO;
    //改变按钮形态
    if (serviceIndex > 0 || isSelected || lowPrice.length > 0 || highPrice.length > 0) {
        [self.selectNameArray replaceObjectAtIndex:3 withObject:@"筛选"];
        [filterBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
        filterBtn.titleLabel.font = JHBoldFont(13);
        [filterBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    } else {
        [self.selectNameArray replaceObjectAtIndex:3 withObject:@""];
        [self buttonSelected:filterBtn];
    }
    //只有筛选过信息才刷新
    if (isFiltered) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewSelectedOfService:auction:lowPrice:highPrice:)]) {
            [self.delegate filterViewSelectedOfService:serviceIndex auction:isSelected lowPrice:lowPrice highPrice:highPrice];
        }
    }

}


#pragma mark - Lazy
- (JHNewStoreClassResultSortMenuView *)sortMenuView{
    if (!_sortMenuView) {
        _sortMenuView = [[JHNewStoreClassResultSortMenuView alloc] init];
        [self sortMenuViewBlock];
    }
    return _sortMenuView;
}

- (JHC2CClassMenuView *)classMenuView{
    if (!_classMenuView) {
        _classMenuView = [[JHC2CClassMenuView alloc] init];
        _classMenuView.delegate = self;
        _classMenuView.fromStatus = 1;
    }
    return _classMenuView;
}
- (JHNewStoreClassResultFilterMenuView *)filterMenuView{
    if (!_filterMenuView) {
        _filterMenuView = [[JHNewStoreClassResultFilterMenuView alloc] init];
        _filterMenuView.delegate = self;
    }
    return _filterMenuView;
}



@end
