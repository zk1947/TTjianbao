//
//  JHMaskPopWindow.h
//  TTjianbao
//
//  Created by lihui on 2020/6/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAPPAlertBaseView.h"

@class JHStoreNewRedpacketModel;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHPopPlaceStyle) {
    JHPopPlaceStyleCombine = 1,     ///聚合  默认该属性
    JHPopPlaceStyleSeparate,        ///分离
};

typedef NS_ENUM(NSInteger, JHPopCancelPosition) {
    JHPopCancelPositionBottomCenter = 0,    ///下中  默认
    JHPopCancelPositionBottomLeft,          ///下左
    JHPopCancelPositionBottomRight,         ///下右
    JHPopCancelPositionTopCenter,           ///上中
    JHPopCancelPositionTopLeft,             ///上左
    JHPopCancelPositionTopRight,            ///上右
};
typedef NS_ENUM(NSInteger,JHPopRedpacketStyle){
    JHPopRedpacketStyleFirst = 0, ///弹出第一个红包：开心收下
    JHPopRedpacketStyleDetailSecond,///弹出第二个红包：去直播间使用
};
@interface JHMaskPopWindow : JHAPPAlertBaseView

///是否被显示
@property (nonatomic, assign, readonly) BOOL isPop;
//新手红包模型
@property(nonatomic,strong)JHStoreNewRedpacketModel *redpacketModel;


/// 屏幕中间显示的活动弹窗
/// @param popImage 活动图片
/// @param popImageSize 活动图片size
/// @param placeStyle 合并方式
/// @param popBlock 点击事件的回调block

+ (void)showPopWindowWithPopImage:(NSString *)popImage
                     popImageSize:(CGSize)popImageSize
                         popStyle:(JHPopPlaceStyle)placeStyle
                         cancelPosition:(JHPopCancelPosition)cancelPosition
                   actionBlock:(void(^)(BOOL isEnter))actionBlock;

+ (instancetype)defaultWindow;
+ (void)dismiss;
+(void)removeLittleBtn;
-(void)makeLittleImage:(JHStoreNewRedpacketModel *)model;
- (void)closeToLittle;
-(void)showDetailRedpacket;
- (void)updateRedpacketDetail;

@end

NS_ASSUME_NONNULL_END
