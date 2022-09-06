//
//  JHNewGuideTipsView.h
//  TTjianbao
//
//  Created by yaoyao on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHTipsGuideType) {
    JHTipsGuideTypeSellMarket,
    JHTipsGuideTypeSellRoom,
    JHTipsGuideTypeAppraiseRoom,
    JHTipsGuideTypeAppraiseRoomApply,
    JHTipsGuideTypeTianTianCustomize,
    JHTipsGuideTypeCustomizeRoom,       //定制直播间引导
    JHTipsGuideTypeCustomizeRoom_second       //定制直播间引导第二步
};
NS_ASSUME_NONNULL_BEGIN

@interface JHNewGuideTipsViewModel : NSObject
@property (nonatomic,assign)JHTipsGuideType type;
@property (nonatomic,assign)CGRect rect;
@end

@interface JHNewGuideTipsView : UIControl
//单个提示
+ (void)showGuideWithType:(JHTipsGuideType)type transparencyRect:(CGRect)rect superView:(UIView *)superView;

//多个提示引导
+ (void)showGuideWithModelArray:(NSArray *)array superView:(UIView *)superView;

- (void)setStyleType:(JHTipsGuideType)typ transparencyRect:(CGRect)rect;
/// 挖窟窿
/// @param frame 窟窿的frame
/// @param radius 窟窿圆角
/// @param view 承载view
+ (void)drawEmptyFrame:(CGRect)frame emptyRadius:(CGFloat)radius containerView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
