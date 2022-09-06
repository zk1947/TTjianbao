//
//  JHMyCenterAppraiserViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterAppraiserViewCell.h"
#import "JHMyCenterButtonModel.h"

@interface JHMyCenterAppraiserViewCell ()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation JHMyCenterAppraiserViewCell

-(void)addSelfSubViews
{
    _iconView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    _descLabel = [UILabel jh_labelWithFont:16 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10.f);
        make.centerY.equalTo(self.iconView);
    }];
    
    UIImageView *pushIcon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_push_gray" addToSuperview:self.contentView];
    [pushIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];   
}

+ (CGFloat)cellHeight
{
    return 48.f;
}

- (void)setModel:(JHMyCenterButtonModel *)model{
    
    _descLabel.text = model.name;
    _iconView.image = JHImageNamed(model.icon);
}
@end
