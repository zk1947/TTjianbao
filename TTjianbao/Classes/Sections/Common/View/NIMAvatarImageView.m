//
//  NIMAvatarImageView.m
//  NIMKit
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMAvatarImageView.h"
#import "UIView+NTES.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import <SDImageCache.h>
#import "UIView+WebCache.h"

@interface NIMAvatarImageView()
@end

@implementation NIMAvatarImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
    }
    return self;
}


- (void)setImage:(UIImage *)image {
    if (_image != image)
    {
        _image = image;
        [self setNeedsDisplay];
    }
}

- (void)setIsShowBorder:(BOOL)isShowBorder {
    _isShowBorder = isShowBorder;
    [self setNeedsDisplay];
}

- (CGPathRef)path {
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                       cornerRadius:CGRectGetWidth(self.bounds) / 2] CGPath];
}


#pragma mark Draw
- (void)drawRect:(CGRect)rect
{
    if (!self.width || !self.height) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    if (_clipPath)
    {
        CGContextAddPath(context, [self path]);
        CGContextClip(context);
    }
    UIImage *image = _image;
    if (image && image.size.height && image.size.width)
    {
        //ScaleAspectFill模式
        CGPoint center   = CGPointMake(self.width * .5f, self.height * .5f);
        //哪个小按哪个缩
        CGFloat scaleW   = image.size.width  / self.width;
        CGFloat scaleH   = image.size.height / self.height;
        CGFloat scale    = scaleW < scaleH ? scaleW : scaleH;
        CGSize  size     = CGSizeMake(image.size.width / scale, image.size.height / scale);
        CGRect  drawRect = NIMKit_CGRectWithCenterAndSize(center, size);
        CGContextDrawImage(context, drawRect, image.CGImage);
        

        
        if (self.isShowBorder) {
            CGContextSetStrokeColorWithColor(context, HEXCOLOR(0xfee100).CGColor);
            CGContextSetLineWidth(context, 2);
            CGContextAddArc(context, self.width/2., self.height/2., self.width/2.-1, 0, 2*M_PI, 0);
            CGContextDrawPath(context, kCGPathStroke);

        }
        

    }
    CGContextRestoreGState(context);
}

CGRect NIMKit_CGRectWithCenterAndSize(CGPoint center, CGSize size){
    return CGRectMake(center.x - (size.width/2), center.y - (size.height/2), size.width, size.height);
}

@end


@implementation NIMAvatarImageView (SDWebImageCache)

- (void)nim_setImageWithURL:(NSURL *)url {
    [self nim_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self nim_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self nim_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)nim_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self nim_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self nim_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self nim_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    
    [self sd_internalSetImageWithURL:url placeholderImage:placeholder options:options context:nil setImageBlock:nil progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        self.image = image;
    }];
//    [self sd_internalSetImageWithURL:url placeholderImage:placeholder options:options operationKey:nil setImageBlock:nil progress:progressBlock completed:completedBlock context:nil];
}

- (void)nim_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSString *key = [SDWebImageManager.sharedManager cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:key];
    
    [self nim_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)nim_imageURL {
    return self.sd_imageURL;
}


//- (void)nim_cancelCurrentImageLoad {
//    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
//}
//
//- (void)nim_cancelCurrentAnimationImagesLoad {
//    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
//}


@end
