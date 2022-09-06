//
//  JHNewShopSortMenuView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopSortMenuView.h"
#import "TTjianbao.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YYControl.h"

#define listButtonTag  1000

@interface JHNewShopSortMenuView ()

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, assign) BOOL isIncrease;
@property (nonatomic, assign) CGFloat defaultTitleFont;

@end

@implementation JHNewShopSortMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray titleFont:(CGFloat )titleFont {
    self = [super initWithFrame:frame];
    if (self) {
        _defaultTitleFont = titleFont;
        _menuArray = menuArray;
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    if (!_listBtn) {
        _listBtn = [[UIButton alloc] init];
    }
    ///默认值是不排序的状态
    _isIncrease = NO;
    _sortType = JHMenuSortTypeRecommend;
    
    for (int i = 0; i < _menuArray.count; i ++) {
        JHNewShopMenuMode *mode = _menuArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:mode.title forState:UIControlStateNormal];
        [btn setTitle:mode.title forState:UIControlStateHighlighted];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        btn.titleLabel.font = JHMediumFont(_defaultTitleFont);
        btn.tag = listButtonTag + i;
        [btn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (mode.isShowImg) {
                CGFloat width = ceilf([mode.title getWidthWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)]);
                make.width.mas_equalTo(width + 10);
            }
            if (i) {
                make.left.equalTo(self.listBtn.mas_right).offset(20);
            }
            else {
                make.left.mas_offset(0);
            }
        }];
        
        _listBtn = btn;
        [btn layoutIfNeeded];
        if (mode.isShowImg) {
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
            [btn setImage:[UIImage imageNamed:@"newStore_sortDefault_icon"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 列表 action
- (void)listBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag - listButtonTag;
    if (index != 1 && sender.selected) {
        return;
    }
    
    ///给selectIndex赋值
    self.selectIndex = index;
    
    if (index == 1 && _isIncrease) {
        index = 2;
    }
    
    if (index == 0) {
        _isIncrease = NO;
        _sortType = JHMenuSortTypeRecommend;
    }
    else if (index == 1) {//升
        _isIncrease = YES;
        _sortType = JHMenuSortTypeIncrease;
    }
    else if (index == 2) {//降
        _isIncrease = NO;
        _sortType = JHMenuSortTypeDecrease;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuViewDidSelect:)]) {
        [self.delegate menuViewDidSelect:self.sortType];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    for (int i = 0; i < _menuArray.count; i ++) {
        UIButton *btn = [self viewWithTag:listButtonTag + i];
        if (i == _selectIndex) {
            JHNewShopMenuMode *mode = self.menuArray[_selectIndex];
            if (mode.isShowImg) {
                NSString *str = (self.sortType == 1) ? @"newStore_sortDown_icon" : @"newStore_sortUp_icon";
                [btn setImage:[UIImage imageNamed:str] forState:UIControlStateSelected];
            }
            btn.titleLabel.font = JHMediumFont(_defaultTitleFont);
            btn.selected = YES;
        }
        else {
            btn.titleLabel.font = JHMediumFont(_defaultTitleFont);
            btn.selected = NO;
        }
    }
}


@end

@implementation JHNewShopMenuMode

@end
