//
//  JHAudienceLiveCoverView.h
//  TTjianbao
//
//  Created by jiang on 2019/8/6.
//  Copyright © 2019 Netease. All rights reserved.

#import "JHAudienceLiveCoverView.h"
#import "UIView+NTES.h"
#import "UIImage+GIF.h"
#import "UIImage+Blur.h"
#import "TTjianbaoHeader.h"

@interface JHAudienceLiveCoverView ()


@property (nonatomic, strong) UIImageView *backImage;


@end

@implementation JHAudienceLiveCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = HEXCOLOR(0xdfe2e6);
//        UIImage *img = [JHAudienceLiveCoverView tg_blurryImage:[UIImage imageNamed:@"img_back_cover"] withBlurLevel:5];
        UIImage *img = [UIImage imageNamed:@"andience_live_cover1"];
        self.backImage.image = img;
        [self addSubview:self.backImage];
        
     
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
   
}


- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.frame = self.frame;
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.clipsToBounds = YES;
        
    }
    return _backImage;
}
- (void)setCoverImage:(NSString *)url {
//    UIImage *img = [JHAudienceLiveCoverView tg_blurryImage:[UIImage imageNamed:@"img_back_cover"] withBlurLevel:5];
//
//    if (url) {
//        JH_WEAK(self)
//        [self.backImage jhSetImageWithURL:[NSURL URLWithString:url] placeholder:img completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
//            JH_STRONG(self)
//            if (image) {
//                self.backImage.image = [JHAudienceLiveCoverView tg_blurryImage:image withBlurLevel:5];
//            }
//        }];
//
//    }
//    else{
//
//          self.backImage.image = img;
//    }
    
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

