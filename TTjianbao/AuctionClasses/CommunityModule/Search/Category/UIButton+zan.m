//
//  UIButton+zan.m
//  JiJianKang
//
//  Created by gaomeng on 2017/5/26.
//  Copyright © 2017年 CiJi. All rights reserved.
//

#import "UIButton+zan.h"

@implementation UIButton (zan)


-(void)testColor{
    self.imageView.backgroundColor =  [UIColor orangeColor];
    self.titleLabel.backgroundColor = [UIColor purpleColor];
}


/**
 左图右字

 @param space 文字图片的间距
 */
-(void)refresh_leftImv_rightTitle_space:(CGFloat)space{
    
    CGFloat width_imageView = self.currentImage.size.width;
    CGFloat width_titleLabel = self.titleLabel.intrinsicContentSize.width;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -width_titleLabel)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -width_imageView, 0, 0)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, width_imageView - width_titleLabel +space*0.5)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, width_titleLabel - width_imageView + space*0.5, 0, 0)];
}

-(void)zanAnimation{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [self.imageView.layer addAnimation:k forKey:@"show"];
}


/**
 左字右图
 
 @param space 文字图片的间距
 */
-(void)refresh_leftTitle_rightImv_space:(CGFloat)space{
    CGFloat width_imageView = self.currentImage.size.width;
    CGFloat width_titleLabel = self.titleLabel.intrinsicContentSize.width;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -width_titleLabel)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -width_imageView, 0, 0)];
    
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - width_titleLabel - width_titleLabel - width_imageView)];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -width_imageView - space, 0, 0)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -width_titleLabel - width_imageView - space * 0.5)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -width_imageView - width_titleLabel - space * 0.5, 0, 0)];
    
    
}





/**
 上图下字

 @param space 文字图片的间距
 */
-(void)refresh_upImv_downTitle_space:(CGFloat)space{
    
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
    
//    CGFloat width_imageView = self.currentImage.size.width;
//    CGFloat width_titleLabel = self.titleLabel.intrinsicContentSize.width;
//
//    CGFloat height_imageView = self.currentImage.size.height;
//    CGFloat height_titleLabel = self.titleLabel.intrinsicContentSize.height;
//
//
//    [self setImageEdgeInsets:UIEdgeInsetsMake(-height_titleLabel - space * 0.5, 0, 0, -width_titleLabel/2.0)];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(height_imageView + space * 0.5, -width_imageView/2.0, 0, 0)];
    
    
}

/**
 上字下图
 
 @param space 文字图片的间距
 */
-(void)refresh_upTitle_downImv_space:(CGFloat)space{
    CGFloat width_imageView = self.currentImage.size.width;
    CGFloat width_titleLabel = self.titleLabel.intrinsicContentSize.width;
    
    CGFloat height_imageView = self.currentImage.size.height;
    CGFloat height_titleLabel = self.titleLabel.intrinsicContentSize.height;
    
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(height_titleLabel + space *0.5, 0, 0, -width_titleLabel)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(-height_imageView - space *0.5, -width_imageView, 0, 0)];
    
    
}


/**
 左字右图
 
 @param space 图片距离中间的间距
 */
-(void)refresh_productListSearchView_leftTitle_rightImv_space:(CGFloat)space{
    CGFloat width_imageView = self.currentImage.size.width;
    CGFloat width_titleLabel = self.titleLabel.intrinsicContentSize.width;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -width_titleLabel)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -width_imageView, 0, 0)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - width_titleLabel - width_titleLabel - width_imageView)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -width_imageView - space, 0, 0)];
}




@end
