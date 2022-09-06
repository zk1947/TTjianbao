//
//  JHMyCenterRecycleTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/4/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterRecycleTableCell.h"
#import "JHMyCenterCollectionView.h"
#import "JHRecycleSquareHomeViewController.h"
#import "JHMyCenterDotModel.h"

@interface JHMyCenterRecycleTableCell ()
@property (nonatomic, copy) JHMyCenterCollectionView *listView;
@property (nonatomic, strong) UIView *recycleView;
@property (nonatomic, strong) UILabel *recyclcLabel;
@end

@implementation JHMyCenterRecycleTableCell

- (void)setShowRecycleSquare:(BOOL)showRecycleSquare {
    _showRecycleSquare = showRecycleSquare;
    _recycleView.hidden = !showRecycleSquare;
}

- (void)addSelfSubViews {
    self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 12, 5, 12));
    }];
    
    UILabel *label = [UILabel jh_labelWithBoldFont:15 textColor:RGB(51,51,51) addToSuperView:whiteView];
    label.text = @"回收订单管理";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(10.f);
        make.top.equalTo(whiteView).offset(10.f);
    }];
    
    UIImageView *imageIconView = [UIImageView jh_imageViewWithImage:@"my_center_switch_push" addToSuperview:whiteView];
    [imageIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-8);
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"查看全部订单" fontSize:12 textColor:RGB(102,102,102) target:self action:@selector(moreAction) addToSuperView:whiteView];
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
        make.height.mas_equalTo([JHMyCenterCollectionViewCell itemSize].height);
    }];
    
    UIView *recycle = [[UIView alloc] init];
    recycle.backgroundColor = HEXCOLORA(0xFFD70F, .1f);
    [whiteView addSubview:recycle];
    recycle.layer.cornerRadius = 6.f;
    recycle.layer.masksToBounds = YES;
    _recycleView = recycle;
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.image = [UIImage imageNamed:@"icon_mycenter_recycle_bag"];
    [recycle addSubview:icon];
    
    UILabel *recyclcLabel = [[UILabel alloc] init];
    recyclcLabel.text = @"去回收广场看看";
    recyclcLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    recyclcLabel.textColor = kColor222;
    [recycle addSubview:recyclcLabel];
    _recyclcLabel = recyclcLabel;
    
    UIButton *seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeButton setTitle:@"去看看" forState:UIControlStateNormal];
    seeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11.];
    [seeButton setTitleColor:kColor333 forState:UIControlStateNormal];
    [seeButton addTarget:self action:@selector(enterRecycleSquare) forControlEvents:UIControlEventTouchUpInside];
    seeButton.layer.cornerRadius = 12.f;
    seeButton.layer.masksToBounds = YES;
    seeButton.layer.borderColor = kColor333.CGColor;
    seeButton.layer.borderWidth = .5f;
    [recycle addSubview:seeButton];
    
    [recycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView).offset(-12);
        make.left.equalTo(whiteView).offset(12);
        make.right.equalTo(whiteView).offset(-12);
        make.height.mas_equalTo(40);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recycle).offset(12);
        make.centerY.equalTo(recycle);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    [recyclcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(5);
        make.centerY.equalTo(recycle);
    }];
    
    [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(recycle).offset(-12);
        make.centerY.equalTo(recycle);
        make.size.mas_equalTo(CGSizeMake(49, 24));
    }];
}

- (void)enterRecycleSquare {
    JHRecycleSquareHomeViewController *vc = [[JHRecycleSquareHomeViewController alloc] init];
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}

-(void)setButtonArray:(NSMutableArray<JHMyCenterMerchantCellButtonModel *> *)buttonArray {
    _buttonArray = buttonArray;
    self.listView.buttonArray = _buttonArray;
    
    NSInteger recycleCount = [JHMyCenterDotModel shareInstance].recyclePoolCount;
    if (recycleCount > 0) {
        _recyclcLabel.text = [NSString stringWithFormat:@"您有%ld个回收商品待查看", (long)recycleCount];
    }
    else {
        _recyclcLabel.text = @"去回收广场看看";
    }
}

-(void)moreAction {
    JHRouterModel* router = [JHRouterModel new];
    router.vc = @"JHWebViewController";
    router.type = @(JHRouterTypeParams).stringValue;
    router.params = @{@"urlString" : MerchantRecyleDetailURL(@"0", @"1")};
    [JHRouters gotoPageByModel:router];
}

@end
