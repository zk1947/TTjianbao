//
//  JHC2CSubClassTitleScrollView.m
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSubClassTitleScrollView.h"
#import "JHNewStoreTypeTableCellViewModel.h"

@interface JHC2CSubClassTitleScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation JHC2CSubClassTitleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - UI
- (void)initSubviews{
    [self removeAllSubviews];
    
    if (!_selectedBtn) {
        _selectedBtn = [[UIButton alloc] init];
    }
    CGFloat allTagsWidth = 0.0;
    UIButton *leftBtn = [[UIButton alloc] init];
    for (int i = 0; i < self.subClassArray.count+1; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [btn setTitle:@"全部" forState:UIControlStateNormal];
        }else{
            JHNewStoreTypeTableCellViewModel *viewModel = self.subClassArray[i-1];
            if (viewModel.cateName.length > 4) {
                [btn setTitle:[NSString stringWithFormat:@"%@...",[viewModel.cateName substringToIndex:3]] forState:UIControlStateNormal];
            }else{
                [btn setTitle:viewModel.cateName forState:UIControlStateNormal];
            }
        }
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFFFF)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFBDC)] forState:UIControlStateSelected];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = 1100 + i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius  = 12;
        btn.layer.borderColor = HEXCOLOR(0xE6E6E6).CGColor;
        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(clickTagsTitleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.mas_offset(24);
            make.width.mas_equalTo(66);
            if (i) {
                make.left.equalTo(leftBtn.mas_right).offset(6);
            }else {
                make.left.mas_offset(12);
            }
        }];
        
        allTagsWidth += (66+6);
        
        leftBtn = btn;
        //默认第一个标签选中，且不可点击
        if (i == 0) {
            btn.selected = YES;
            btn.userInteractionEnabled = NO;
            btn.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
            self.selectedBtn = btn;
        }else{
            btn.selected = NO;
        }
    }
    //设置contentSize
    self.contentSize = CGSizeMake(allTagsWidth+12, 40);

}

#pragma mark - set/get
- (void)setSubClassArray:(NSArray *)subClassArray{
    _subClassArray = subClassArray;
    [self initSubviews];
}

#pragma mark - Action
///选择三级分类
- (void)clickTagsTitleBtnAction:(UIButton *)sender{
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    self.selectedBtn.layer.borderColor = HEXCOLOR(0xE6E6E6).CGColor;

    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    if (sender.selected) {
        sender.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
    }
    self.selectedBtn = sender;
    //让选中的标签居中显示
    [self setTagsTitleCenter:sender];

    NSInteger index = sender.tag - 1100;
    if (self.classDelegate && [self.classDelegate respondsToSelector:@selector(subClassTitleDidSelect:)]) {
        [self.classDelegate subClassTitleDidSelect:index];
    }
    

}

///让选中的标签居中显示
- (void)setTagsTitleCenter:(UIButton *)button{
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = button.center.x - self.width*0.5 + 9;
    if (offsetX < 0) {
        offsetX = 0;
    }
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.contentSize.width - self.width;
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    if (button.right < self.width*0.5){
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        // 滚动区域
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
}

#pragma mark - Lazy

@end
