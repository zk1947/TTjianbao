//
//  JHLivePlaySMallView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/2/25.
//  Copyright © 2020年 YiJian Tech. All rights reserved.
//

#import "JHLivePlaySMallView.h"

static JHLivePlaySMallView *instance;
@interface JHLivePlaySMallView ()
{
    CGPoint startPoint;
    CGPoint selfCenter;
}
@end

@implementation JHLivePlaySMallView
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHLivePlaySMallView alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterLiveRoom)]];
        self.playView=[[UIView alloc]init];
        [self addSubview:self.playView];
        [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
       _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"live_playview_close"] forState:UIControlStateNormal];
        _closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30,30));
            
        }];
        
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        startPoint = [touch locationInView:self.superview];
        selfCenter = self.center;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint moveP = [touch locationInView:self.superview];
        CGFloat offsetX = moveP.x - startPoint.x;
        CGFloat offsetY = moveP.y - startPoint.y;
        CGFloat ox = 0.;
        CGFloat ww = ScreenW;
        CGFloat oy = 0.;
        CGFloat hh = ScreenH;
        CGPoint tempCenter = CGPointMake(selfCenter.x+offsetX, selfCenter.y+offsetY);
        if (tempCenter.x+self.width/2.>ww) {
            tempCenter.x = ww-self.width/2.;
        }
        if (tempCenter.x-self.width/2.< ox) {
            tempCenter.x = ox+self.width/2.;
        }

        if (tempCenter.y+self.height/2.>hh) {
            tempCenter.y = hh-self.height/2.;
        }
        if (tempCenter.y-self.height/2.< ox) {
            tempCenter.y = oy+self.height/2.;
        }

        NSLog(@"Moved %@", NSStringFromCGPoint(tempCenter));
        self.center = tempCenter;

    }
    NSLog(@" %@", NSStringFromCGPoint(self.center));
}
-(void)close{
    
    [[JHLivePlayer sharedInstance]doDestroyPlayer];
    [self removeFromSuperview];
}
-(void)enterLiveRoom{
    
    [JHRootController EnterLiveRoom:self.channelMode.channelLocalId fromString:@""];
    
}
@end
