//
//  JHRecycleOrderBusinessVideoViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessVideoViewModel.h"

@implementation JHRecycleOrderBusinessVideoViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions
- (void)setupDataWithImageUrl : (NSString *)imageUrl
                     videoUrl : (NSString *)videoUrl
                        scale : (CGFloat)scale {
    
    self.imageUrl = imageUrl;
    self.videoUrl = videoUrl;
    CGFloat width = ScreenW - ContentLeftSpace * 2;
    CGFloat height = width * scale;
    self.height = height;
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderBusinessCellTypeVideo;
}
#pragma mark - Action functions
#pragma mark - Lazy

- (RACSubject *)playEvent {
    if (!_playEvent) {
        _playEvent = [RACSubject subject];
    }
    return _playEvent;
}
@end
