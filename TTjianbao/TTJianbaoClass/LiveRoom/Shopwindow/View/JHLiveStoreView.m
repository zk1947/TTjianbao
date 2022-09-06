//
//  JHLiveStoreView.m
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveStoreView.h"
#import "JHLiveStoreBottomListView.h"

@interface JHLiveStoreView ()<UIGestureRecognizerDelegate>
@property (nonatomic ,assign)JHLiveStoreViewType storeTyoe;

@property (nonatomic, copy) ChannelMode *channel;

@end

@implementation JHLiveStoreView

- (instancetype)initWithType:(JHLiveStoreViewType)type channel:(ChannelMode * _Nullable)channel {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    if (self) {
        _channel = channel;
        self.storeTyoe = type;
        [self initCreatUI:channel];
//        self.layer.zPosition = 100;
    }
    return self;
}

- (void)initCreatUI:(ChannelMode *)channel{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestAction:)];
    tapGest.delegate = self;
    [self addGestureRecognizer:tapGest];
    JHLiveStoreBottomListView * listView = [[JHLiveStoreBottomListView alloc] initWithFrame:CGRectMake(0, ScreenH*2/5, ScreenW, ScreenH*3/5)];
    [self addSubview: listView];
    
    @weakify(self);
    listView.hiddenBlock = ^(BOOL hidden) {
        @strongify(self);
        self.hidden = hidden;
    };
    
    listView.removeBlock = ^{
        @strongify(self);
        [self removeFromSuperview];
    };
    
    if (self.storeTyoe == JHLiveStoreViewTypeSaler) {
        [listView setViewUIConfig:channel];
    }else{
        [listView setViewUIConfigForUserWithChannel:channel];
    }
}

- (void)tapGestAction:(UIGestureRecognizer *)gestureR{
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
