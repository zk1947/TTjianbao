//
//  JHCustomizeLinkShowOrderView.m
//  TTjianbao
//
//  Created by apple on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeLinkShowOrderView.h"
#import "JHStoneMessageModel.h"
#import "JHCustomerDescInProcessViewController.h"

@interface JHCustomizeLinkShowOrderView()
@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong)JHSystemMsgCustomizeOrder *model;
@end

@implementation JHCustomizeLinkShowOrderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
        [self jh_cornerRadius:8];
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews
{
    UIImageView *tipimage = [UIImageView jh_imageViewAddToSuperview:self];
    tipimage.image = [UIImage imageNamed:@"customizeLinkShowTip"];
    [tipimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(9);
        make.height.width.mas_equalTo(11);
    }];
    self.tipLabel = [UILabel jh_labelWithBoldFont:12 textColor:HEXCOLOR(0x333333) addToSuperView:self];
    self.tipLabel.text = @"正在沟通的定制服务";
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipimage.mas_right).offset(3);
        make.top.equalTo(self).offset(6);
        make.height.height.mas_equalTo(17);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(29);
        make.height.height.mas_equalTo(1);
    }];
    
    _picView = [UIImageView jh_imageViewAddToSuperview:self];
    [_picView jh_cornerRadius:8];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(5);
        make.left.equalTo(self).offset(5);
        make.height.width.mas_equalTo(50);
    }];
    
    _titleLabel = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0x333333) addToSuperView:self];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView).offset(5);
        make.left.equalTo(self.picView.mas_right).offset(5);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    _priceLabel = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0x999999) addToSuperView:self];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.picView.mas_right).offset(5);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(17);
    }];
}
- (void)showViewWithModel:(JHSystemMsgCustomizeOrder *)model{
    self.model = model;
    [_picView jh_setImageWithUrl:model.customizeImg];
    _titleLabel.text = model.customizeOrderName;
    _priceLabel.text = [NSString stringWithFormat:@"定制类别：%@",model.customizedFeeName];
    _tipLabel.text = model.tip;
}
- (void)orderClick{
//    if (_model.showFlag || self.isSeller) {
        JHCustomerDescInProcessViewController * detail = [[JHCustomerDescInProcessViewController alloc]init];
        detail.customizeOrderId = self.model.orderId;
        [[JHRootController currentViewController].navigationController pushViewController:detail animated:YES];
        
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
