//
//  JHSeckillPageView.h
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSegmentPageView.h"
#import "JHSecKillTitleMode.h"
#import "JHSecKillHeaderMode.h"
#import "JHSecKillSegmentUIView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSeckillPageView : BaseView
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign, readonly) NSUInteger lastSegmentIndex;
@property (nonatomic, strong) JHSecKillSegmentUIView* segmentView;
@property (nonatomic, strong) NSArray<JHTableViewController*> *pageViewControllers;
@property (nonatomic, strong) NSArray <JHSecKillTitleMode*>* tabTitleArray;
@property (nonatomic, strong) JHSecKillHeaderMode* headerMode;

- (void)initSubviews;
@end

NS_ASSUME_NONNULL_END
