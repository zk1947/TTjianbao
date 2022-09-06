//
//  JHShopwindowGoodsAlert.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopwindowGoodsAlert.h"

@interface JHShopwindowGoodsAlert ()

@property (nonatomic, weak) UIImageView *picView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@end


@implementation JHShopwindowGoodsAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews
{
    self.image = JHImageNamed(@"live_room_shopwindow_alert");
    
    _picView = [UIImageView jh_imageViewAddToSuperview:self];
    [_picView jh_cornerRadius:8];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(5);
        make.height.width.mas_equalTo(61);
    }];
    
    _titleLabel = [UILabel jh_labelWithFont:15 textColor:UIColor.blackColor addToSuperView:self];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView).offset(10);
        make.left.equalTo(self.picView.mas_right).offset(10);
        make.right.equalTo(self).offset(-30);
    }];
    
    _priceLabel = [UILabel jh_labelWithFont:15 textColor:RGB(252, 66, 0) addToSuperView:self];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self).offset(-10);
    }];
}

+ (CGSize)viewSize
{
    return CGSizeMake(228, 77);
}
+ (JHShopwindowGoodsAlert *)showWithModel:(JHShopwindowGoodsListModel *)model
{
    JHShopwindowGoodsAlert *alert = [JHShopwindowGoodsAlert new];
    alert.titleLabel.text = model.title;
    alert.priceLabel.attributedText = [model.priceWrapper showPrice];
    [alert.picView jh_setImageWithUrl:model.listImage];
    return alert;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
