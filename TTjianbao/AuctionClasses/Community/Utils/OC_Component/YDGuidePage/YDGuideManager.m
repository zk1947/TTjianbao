//
//  YDGuideManager.m
//  ForkNews
//
//  Created by wuyd on 2018/5/25.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import "YDGuideManager.h"
#import <YYKit/YYKit.h>
#import "YDGuideView.h"
#import "AppDelegate.h"

#define kStoreHomeGuideKey    @"NeedShowStoreHomePageGuide"

@interface YDGuideManager ()
//@property (nonatomic, copy) dispatch_block_t doneBlock;
@end

@implementation YDGuideManager

#pragma mark -
#pragma mark - 显示商城<限时特卖>页引导

+ (void)showStoreHomePageGuide {
    //去掉了
    if ([self __needToDisplayStorHomePageGuide]) {
        YDGuideManager *manager = [[YDGuideManager alloc] init];
        [manager performSelector:@selector(__showStoreHomePageGuide) withObject:nil afterDelay:1];
    }
}

+ (BOOL)__needToDisplayStorHomePageGuide {
    BOOL needToShow = ![JHUserDefaults boolForKey:kStoreHomeGuideKey];
    return needToShow;
}

- (void)__showStoreHomePageGuide {
    
//    解决显示在广告页上面的问题
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *arr = app.window.subviews;
    for (UIView *subView in arr) {
        if ([subView isKindOfClass:[NSClassFromString(@"JHAdvertView") class]]) {
            return;
        }
    }
    
    YDGuideView *guideView = [[YDGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds guideType:YDGuideTypeStoreHome];
    [JHKeyWindow addSubview:guideView];
    
    guideView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        guideView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
    [JHUserDefaults setBool:YES forKey:kStoreHomeGuideKey];
    [JHUserDefaults synchronize];

}

@end
