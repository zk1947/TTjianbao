//
//  JHUploadImgView.m
//  TTjianbao
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUploadImgView.h"
#import "UIView+JHShadow.h"

@interface JHUploadImgView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation JHUploadImgView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)uploadImageAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadImage)]) {
        [self.delegate uploadImage];
    }
}

- (void)cancelSelectImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelect)]) {
        [self.delegate cancelSelect];
    }
}

- (void)initSubviews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    
    _bottomView = [[UIImageView alloc] init];
    _bottomView.backgroundColor = HEXCOLOR(0xEEEEEE);
    _bottomView.image = [UIImage imageNamed:@"icon_company_line"];
    _bottomView.userInteractionEnabled = YES;
 
    _addImageView = [[UIImageView alloc] init];
    _addImageView.image = [UIImage imageNamed:@""];
    
    _alertLabel = [[UILabel alloc] init];
    _alertLabel.text = @"";
    _alertLabel.font = [UIFont fontWithName:kFontMedium size:12];
    _alertLabel.textColor = HEXCOLOR(0xBBBBBB);
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    
    _bottomLabel = [[UILabel alloc] init];
    _bottomLabel.text = @"";
    _bottomLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _bottomLabel.textColor = HEXCOLOR(0x999999);
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setImage:[UIImage imageNamed:@"icon_image_cancel"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelSelectImage) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.hidden = YES;
    
    _selectImageView = [[UIImageView alloc] init];
    _selectImageView.backgroundColor = [UIColor clearColor];
    _selectImageView.userInteractionEnabled = YES;
    _selectImageView.image = [UIImage imageNamed:@""];
    _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    _selectImageView.userInteractionEnabled = YES;
     UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImageAction)];
     [_selectImageView addGestureRecognizer:tapGR];
        
    [self addSubview:_titleLabel];
    [self addSubview:_bottomView];
    [_bottomView addSubview:_addImageView];
    [_bottomView addSubview:_alertLabel];
    [self addSubview:_bottomLabel];
    [_bottomView addSubview:_selectImageView];
    [_bottomView addSubview:_cancelButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(17);
        make.top.equalTo(self).with.offset(13);
        make.height.equalTo(@21);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self);
        make.width.equalTo(@282);
        make.height.equalTo(@184);
    }];

    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@32);
        make.centerX.equalTo(self.bottomView);
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(-4);
    }];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.addImageView.mas_bottom).offset(10);
    }];
        
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView.mas_bottom).offset(10);
    }];
    
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(18);
        make.bottom.equalTo(self.bottomView).offset(-18);
        make.width.equalTo(self.bottomView.mas_height);
        make.centerX.equalTo(self.bottomView);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).with.offset(11);
        make.right.equalTo(self.bottomView).with.offset(-11);
        make.width.height.equalTo(@20);
    }];
    
    [self layoutIfNeeded];
//    _bottomView.layer.cornerRadius = 5.f;
//    _bottomView.layer.masksToBounds = YES;

}

- (void)setClipCorner:(BOOL)clipCorner {
    _clipCorner = clipCorner;
    if (_clipCorner) {
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setAddImageName:(NSString *)addImageName {
    _addImageName = addImageName;
    _addImageView.image = [UIImage imageNamed:_addImageName];
}

- (void)setAlertString:(NSString *)alertString {
    _alertString = alertString;
    _alertLabel.text = _alertString;
}

- (void)setBottomAlertString:(NSString *)bottomAlertString {
    _bottomAlertString = bottomAlertString;
    _bottomLabel.text = _bottomAlertString;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _addImageView.hidden = isSelected;
    _alertLabel.hidden = isSelected;
    _cancelButton.hidden = !isSelected;
}

@end
