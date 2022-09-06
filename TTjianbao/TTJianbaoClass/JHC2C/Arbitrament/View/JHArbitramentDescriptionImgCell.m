//
//  JHArbitramentDescriptionImgCell.m
//  TTjianbao
//
//  Created by lihui on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHArbitramentDescriptionImgCell.h"

@interface JHArbitramentDescriptionImgCell ()
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@end


@implementation JHArbitramentDescriptionImgCell

- (void)setImageSource:(UIImage *)imageSource {
    if (imageSource == nil) {
        _imgView.hidden = YES;
    }
    else {
        _imgView.hidden = NO;
        _imageSource = imageSource;
        _imgView.image = imageSource;
    }
    
    _addImageView.hidden = !_imgView.hidden;
    _label.hidden = !_imgView.hidden;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arbitrament_add"]];
    addImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:addImageView];
    _addImageView = addImageView;
    
    UILabel *label = [UILabel jh_labelWithFont:12.f textColor:kColor999 addToSuperView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"(最多6张)";
    _label = label;
    
    _imgView = [UIImageView jh_imageViewWithImage:kDefaultCoverImage addToSuperview:self.contentView];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.hidden = YES;

    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(28., 28.));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addImageView.mas_bottom).offset(3);
        make.left.right.equalTo(self.contentView);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


@end
