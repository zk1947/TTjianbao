//
//  UIButton+zan.h
//  JiJianKang
//
//  Created by gaomeng on 2017/5/26.
//  Copyright © 2017年 CiJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (zan)



/**
 左图右字

 @param space 文字图片的间距
 */
-(void)refresh_leftImv_rightTitle_space:(CGFloat)space;



/**
 左字右图

 @param space 文字图片的间距
 */
-(void)refresh_leftTitle_rightImv_space:(CGFloat)space;


/**
 上图下字

 @param space 文字图片的间距
 */
-(void)refresh_upImv_downTitle_space:(CGFloat)space;

/**
 上字下图
 
 @param space 文字图片的间距
 */
-(void)refresh_upTitle_downImv_space:(CGFloat)space;


/**
 左字右图
 
 @param space 图片距离中间的间距
 */
-(void)refresh_productListSearchView_leftTitle_rightImv_space:(CGFloat)space;


/**
 点赞动画
 */
-(void)zanAnimation;


/**
 调试颜色
 */
-(void)testColor;


@end
