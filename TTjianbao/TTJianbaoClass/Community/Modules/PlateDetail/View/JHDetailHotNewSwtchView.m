//
//  JHDetailHotNewSwtchView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDetailHotNewSwtchView.h"

@interface JHDetailHotNewSwtchView ()

@property (nonatomic, weak) UIButton *button1;

@property (nonatomic, weak) UIButton *button2;

@end


@implementation JHDetailHotNewSwtchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jh_cornerRadius:[JHDetailHotNewSwtchView viewSize].height / 2.0];
        self.backgroundColor = APP_BACKGROUND_COLOR;
        [self addSelfSubViews];
    }
    return self;
}

-(void)addSelfSubViews
{
    _button1 = [UIButton jh_buttonWithTitle:@"发布时间" fontSize:11 textColor:RGB(153, 153, 153) target:self action:@selector(switchChangeMethod:) addToSuperView:self];
    [_button1 setTitleColor:RGB(102, 102, 102) forState:UIControlStateSelected];
    _button1.tag = 1000;
    [_button1 jh_cornerRadius:11 borderColor:APP_BACKGROUND_COLOR borderWidth:1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    
    _button2 = [UIButton jh_buttonWithTitle:@"回复时间" fontSize:11 textColor:RGB(153, 153, 153) target:self action:@selector(switchChangeMethod:) addToSuperView:self];
    _button2.tag = 1001;
    [_button2 jh_cornerRadius:11 borderColor:APP_BACKGROUND_COLOR borderWidth:1];
    [_button2 setTitleColor:RGB(102, 102, 102) forState:UIControlStateSelected];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.width.equalTo(self.button1);
        make.left.equalTo(self.mas_centerX);
    }];
    self.selectIndex = 1;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _button1.selected = (selectIndex == 0);
    _button2.selected = (selectIndex == 1);
    
    _button1.backgroundColor = (selectIndex == 0 ? UIColor.whiteColor : APP_BACKGROUND_COLOR);
    _button2.backgroundColor = (selectIndex == 1 ? UIColor.whiteColor : APP_BACKGROUND_COLOR);
}

-(void)switchChangeMethod:(UIButton *)button
{
    self.selectIndex = button.tag - 1000;
    if(_selectBlock)
    {
        _selectBlock(button.tag - 1000);
    }
}

+ (CGSize)viewSize
{
    return CGSizeMake(108, 22);
}

- (void)setSwitchBtnName:(NSArray<NSString *>*)nameArr {
    if (nameArr[0] && ![nameArr[0] isEqualToString:@""]) {
        [_button1 setTitle:nameArr[0] forState:UIControlStateNormal];
    }
    if (nameArr[1] && ![nameArr[1] isEqualToString:@""]) {
        [_button2 setTitle:nameArr[1] forState:UIControlStateNormal];
    }
}

@end
