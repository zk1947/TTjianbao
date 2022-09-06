//
//  JHC2CSortMenuView.m
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSortMenuView.h"
#import "TTjianbao.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YYControl.h"

@interface JHC2CSortMenuView ()
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, assign) BOOL isIncrease;
@property (nonatomic, assign) CGFloat defaultTitleFont;
@end

@implementation JHC2CSortMenuView

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
    _sortType = JHC2CSortMenuTypeRecommend;
    
    for (int i = 0; i < _menuArray.count; i ++) {
        JHC2CSortMenuMode *mode = _menuArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:mode.title forState:UIControlStateNormal];
        [btn setTitle:mode.title forState:UIControlStateHighlighted];
        [btn setTitleColor:HEXCOLOR(0x888888) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        btn.titleLabel.font = JHFont(_defaultTitleFont);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (mode.isShowImg) {
                CGFloat width = ceilf([mode.title getWidthWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)]);
                make.width.mas_equalTo(width + 10);
            }
            if (i) {
                make.left.equalTo(self.listBtn.mas_right).offset(25);
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
    NSInteger index = sender.tag - 100;
    if (index != 1 && sender.selected && !self.isPriceFirst) {
        return;
    }
    
    ///给selectIndex赋值
    self.selectIndex = index;

    [self dealSelectStatus:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuViewDidSelect:)]) {
        [self.delegate menuViewDidSelect:self.sortType];
    }
}

- (void)dealSelectStatus:(NSInteger)index{
    if (self.isPriceFirst) {
        if (index == 0 && _isIncrease) {//降
            _isIncrease = NO;
            _sortType = JHC2CSortMenuTypeDecrease;
        }
        else if (index == 0 && !_isIncrease) {//升
            _isIncrease = YES;
            _sortType = JHC2CSortMenuTypeIncrease;
        }
        else if (index == 1) {//即将截拍
            _isIncrease = NO;
            _sortType = JHC2CSortMenuTypeRecommend;
        }
        else if (index == 2) {//马上开拍
            _isIncrease = NO;
            _sortType = JHC2CSortMenuTypeNewPush;
        }
    }else{
        if (index == 0) {
            _isIncrease = NO;
            _sortType = JHC2CSortMenuTypeRecommend;
        }
        else if (index == 1 && !_isIncrease) {//升
            _isIncrease = YES;
            _sortType = JHC2CSortMenuTypeIncrease;
        }
        else if (index == 1 && _isIncrease) {//降
            _isIncrease = NO;
            _sortType = JHC2CSortMenuTypeDecrease;
        }
        else if (index == 2) {//最新上架
            _isIncrease = NO;
            _sortType = JHC2CSortMenuTypeNewPush;
        }
    }
}

- (void)setIsPriceFirst:(BOOL)isPriceFirst{
    _isPriceFirst = isPriceFirst;
    _isIncrease = _isPriceFirst ? YES:NO;
    _sortType = 1;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    for (int i = 0; i < _menuArray.count; i ++) {
        UIButton *btn = [self viewWithTag:100 + i];
        if (i == _selectIndex) {
            JHC2CSortMenuMode *mode = self.menuArray[_selectIndex];
            if (mode.isShowImg) {
                NSString *str = (self.sortType == 1) ? @"newStore_sortDown_icon" : @"newStore_sortUp_icon";
                [btn setImage:[UIImage imageNamed:str] forState:UIControlStateSelected];
            }
            btn.titleLabel.font = JHMediumFont(_defaultTitleFont);
            btn.selected = YES;
        }
        else {
            btn.titleLabel.font = JHFont(_defaultTitleFont);
            btn.selected = NO;
        }
    }
}


@end


@implementation JHC2CSortMenuMode

@end
