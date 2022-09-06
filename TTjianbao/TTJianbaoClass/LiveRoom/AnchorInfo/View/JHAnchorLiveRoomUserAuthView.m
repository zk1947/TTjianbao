//
//  JHAnchorLiveRoomUserAuthView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAnchorLiveRoomUserAuthView.h"

@interface JHAnchorLiveRoomUserAuthView ()

@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, weak) UILabel *resetLabel;

/// 用户需要上传的
@property (nonatomic, weak) UIImageView *leftImageView;

/// 用户上传的样例
@property (nonatomic, weak) UIImageView *rightImageView;

@end

@implementation JHAnchorLiveRoomUserAuthView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_BACKGROUND_COLOR;
        [self addSelfSubViews];
    }
    return self;
}


- (void)addSelfSubViews {
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 15, 0, 15));
    }];
    
    UILabel *label = [UILabel jh_labelWithText:@"*" font:13 textColor:RGB(240, 61, 55) textAlignment:1 addToSuperView:self];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(whiteView).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    _tipLabel = [UILabel jh_labelWithText:@"身份证人像面" font:13 textColor:RGB515151 textAlignment:1 addToSuperView:self];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(2);
        make.centerY.height.equalTo(label);
    }];
    
    UILabel *label2 = [UILabel jh_labelWithText:@"（照片需清晰可见，无水印）" font:12 textColor:RGB153153153 textAlignment:1 addToSuperView:self];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel.mas_right).offset(2);
        make.centerY.height.equalTo(label);
    }];
    
    UIImageView *tipImageView = [UIImageView jh_imageViewWithImage:@"common_camera" addToSuperview:self];
    
    UILabel *label3 = [UILabel jh_labelWithText:@"点击上传" font:12 textColor:RGB(204,204,204) textAlignment:1 addToSuperView:self];
    
    _leftImageView = [UIImageView jh_imageViewAddToSuperview:self];
    [_leftImageView jh_cornerRadius:5 borderColor:RGB(238, 238, 238) borderWidth:1];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(10);
        make.bottom.equalTo(whiteView).offset(-10);
        make.top.equalTo(whiteView).offset(38);
        make.right.equalTo(whiteView.mas_centerX).offset(-2.5);
    }];
    
    _rightImageView = [UIImageView jh_imageViewAddToSuperview:self];
    [_rightImageView jh_cornerRadius:5 borderColor:RGB(238, 238, 238) borderWidth:1];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-10);
        make.left.equalTo(whiteView.mas_centerX).offset(2.5);
        make.bottom.height.equalTo(self.leftImageView);
    }];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leftImageView.mas_centerY);
        make.centerX.equalTo(self.leftImageView);
        make.size.mas_equalTo(CGSizeMake(24,20));
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipImageView.mas_bottom).offset(5);
        make.centerX.equalTo(tipImageView);
        make.height.mas_equalTo(17);
    }];
    
    _resetLabel = [UILabel jh_labelWithText:@"重新上传" font:11 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self.leftImageView];
    _resetLabel.backgroundColor = RGBA(117, 117, 120, 0.6);
    _resetLabel.hidden = YES;
    [_resetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.leftImageView);
        make.height.mas_equalTo(22);
    }];
    
    @weakify(self);
    [_leftImageView jh_addTapGesture:^{
        @strongify(self);
        if(self.clickBlock && _reCommit) {
            self.clickBlock();
        }
    }];
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    switch (_type) {
        case 0:
        {
            _tipLabel.text = @"身份证人像面";
            _rightImageView.image = JHImageNamed(@"my_center_userauth_card_0");
        }
            break;
            
        case 1:
        {
            _tipLabel.text = @"身份证国徽面";
            _rightImageView.image = JHImageNamed(@"my_center_userauth_card_1");
        }
            break;
            
        default:
            _tipLabel.text = @"";
            break;
    }
}

- (void)setUploadImage:(id)uploadImage {
    _uploadImage = uploadImage;
    if([_uploadImage isKindOfClass:[NSString class]]) {
        [_leftImageView jh_setImageWithUrl:(NSString *)uploadImage];
        _resetLabel.hidden = !_reCommit;
    }
    else if([_uploadImage isKindOfClass:[UIImage class]]) {
        _leftImageView.image = uploadImage;
        _resetLabel.hidden = !_reCommit;
    }
    else {
        _resetLabel.hidden = YES;
        _leftImageView.image = nil;
    }
}


+ (CGFloat)viewHeight {
    
    return 55 + (100.f / 160.f) * ((ScreenW - 55) / 2.0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
