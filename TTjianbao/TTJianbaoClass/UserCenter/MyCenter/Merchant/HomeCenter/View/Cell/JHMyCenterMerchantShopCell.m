//
//  JHMyCenterShopCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantShopCell.h"
#import "JHMyCenterCollectionView.h"
@interface JHMyCenterMerchantShopCell ()

@property (nonatomic, copy) JHMyCenterCollectionView *listView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHMyCenterMerchantShopCell

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title isNotBlank]) {
        _titleLabel.text = _title;
    }
}

- (void)addSelfSubViews{
    
    self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    UILabel *label = [UILabel jh_labelWithBoldFont:15 textColor:RGB(51,51,51) addToSuperView:whiteView];
    label.text = @"店铺工具";
    _titleLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(10.f);
        make.top.equalTo(whiteView).offset(10.f);
    }];
    
    _listView = [JHMyCenterCollectionView new];
    [self.contentView addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(whiteView).offset(35.f);
        make.height.mas_equalTo(210);
    }];
}

-(void)setButtonArray:(NSMutableArray<JHMyCenterMerchantCellButtonModel *> *)buttonArray{
    _buttonArray = buttonArray;
    if (buttonArray.count > 12) {
        [_listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(280);
        }];
    }
    self.listView.buttonArray = _buttonArray;
}
@end
