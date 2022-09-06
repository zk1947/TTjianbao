//
//  JHResaleLiveRoomStretchView.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHResaleLiveRoomStretchView.h"

@interface JHResaleLiveRoomStretchView ()
{
    JHResaleLiveRoomTabView* tabView;
    UIButton* extenseButton;
    UIButton* swipeButton;
}
@property (nonatomic, assign) JHResaleTabStyle tabStyle;
@property (nonatomic, strong) UIPanGestureRecognizer* swipeGesture;
@property (nonatomic, copy) JHActionBlock callbackAction;

@end
@implementation JHResaleLiveRoomStretchView

- (void)drawSubviews:(NSString*)mChannelId action:(JHActionBlock)action
{
    _callbackAction = action; //设置回调
    self.backgroundColor = [UIColor clearColor]; //半透明
    //tab上面的展开按钮
    [self drawExtenseView];
    //draw tab
    JH_WEAK(self)
    [self drawTabView:mChannelId action:^(id obj) {
        JH_STRONG(self)
        NSInteger type = [obj integerValue];
        self.tabStyle = type;
        if (self->extenseButton.selected && [obj integerValue] == JHResaleTabStyleDefault) {
            if (self->extenseButton.selected) {
                type = JHResaleTabStyleHigh;
            }
        }
        if (type == JHResaleTabStyleDefault) {
            [self shrinkView];
        }
        if(self.callbackAction)
               self.callbackAction(@(type));
    }];
    //draw swipe
    [self drawSwipeView];
}

- (void)setTabViewRedDotNum:(NSUInteger)num withIndex:(NSUInteger)index clickAction:(JHActionBlock)action
{
    [tabView setRedDotNum:num withIndex:index];
    if (action) {
        tabView.toTabBlock = action;
    }
}

- (void)drawExtenseView
{
    if(!extenseButton)
    {
        extenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        extenseButton.layer.cornerRadius = 12;
        extenseButton.backgroundColor = [UIColor redColor];
        extenseButton.frame = CGRectMake((self.width - 104)/2.0, 0, 104, 25);
        [extenseButton setTitle:@"收起全部原石" forState:UIControlStateSelected];
        [extenseButton setTitle:@"查看全部原石" forState:UIControlStateNormal];
        extenseButton.titleLabel.font = JHFont(12);
        [extenseButton setImage:[UIImage imageNamed:@"resale_tab_extense_down"] forState:UIControlStateSelected];
        [extenseButton setImage:[UIImage imageNamed:@"resale_tab_extense_up"] forState:UIControlStateNormal];
        [extenseButton setImageEdgeInsets:UIEdgeInsetsMake(4, 104-21, 4, 4)];
        [extenseButton setTitleEdgeInsets:UIEdgeInsetsMake(4, -12, 4, 25)];
        [extenseButton addTarget:self action:@selector(pressExtenseButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:extenseButton];
    }
}

- (void)drawSwipeView
{
    if(!swipeButton)
    {
        swipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self insertSubview:swipeButton aboveSubview:tabView];
        swipeButton.frame = CGRectMake(0, kResaleLiveShrinkHeight-6-17-UI.bottomSafeAreaHeight, 87, 17);
        swipeButton.centerX = self.centerX;
        swipeButton.userInteractionEnabled = NO;
        swipeButton.backgroundColor = [UIColor clearColor];
        swipeButton.titleLabel.font = JHFont(12);
        [swipeButton setTitle:@"上滑查看更多" forState:UIControlStateNormal];
        [swipeButton setTitleColor:HEXCOLORA(0xFFFFFF, 0.5) forState:UIControlStateNormal];
        [swipeButton setImage:[UIImage imageNamed:@"resale_tab_swipe"] forState:UIControlStateNormal];
        [swipeButton setImageEdgeInsets:UIEdgeInsetsMake(3, 2, 3, 87-4-11)]; //w=11h=11
        [swipeButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
        [swipeButton setHidden:YES];
    }
}

- (void)drawTabView:(NSString*)mChannelId action:(JHActionBlock)action
{
    if(!tabView)
    {
        CGFloat y = (extenseButton.bottom - extenseButton.mj_y)/2.0;
        tabView = [[JHResaleLiveRoomTabView alloc] initWithFrame:CGRectMake(0, y, ScreenW, self.height - y)];
        [self insertSubview:tabView belowSubview:extenseButton];
        [tabView drawSubviews:mChannelId action:action];
    }
}

- (UIPanGestureRecognizer *)swipeGesture
{
    if(!_swipeGesture)
    {
        _swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    }
    return _swipeGesture;
}

#pragma mark - refresh page
- (void)refreshTable
{
    [tabView refreshTableWithTab:tabView.lastSegmentIndex];
}

#pragma mark - event
- (void)pressExtenseButton:(UIButton*)button
{
    button.selected = !button.selected;
    if (!button.selected) {
        [self shrinkView];
        
    }else {
        [self stretchView];
    }
}

- (void)stretchView
{
    extenseButton.selected = YES;
    [swipeButton setHidden:YES];
    if(_callbackAction)
    {
        if(_tabStyle == JHResaleTabStyleDefault)
            _callbackAction(@(JHResaleTabStyleHigh));
        else
            _callbackAction(@(JHResaleTabStyleHidden));
    }
    CGRect rect = self.frame;
    [UIView animateWithDuration:0.25f animations:^{
        self.mj_y = ScreenH - rect.size.height;
        [tabView shrinkPageviewController:NO]; //展开
    }];
    
    if (_swipeGesture) {
        [self removeGestureRecognizer:_swipeGesture];
    }
}

- (void)shrinkView
{
    if(_callbackAction)
    {
        if(_tabStyle == JHResaleTabStyleDefault)
            _callbackAction(@(JHResaleTabStyleLow));
        else
            _callbackAction(@(JHResaleTabStyleHidden));
    }
    extenseButton.selected = NO;
    CGRect rect = self.frame;
    rect.origin.y = ScreenH-kResaleLiveShrinkHeight;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;

        [tabView shrinkPageviewController:YES]; //收缩
    } completion:^(BOOL finished) {
        [tabView setPageToIndex:0];
        [swipeButton setHidden:NO];
    }];
    
    [self addGestureRecognizer:self.swipeGesture];
}

- (void)swipe:(UIPanGestureRecognizer*)gesture
{
    CGPoint point = [gesture velocityInView:self];
    if(point.y > 0)
    {
        DDLogInfo(@"swipe->panGestureRecognizer~~~~~~~scroll向下");
    }
    else
    {
        DDLogInfo(@"swipe->panGestureRecognizer~~~~~~~scroll向上");
        [self stretchView];
    }
}

@end
