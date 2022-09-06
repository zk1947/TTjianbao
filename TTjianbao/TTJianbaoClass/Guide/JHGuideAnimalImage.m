//
//  JHGuideAnimalImage.m
//  TTjianbao
//
//  Created by Jesse on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGuideAnimalImage.h"
#import "PanSwiper.h"
#import "JHLikeImageView.h"

@interface JHGuideAnimalImage ()

///新手引导的文案展示
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, strong) UIControl *guideView;
@property (nonatomic, strong) JHLikeImageView *dragView;
@end

@implementation JHGuideAnimalImage

- (instancetype)init
{
    if(self = [super init])
    {
        self.tips = @"滑动一下，下一个精彩等着你~";
    }
    return self;
}

- (void)animalImageWithTips:(NSString *)tips superView:(UIView*)viewOfSuper{
    self.tips = tips;
    [self animalImageWithSuperView:viewOfSuper];
}

- (void)animalImageWithSuperView:(UIView*)viewOfSuper {
    
    UIControl *guideView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.tag = guideViewTag;
    guideView.backgroundColor = HEXCOLORA(0x000000, 0.8);
    guideView.userInteractionEnabled = YES;
    [viewOfSuper addSubview:guideView];
    [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(viewOfSuper);
    }];
    self.guideView = guideView;
    
    JHLikeImageView *image = [[JHLikeImageView alloc] initVideoDragWithFrame:CGRectZero];
    [guideView addSubview:image];
    
    UIImage *img = [UIImage imageNamed:@"video_slide_0000_00"];
    CGFloat scale = 2;
    image.center = guideView.center;
    UILabel *label = [[UILabel alloc] init];
    label.text = self.tips;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [guideView addSubview:label];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(img.size.height*scale));
        make.width.equalTo(@(img.size.width*scale));
        make.centerY.equalTo(guideView).offset(-30);
        make.centerX.equalTo(guideView);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guideView);
        make.top.equalTo(image.mas_bottom).offset(30);
    }];
    [image startAnimation];
    
    self.dragView = image;
    
    
    [self.guideView addTarget:self action:@selector(removeGuideView) forControlEvents:UIControlEventTouchDown];
    [self performSelector:@selector(removeGuideView) withObject:nil afterDelay:3];
    
}

- (void)removeGuideView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeGuideView) object:nil];
    [self.dragView endAnimation];
    [self.guideView removeFromSuperview];
    self.dragView = nil;
    self.guideView = nil;
}

@end
