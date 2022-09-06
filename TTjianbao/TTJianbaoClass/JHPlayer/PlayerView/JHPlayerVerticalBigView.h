//
//  JHPlayerVerticalBigView.h
//  TTJB
//
//  Created by 王记伟 on 2021/1/6.
//

//#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"
#import "JHPlayControlView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHPostDetailModel;

@interface JHPlayerVerticalBigView : JHPlayControlView
/** 数据模型*/
@property (nonatomic, strong) JHPostDetailModel *postDetail;

@property (nonatomic, copy) void(^actionBlock)(JHFullScreenControlActionType actionType);

@end

NS_ASSUME_NONNULL_END
