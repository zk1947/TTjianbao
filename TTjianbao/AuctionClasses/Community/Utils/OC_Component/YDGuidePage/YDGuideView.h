//
//  YDGuideView.h
//  ForkNews
//
//  Created by wuyd on 2018/5/25.
//  Copyright © 2018年 wuyd. All rights reserved.
//  页面指示图
//

#import <UIKit/UIKit.h>

//引导页类型
typedef NS_ENUM(NSInteger, YDGuideType) {
    ///商城首页
    YDGuideTypeStoreHome = 0
};

@interface YDGuideView : UIView

/** 针对某个页面的引导 */
- (instancetype)initWithFrame:(CGRect)frame guideType:(YDGuideType)guideType;

/** 显示整张全屏图片<可传多个>时调用，可传gif图片名<带后缀> */
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray<NSString *> *)imageNames;

@end
