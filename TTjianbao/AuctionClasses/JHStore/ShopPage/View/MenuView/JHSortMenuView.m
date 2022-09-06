//
//  JHSortMenuView.m
//  TTjianbao
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSortMenuView.h"
#import "TTjianbao.h"
#import "JHRightArrowBtn.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YYControl.h"

#define listButtonTag  1000

@interface JHSortMenuView ()

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, assign) BOOL isDecrease;

@end

@implementation JHSortMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
    _isDecrease = NO;
    _sortType = JHMenuSortTypeRecommend;
    
    for (int i = 0; i < _menuArray.count; i ++) {
        JHMenuMode *mode = _menuArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:mode.title forState:UIControlStateNormal];
        [btn setTitle:mode.title forState:UIControlStateHighlighted];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        btn.tag = listButtonTag + i;
        [btn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (mode.isShowImg) {
                CGFloat width = ceilf([mode.title getWidthWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(100, 13)]);
                make.width.mas_equalTo(width + 15);
            }
            if (i) {
                make.left.equalTo(self.listBtn.mas_right).offset(50);
            }
            else {
                make.left.equalTo(@10);
            }
        }];
        ///有用 ---lh
        _listBtn = btn;
        [btn layoutIfNeeded];
        if (mode.isShowImg) {
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
            [btn setImage:[UIImage imageNamed:@"icon_shop_default"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 列表 action
- (void)listBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag - listButtonTag;
    if (index != 2 && sender.selected) {
        return;
    }
    
    ///给selectIndex赋值
    self.selectIndex = index;
    
    if (index == 2 && _isDecrease) {
        index = 3;
    }
    
    if (index == 0) {
        _isDecrease = NO;
        _sortType = JHMenuSortTypeRecommend;
    }
    else if (index == 1) {
        _isDecrease = NO;
        _sortType = JHMenuSortTypeTime;
    }
    else if (index == 2) {
        _isDecrease = YES;
        _sortType = JHMenuSortTypeDecrease;
    }
    else if (index == 3) {
        _isDecrease = NO;
        _sortType = JHMenuSortTypeIncrease;
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
            JHMenuMode *mode = self.menuArray[_selectIndex];
            if (mode.isShowImg) {
                NSString *str = (self.sortType == 3) ? @"icon_shop_dec" : @"icon_shop_ins";
                [btn setImage:[UIImage imageNamed:str] forState:UIControlStateSelected];
            }
            btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
            btn.selected = YES;
        }
        else {
            btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
            btn.selected = NO;
        }
    }
}

@end

@implementation JHMenuMode

@end
