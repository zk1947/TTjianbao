//
//  JHMyCenterStoneReSaleCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterStoneReSaleCell.h"
#import "JHMyCenterCollectionView.h"
@interface JHMyCenterStoneReSaleCell ()

@property (nonatomic, copy) JHMyCenterCollectionView *listView;

@end

@implementation JHMyCenterStoneReSaleCell

- (void)addSelfSubViews{
    
    self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    UILabel *label = [UILabel jh_labelWithBoldFont:15 textColor:RGB(51,51,51) addToSuperView:whiteView];
    label.text = @"原石回血";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(12.f);
        make.top.equalTo(whiteView).offset(16.f);
    }];
    
    UIImageView *imageIconView = [UIImageView jh_imageViewWithImage:@"my_center_switch_push" addToSuperview:whiteView];
    [imageIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-8);
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"查看原石订单" fontSize:12 textColor:RGB(102,102,102) target:self action:@selector(moreAction) addToSuperView:whiteView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageIconView.mas_left).offset(-4.f);
        make.centerY.equalTo(imageIconView);
        make.height.mas_equalTo(35);
    }];
    
    _listView = [JHMyCenterCollectionView new];
    _listView.count = 5;
    [self.contentView addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(whiteView).offset(35.f);
        make.height.mas_equalTo(140);
    }];
}

-(void)setButtonArray:(NSMutableArray<JHMyCenterMerchantCellButtonModel *> *)buttonArray{
    _buttonArray = buttonArray;
    
    self.listView.buttonArray = _buttonArray;
}

-(void)moreAction {
    JHRouterModel* router = [JHRouterModel new];
    router.vc = @"JHOrderListViewController";
    router.type = @(JHRouterTypeParams).stringValue;
    router.params = @{@"isSeller" : @YES};
    [JHRouters gotoPageByModel:router];
}

@end
