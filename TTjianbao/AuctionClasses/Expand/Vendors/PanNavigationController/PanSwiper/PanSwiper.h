//
//  PanSwiper.h
//  PanPush
//
//  Created by lpc on 16/3/16.
//  Copyright © 2016年 lpc. All rights reserved.
//
//  代码地址:https://github.com/jsbyfl/PanPush_NavigationController.git

#import <Foundation/Foundation.h>
@protocol PanPushToNextViewControllerDelegate;

#define guideViewTag 190715
#define k_Progress_Pan_Pop          0.4     //Pop触发的滑动比例
#define k_Progress_Pan_Push         0.3     //Push触发的滑动比例

@interface PanSwiper : NSObject

@property (nonatomic,assign) BOOL isForbidDragBack; //Defalt is NO.
@property (nonatomic,weak) id <PanPushToNextViewControllerDelegate> panPushDelegate;
@property (nonatomic, weak) UIViewController* receiveTouchViewController;
@property (nonatomic, weak) UIViewController* popAssignViewController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end


@protocol PanPushToNextViewControllerDelegate <NSObject>

@optional
- (UIViewController *)swiperBeginPanPushToNextController:(PanSwiper *)swiper;
- (void)swiperDidEndPanPushToNextController:(PanSwiper *)swiper;

- (void)popFinish;

@end
