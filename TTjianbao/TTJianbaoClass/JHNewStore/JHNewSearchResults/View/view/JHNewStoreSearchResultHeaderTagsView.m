//
//  JHNewStoreSearchResultHeaderTagsView.m
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultHeaderTagsView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHNewStoreSearchResultSortMenuView.h"
#import "JHNewStoreSearchResultFilterMenuView.h"

@interface JHNewStoreSearchResultHeaderTagsView ()<JHNewStoreSearchResultFilterMenuViewDelegate>
@property (nonatomic,   copy) NSArray *sortArray;
@property (nonatomic, strong) NSMutableArray *selectNameArray;//记录所选择内容
@property (nonatomic, assign) NSInteger index;//选择的index
@property (nonatomic, assign) NSInteger lastIndex;//上次选择的index
@property (nonatomic, strong) JHNewStoreSearchResultSortMenuView *sortMenuView;
@property (nonatomic, strong) JHNewStoreSearchResultFilterMenuView *filterMenuView;//筛选弹窗
@property (nonatomic, assign) BOOL isIncrease;

@property (nonatomic, assign) BOOL isSelectedFirstIndex;//是否选择第一个


@end

@implementation JHNewStoreSearchResultHeaderTagsView

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
    
    //标签形态改变
    if ([self.selectNameArray[self.index] length] <= 0) {
        [self buttonTitleStyle:selectedBtn isBold:NO];
        [selectedBtn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
    } else {
        [self buttonTitleStyle:selectedBtn isBold:YES];
        [selectedBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
    }
}


///选择条件标题列表
- (void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    [self initSubviews:tagArray];
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
    self.sortArray = @[@"综合排序",@"最新上架"];
    //排序
    self.sortMenuView.sortDataArray = self.sortArray;
    
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
    UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xF2F2F2) addToSuperview:bgView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(43.5);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];


    for (int i = 0; i < tagArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:tagArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(clickSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/5, 44));
            if (self.tagArray.count == 3 && i == 2) {
                make.left.equalTo(bgView).offset((ScreenWidth/5)*4);
            } else {
                make.left.equalTo(bgView).offset((ScreenWidth/5)*i);

            }
        }];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
        }
        if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"newStore_search_price_default_icon"] forState:UIControlStateNormal];
        }
        if (i == tagArray.count-1) {
            [btn setImage:[UIImage imageNamed:@"newStore_search_filter_icon"] forState:UIControlStateNormal];
        }
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];

    }
    
}

- (void)clickSelectBtnAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    self.index = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagsViewSelectedOfIndex:)]) {
        [self.delegate tagsViewSelectedOfIndex:index];
    }
    //筛选
    if ((self.tagArray.count == 5 && index == 4) || (self.tagArray.count == 3 && index == 2)) {
        [self.filterMenuView show];
        self.defaultIndex = index;
        return;
    }
    
    if (index > 1 && sender.selected) {
        return;
    }
    
    ///给selectIndex赋值
    self.defaultIndex = index;
    
    //综合排序特殊处理
    if (index == 0) {
        sender.selected = !sender.selected;
        //处理综合排序tag点击事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(tagsViewSelectedOfSortMenuView:)]) {
            [self.delegate tagsViewSelectedOfSortMenuView:sender.selected];
        }
        
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"newStore_search_up_icon"] forState:UIControlStateNormal];
            [self.sortMenuView show];
        } else {
            [sender setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
            [self.sortMenuView dismiss];
        }
        //判断筛选按钮是否选择了内容
        if ([self.selectNameArray[index] length] > 0) {
            [self buttonTitleStyle:sender isBold:YES];
            if (sender.selected) {
                [sender setImage:[UIImage imageNamed:@"newStore_search_up_icon"] forState:UIControlStateNormal];
            } else {
                [sender setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            }
        }
       

    }
    else if (index == 1 && !_isIncrease) {//升
        _isIncrease = YES;
        _sortType = JHNewStorePriceSortTypeIncrease;
    }
    else if (index == 1 && _isIncrease) {//降
        _isIncrease = NO;
        _sortType = JHNewStorePriceSortTypeDecrease;
    }
    else if (index == 2) {//马上开拍
        _isIncrease = NO;
        _sortType = JHNewStorePriceSortTypeStartAuction;
    }
    else if (index == 3) {//即将截拍
        _isIncrease = NO;
        _sortType = JHNewStorePriceSortTypeStopAuction;
    }
        
    if (index > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sortViewSelectedOfIndex:)]) {
            [self.delegate sortViewSelectedOfIndex:self.sortType];
        }
    }
    

}

