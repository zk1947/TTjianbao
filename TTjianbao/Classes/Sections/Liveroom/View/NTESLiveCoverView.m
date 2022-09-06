//
//  NTESLiveCoverView.m
//  TTjianbao
//
//  Created by chris on 16/3/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveCoverView.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "NTESDataManager.h"
#import "UIView+NTES.h"
#import "UIImage+GIF.h"
#import "UIImage+Blur.h"
#import "TTjianbaoHeader.h"

@interface NTESLiveCoverView ()

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) NIMAvatarImageView *avatar;
@property (nonatomic,strong) UIImageView *loadGifImage;

@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic, strong) UIImageView *backImage;


@end

@implementation NTESLiveCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = HEXCOLOR(0xdfe2e6);
        UIImage *img = [NTESLiveCoverView tg_blurryImage:[UIImage imageNamed:@"img_back_cover"] withBlurLevel:5];
       
        self.backImage.image = img;
        [self addSubview:self.backImage];
        

        
         [self addSubview:self.statusLabel];
        
        [self.backButton setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:self.backButton];
    }
    return self;
}

- (void)refreshWithChatroom:(NSString *)roomId
                     status:(NTESLiveCoverStatus)status
{
    switch (status) {
        case NTESLiveCoverStatusLinking:
            self.statusLabel.text  = @"";//@"连接中,请等待";
            self.backButton.hidden = YES;
            self.loadGifImage.hidden = NO;
            break;
        case NTESLiveCoverStatusFinished:
            self.statusLabel.text  = @"";//@"直播已结束";
            self.backButton.hidden = [NTESLiveManager sharedInstance].role == NTESLiveRoleAudience;
            self.loadGifImage.hidden = YES;

            break;
        default:
            break;
    }
    [self.statusLabel sizeToFit];
    self.loadGifImage.hidden = YES;
    
    __weak typeof(self) wself = self;
    
    [[NTESLiveManager sharedInstance] anchorInfo:roomId handler:^(NSError *error, NIMChatroomMember *anchor) {
        wself.nameLabel.text = anchor.roomNickname;
        [wself.nameLabel sizeToFit];
        [wself.avatar nim_setImageWithURL:[NSURL URLWithString:anchor.roomAvatar] placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.avatar.bottom  = self.height * .5f - 100.f;
//    self.avatar.centerX = self.width * .5f;
//    self.nameLabel.centerX = self.width * .5f;
//    self.nameLabel.top  = self.avatar.bottom + 7.f;
//    self.statusLabel.centerY = self.height * .5f - 18.f;
//    self.statusLabel.centerX = self.width * .5f;
    
//    [self.loadGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(60,75));
//    }];
//    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.loadGifImage.mas_bottom).offset(5);
//    }];
}

- (void)didPressBack:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didPressBackButton)]) {
        [self.delegate didPressBackButton];
    }
}

#pragma mark - Get


- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.frame = self.frame;
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.clipsToBounds = YES;

    }
    return _backImage;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _statusLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.size = CGSizeMake(ScreenW, 20);
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
        _nameLabel.textColor = HEXCOLOR(0x2a2d2c);
        _nameLabel.text = @"123";
    }
    return _nameLabel;
}

- (NIMAvatarImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _avatar.backgroundColor = [UIColor grayColor];
    }
    return _avatar;
}
-(UIImageView *)loadGifImage{
    
    if (!_loadGifImage) {
        _loadGifImage= [[UIImageView alloc]init ];
         _loadGifImage.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _loadGifImage;
}
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImageNormal = [[UIImage imageNamed:@"bg_selected_yellow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImage *backgroundImageHighlighted = [[UIImage imageNamed:@"bg_selected_yellow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        [_backButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
        [_backButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(didPressBack:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _backButton.size = CGSizeMake(215, 46);
        _backButton.centerX = self.width * .5f;
        _backButton.bottom  = self.height - 80.f;
        _backButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return _backButton;
}



- (void)setCoverImage:(NSString *)url {
    UIImage *img = [NTESLiveCoverView tg_blurryImage:[UIImage imageNamed:@"img_back_cover"] withBlurLevel:5];

    if (url) {
        JH_WEAK(self)
        [self.backImage jhSetImageWithURL:[NSURL URLWithString:url] placeholder:img  completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                self.backImage.image = [NTESLiveCoverView tg_blurryImage:image withBlurLevel:5];
            }
        }];

    }
}

+ (UIImage *)tg_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (image == nil) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //设置模糊程度
    [filter setValue:@(blur) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

@end
