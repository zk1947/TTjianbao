//
//  JHLiveStatusView.h
//  
//
//  Created by lihui on 2020/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveStatusView : UIView

- (void)setLiveStatus:(NSInteger)status watchTotal:(NSString *_Nullable)watchCount;
///直播中字体颜色
@property (nonatomic, strong) UIColor *livingColor;
///休息中字体颜色
@property (nonatomic, strong) UIColor *restColor;
///字体大小
@property (nonatomic, assign) CGFloat fontSize;
///直播中按钮
@property (nonatomic, copy) NSString *liveImageStr;
///状态文字
@property (nonatomic, copy) NSString *statusString;

@end

NS_ASSUME_NONNULL_END