- (void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex = defaultIndex;
    for (int i = 0; i < self.tagArray.count; i ++) {
        UIButton *btn = [self viewWithTag:100 + i];
        if (i == defaultIndex) {
            //除综合排序外
            if (i > 0) {
                if (i == 1) {
                    NSString *str = (self.sortType == 1) ? @"newStore_search_price_down_icon" : @"newStore_search_price_up_icon";
                    [btn setImage:[UIImage imageNamed:str] forState:UIControlStateSelected];
                }
                btn.selected = YES;
                [self buttonTitleStyle:btn isBold:YES];
            }
            
        } else {
            if (i > 0 && defaultIndex==0) {
                if ([self.selectNameArray[0] length] > 0) {
                    btn.selected = NO;
                    [self buttonTitleStyle:btn isBold:NO];
                }
                //筛选按钮
                [self filterButtonStyle:btn index:i];

            } else {
                //筛选
                if ((self.tagArray.count == 5 && defaultIndex == 4) || (self.tagArray.count == 3 && defaultIndex == 2)) {
                    if (i == 0 ) {
                        btn.selected = NO;
                        if ([self.selectNameArray[0] length] > 0) {
                            [self buttonTitleStyle:btn isBold:YES];
                            [btn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
                        } else {
                            [btn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
                        }
                        //处理综合排序tag点击事件
                        if (self.delegate && [self.delegate respondsToSelector:@selector(tagsViewSelectedOfSortMenuView:)]) {
                            [self.delegate tagsViewSelectedOfSortMenuView:btn.selected];
                        }
                        
                    }
                } else {
                    btn.selected = NO;
                    [self buttonTitleStyle:btn isBold:NO];
                    if (i == 0) {//重置综合排序标签
                        [btn setTitle:self.sortArray[0] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];
                        [self.selectNameArray replaceObjectAtIndex:0 withObject:@""];
                        //刷新排序弹窗内容
                        self.sortMenuView.isReset = YES;
                    }
                    //筛选按钮
                    [self filterButtonStyle:btn index:i];
                }
               
            }
           
        }
    }
}

///筛选按钮
- (void)filterButtonStyle:(UIButton *)btn index:(int)index{
    if ((self.tagArray.count == 5 && index == 4) || (self.tagArray.count == 3 && index == 2)) {
        //改变按钮形态
        if ([self.selectNameArray[3] length] > 0) {
            [self buttonTitleStyle:btn isBold:YES];
        } else {
            [self buttonTitleStyle:btn isBold:NO];
        }
    }
}
#pragma mark - Action
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
                [self buttonTitleStyle:sortBtn isBold:NO];
                [sortBtn setImage:[UIImage imageNamed:@"newStore_search_down_icon"] forState:UIControlStateNormal];

            } else {
                [self buttonTitleStyle:sortBtn isBold:YES];
                [sortBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            }
            self.sortType = JHNewStorePriceSortTypeDismiss;

        } else {
           
            //选择了排序
            [self.selectNameArray replaceObjectAtIndex:0 withObject:self.sortArray[selectIndex]];
            //按钮形态改变
            [sortBtn setImage:[UIImage imageNamed:@"newStore_search_selected_down_icon"] forState:UIControlStateNormal];
            [sortBtn setTitle:self.sortArray[selectIndex] forState:UIControlStateNormal];
            [self buttonTitleStyle:sortBtn isBold:YES];
            [sortBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        
            _isIncrease = NO;
            self.defaultIndex = 0;
            
            
            //排序
            if (selectIndex == 0) {//综合排序
                self.sortType = JHNewStorePriceSortTypeDefault;
            } else if (selectIndex == 1) {//最新上架
                self.sortType = JHNewStorePriceSortTypeLatest;
            }
            
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sortViewSelectedOfIndex:)]) {
            [self.delegate sortViewSelectedOfIndex:self.sortType];
        }
       
    };
}

///按钮文字样式
- (void)buttonTitleStyle:(UIButton *)sender isBold:(BOOL)bold{
    if (bold) {
        sender.titleLabel.font = JHBoldFont(13);
        [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    } else {
        sender.titleLabel.font = JHFont(13);
        [sender setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
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
#pragma mark - JHNewStoreSearchResultFilterMenuViewDelegate
///筛选弹窗点击事件
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice isFilteredInfo:(BOOL)isFiltered{
    
    UIButton *filterBtn = [self viewWithTag:100+self.index];
    filterBtn.selected = NO;
    //改变按钮形态
    if (serviceIndex > 0 || lowPrice.length > 0 || highPrice.length > 0) {
        [self.selectNameArray replaceObjectAtIndex:3 withObject:@"筛选"];
        [self buttonTitleStyle:filterBtn isBold:YES];
    } else {
        [self.selectNameArray replaceObjectAtIndex:3 withObject:@""];
        [self buttonTitleStyle:filterBtn isBold:NO];
    }
    //只有筛选过信息才刷新
    if (isFiltered) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewSelectedOfService:lowPrice:highPrice:)]) {
            [self.delegate filterViewSelectedOfService:serviceIndex lowPrice:lowPrice highPrice:highPrice];
        }
    }

}


#pragma mark - Lazy
- (JHNewStoreSearchResultSortMenuView *)sortMenuView{
    if (!_sortMenuView) {
        _sortMenuView = [[JHNewStoreSearchResultSortMenuView alloc] init];
        [self sortMenuViewBlock];
    }
    return _sortMenuView;
}

- (JHNewStoreSearchResultFilterMenuView *)filterMenuView{
    if (!_filterMenuView) {
        _filterMenuView = [[JHNewStoreSearchResultFilterMenuView alloc] init];
        _filterMenuView.delegate = self;
    }
    return _filterMenuView;
}



@end
