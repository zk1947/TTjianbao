//
//  JHCustomerCerAddImgTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCerAddImgTableViewCell.h"
#import "NSObject+Cast.h"
//#import "JHImagePickerPublishManager.h"

@interface JHCustomerCerAddImgTableViewCell ()
@property (nonatomic, strong) UIImageView *cerImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel     *addLabel;
@end

@implementation JHCustomerCerAddImgTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _cerImageView = [[UIImageView alloc] init];
    _cerImageView.layer.cornerRadius  = 8.f;
    _cerImageView.layer.masksToBounds = YES;
    _cerImageView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_cerImageView];
    [_cerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f));
//        make.height.mas_equalTo((ScreenW - 30.f)/1.5f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(230.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = [UIImage imageNamed:@"customize_cer_add"];
    [_cerImageView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cerImageView.mas_centerX);
        make.top.equalTo(self.cerImageView.mas_top).offset(72.f);
        make.width.mas_equalTo(58.f);
        make.height.mas_equalTo(50.f);
    }];
    
    _addLabel               = [[UILabel alloc] init];
    _addLabel.text          = @"添加证书";
    _addLabel.textColor     = HEXCOLOR(0x999999999);;
    _addLabel.textAlignment = NSTextAlignmentCenter;
    _addLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    [_cerImageView addSubview:_addLabel];
    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cerImageView.mas_centerX);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(15.f);
        make.height.mas_equalTo(21.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    UIImage *image = [UIImage cast:viewModel];
    if (image) {
        self.cerImageView.image = image;
        self.cerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.logoImageView.hidden = YES;
        self.addLabel.hidden = YES;
    } else {
        self.cerImageView.image = [UIImage imageNamed:@"customize_apply_camera"];
        self.cerImageView.contentMode = UIViewContentModeCenter;
        self.logoImageView.hidden = NO;
        self.addLabel.hidden = NO;
    }
}

@end
