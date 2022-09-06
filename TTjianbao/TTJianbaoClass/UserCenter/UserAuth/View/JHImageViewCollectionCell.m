//
//  JHImageViewCollectionCell.m
//  TTjianbao
//
//  Created by lihui on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageViewCollectionCell.h"
@interface JHImageViewCollectionCell ()
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *cameraImageView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation JHImageViewCollectionCell

- (void)setUploadImage:(id)uploadImage {
    if (!uploadImage) {
        return;
    }
    _uploadImage = uploadImage;
    if([uploadImage isKindOfClass:[NSString class]]) {
        [_imgView jh_setImageWithUrl:(NSString *)uploadImage];
    }
    else if([_uploadImage isKindOfClass:[UIImage class]]) {
        _imgView.image = uploadImage;
    }
}

- (void)setCellType:(JHImageViewCollectionCellType)cellType {
    _cellType = cellType;
    if (_cellType == JHImageViewCollectionCellTypeImage) {
        ///显示图片
        _imgView.hidden = NO;
        _cameraImageView.hidden = YES;
        _tipLabel.hidden = YES;
        _borderView.hidden = YES;
    }
    else {
        _imgView.hidden = YES;
        _cameraImageView.hidden = NO;
        _tipLabel.hidden = NO;
        _borderView.hidden = NO;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.cornerRadius = 5.f;
    _imgView.layer.masksToBounds = YES;
    _imgView.userInteractionEnabled = YES;

    _borderView = [[UIView alloc] init];
    _borderView.layer.borderColor = kColorEEE.CGColor;
    _borderView.layer.borderWidth = 1.f;
    _borderView.layer.cornerRadius = 5.f;
    _borderView.layer.masksToBounds = YES;
    
    _cameraImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _cameraImageView.contentMode = UIViewContentModeScaleAspectFit;
    _cameraImageView.image = [UIImage imageNamed:@"common_camera"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"点击上传";
    label.font = [UIFont fontWithName:kFontNormal size:12.];
    label.textColor = kColorCCC;
    label.textAlignment = NSTextAlignmentCenter;
    _tipLabel = label;
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"icon_user_auth_delete"] forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"icon_user_auth_delete"] forState:UIControlStateHighlighted];
    [_deleteButton addTarget:self action:@selector(deleteSelectImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_imgView];
    [self.contentView addSubview:_borderView];
    [self.contentView addSubview:_cameraImageView];
    [self.contentView addSubview:label];
    [self.imgView addSubview:_deleteButton];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView).offset(-4);
        make.top.equalTo(self.imgView).offset(4);
        make.size.mas_equalTo(CGSizeMake(16., 16.));
    }];
    
    [_cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24., 20));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.cameraImageView.mas_bottom).offset(5);
    }];
}

- (void)deleteSelectImage {
    if (self.cellType == JHImageViewCollectionCellTypeUpload) {
        return;
    }
    if (self.deleteBlock) {
        self.deleteBlock(self.uploadImage);
    }
}

- (void)setHiddenDeleteBUtton:(BOOL)hiddenDeleteBUtton {
    self.deleteButton.hidden = hiddenDeleteBUtton;
}

@end
