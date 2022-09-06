//
//  JHNewShopDetailTabBarView.m
//  TTjianbao
//
//  Created by hao on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailTabBarView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHNewShopDetailTabBarView ()
@property (nonatomic, strong) UIButton *selectedTabBarBtn;

@end

@implementation JHNewShopDetailTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    UIView *bottomNavView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [bottomNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    NSArray *tabTitleArray = @[@"首页",@"分类",@"客服"];
    NSArray *tabIconArray = @[@"newStore_shopDetail_tabBar_home_icon",@"newStore_shopDetail_tabBar_class_icon",@"newStore_shopDetail_tabBar_service_icon"];
    NSArray *tabSelectedIconArray = @[@"newStore_shopDetail_tabBar_home_selected_icon",@"newStore_shopDetail_tabBar_class_selected_icon",@"newStore_shopDetail_tabBar_service_selected_icon"];
    if (!_selectedTabBarBtn) {
        _selectedTabBarBtn = [[UIButton alloc] init];
    }
    for (int i = 0; i < tabTitleArray.count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setTitle:tabTitleArray[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [itemBtn setImage:JHImageNamed(tabIconArray[i]) forState:UIControlStateNormal];
        [itemBtn setImage:JHImageNamed(tabSelectedIconArray[i]) forState:UIControlStateSelected];
        itemBtn.titleLabel.font = JHFont(10);
        itemBtn.tag = 100+i;
        [itemBtn addTarget:self action:@selector(clickBottomTabBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomNavView addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomNavView);
            make.centerX.equalTo(bottomNavView).offset(-ScreenWidth/3 + i*ScreenWidth/3);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3-20, 50));
        }];
        [itemBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];

        //默认第一个标签选中，且不可点击
        if (i == 0) {
            itemBtn.selected = YES;
            itemBtn.userInteractionEnabled = NO;
            self.selectedTabBarBtn = itemBtn;
        }else{
            itemBtn.selected = NO;
        }
    }
}

- (void)clickBottomTabBarAction:(UIButton *)sender{
    NSInteger tagIndex = sender.tag - 100;
    //按钮选择互斥，且不能重复选择
    if (tagIndex < 2) {
        self.selectedTabBarBtn.selected = NO;
        self.selectedTabBarBtn.userInteractionEnabled = YES;
        sender.selected = YES;
        sender.userInteractionEnabled = NO;
        self.selectedTabBarBtn = sender;
    }
    
    if (self.tabBarSelectedBlock) {
        self.tabBarSelectedBlock([NSNumber numberWithInteger:tagIndex]);
    }
    
}

@end
