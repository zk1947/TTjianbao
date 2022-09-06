//
//  JHFoucsShopListInfoCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsShopListInfoCell.h"
#import "JHSellerInfo.h"
#import "JHFoucsListShopViewModel.h"
@interface JHFoucsShopListInfoCell ()

@property (nonatomic, weak) UIImageView *avatorImage;

@property (nonatomic, weak) UILabel *nickNameLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *foucsButton;

@end

@implementation JHFoucsShopListInfoCell

-(void)addSelfSubViews
{
    _avatorImage = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_avatorImage jh_cornerRadius:18];
    [_avatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(36);
    }];
    
    _nickNameLabel = [UILabel jh_labelWithFont:15 textColor:[UIColor blackColor] addToSuperView:self.contentView];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatorImage.mas_right).offset(10.f);
        make.top.equalTo(_avatorImage).offset(2);
        make.width.mas_lessThanOrEqualTo(ScreenW-130.f);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:11 textColor:RGB(153, 153, 153) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.bottom.equalTo(self.avatorImage);
        make.width.mas_lessThanOrEqualTo(ScreenW-130.f);
    }];
    
    _foucsButton = [UIButton jh_buttonWithTitle:@"关注" fontSize:12 textColor:RGB(153, 153, 153) target:self action:@selector(foucsMethod) addToSuperView:self.contentView];
    [_foucsButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_foucsButton jh_cornerRadius:13 borderColor:RGB(153, 153, 153) borderWidth:1];
    [_foucsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatorImage);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(62, 26));
    }];
}

///是否关注
- (void)changeButtonStatus {
    BOOL isFocus = (_model.followed.intValue == 1);
    _foucsButton.selected = isFocus;
    if (isFocus) {
        _foucsButton.backgroundColor = [UIColor clearColor];
        _foucsButton.layer.borderColor = [RGB(233, 233, 233) CGColor];
        _foucsButton.layer.borderWidth = 1.f;
    }
    else {
        _foucsButton.backgroundColor = HEXCOLOR(0xFEE100);
        _foucsButton.layer.borderColor = [HEXCOLOR(0xFEE100) CGColor];
        _foucsButton.layer.borderWidth = 1.f;
    }
}

-(void)foucsMethod
{
    [JHFoucsListShopViewModel foucsShopWithModel:_model completeBlock:^{
        [self setModel:_model];
    }];
}

-(void)setModel:(JHFoucsShopInfo *)model
{
    if (!model) {
        return;
    }
    _model = model;
    
    [_avatorImage jh_setAvatorWithUrl:_model.shopLogoImg];
    
    _nickNameLabel.text = _model.shopName;
    
    _descLabel.text = [NSString stringWithFormat:@"%@件商品 | %@个粉丝", _model.productNum, @(_model.followNum)];
    
//    _descLabel.text = [_model.productNum stringByReplacingOccurrencesOfString:@"%s" withString:[NSString stringWithFormat:@"%@", @(_model.followNum)]];;
    
    [self changeButtonStatus];
}

-(void)updateUI
{
    _descLabel.text = @"5件商品 | 6个粉丝";
    
    _nickNameLabel.text = @"娃哈哈";
    
    [_avatorImage jh_setAvatorWithUrl:@"http://sq-image.ttjianbao.com/images/b7af4b7fae567711848eb26eea715abc.png?x-oss-process=image/resize,w_100"];
}
@end
