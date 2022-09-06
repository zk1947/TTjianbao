//
//  JHProgressView.h
//  TTjianbao
//
//  Created by apple on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHProgressView : UIView

@property(nonatomic, retain) UIImageView *bgImgeView;
@property(nonatomic, strong) UIImageView *leftImgView;
@property(nonatomic) float maxValue;
-(void)setPresent:(int)present;

//进度条背景的边框颜色
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) BOOL isNeedGradient;


@end

NS_ASSUME_NONNULL_END
