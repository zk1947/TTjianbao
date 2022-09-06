//
//  JHCustomizeGuideTipView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/12/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeGuideTipView.h"
#import "JHCommBubbleTipView.h"
#import "JHAppAlertViewManger.h"

@interface JHCustomizeGuideTipView ()
@property (nonatomic, assign) CGRect transparencyRect;
@end

@implementation JHCustomizeGuideTipView

- (void)dealloc {
    
}
- (instancetype)init
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)removeSelf {
    
    [self removeFromSuperview];
}

- (void)showGuideWithType:(JHTipsGuideType)type transparencyRect:(CGRect)rect {
    
    switch (type) {
        case JHTipsGuideTypeSellMarket:{
            [self showSellMarketGuideSubviews:rect];
            
        }
            break;
            
        case JHTipsGuideTypeTianTianCustomize:{
            [self showTTCustomzeGuideSubviews:rect];
        }
            break;
        default:
            break;
    }
}
-(void)showSellMarketGuideSubviews:(CGRect)rect{
        
       [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:5 containerView:self];
        JHCommBubbleTipView * bubble = [[JHCommBubbleTipView alloc ]init];
        [bubble creatSellMarketBubble];
        [self addSubview:bubble];
        @weakify(self);
        bubble.clickHandle = ^{
            @strongify(self);
            [self removeSelf] ;
        };
        [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).offset(rect.origin.y-2);
            make.left.equalTo(self).offset(rect.origin.x);
        }];
       
}
-(void)showTTCustomzeGuideSubviews:(CGRect)rect{
    
    self.backgroundColor= HEXCOLORA(0x000000, 0.6);
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_guide_tt_logo"]];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(rect.origin.y-32/2+rect.size.height/2);
      //  make.left.equalTo(self).offset(rect.origin.x-92/2+rect.size.width/2);
        make.centerX.equalTo(self.mas_leading).offset(rect.origin.x+rect.size.width/2.);
    }];
   
    JHCommBubbleTipView * bubble = [[JHCommBubbleTipView alloc ]init];
    [bubble creatTTCustomizeBubble];
    [self addSubview:bubble];
    @weakify(self);
    bubble.clickHandle = ^{
        @strongify(self);
        if (self.disMissHandle) {
            self.disMissHandle();
        }
        [self removeSelf] ;
    };
    [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleImageView.mas_bottom).offset(5);
        make.left.equalTo(titleImageView).offset(-30);
    }];
   
    UIImageView *contentImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_guide_tt_back"]];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:contentImageView];
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bubble.mas_bottom).offset(50);
        make.centerX.equalTo(self);
    }];
    
}
@end
