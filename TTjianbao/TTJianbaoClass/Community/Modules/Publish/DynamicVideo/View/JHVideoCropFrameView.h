//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JHVideoCropDataManager.h"

@interface JHVideoCropFrameView : UIView

// JHVideoCropFrameView 是视频截取显示帧图的视图

- (instancetype)initWithFrame:(CGRect)frame dataManager:(JHVideoCropDataManager *)dataManager;

@property(nonatomic,weak)id <SDVideoCropVideoDragDelegate>delegate;

@end

