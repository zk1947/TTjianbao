//
//  PhotoView.h
//  仿Pinterest首页
//
//  Created by 徐茂怀 on 16/5/31.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHAudienceCommentMode;
@protocol didRemovePictureDelegate <NSObject>

-(void)didremovePicture:(NSInteger )index;
-(void)deletePicture:(NSMutableArray *)dataArr;
@end

#import "BaseView.h"

@interface PhotoView : BaseView

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)JHAudienceCommentMode *audienceCommentMode;
@property (nonatomic, assign)id<didRemovePictureDelegate>removeDelegate;

/**
 *  初始化方法
 *
 *  @param array  照片数组
 *  @param number 第几张照片
 */
-(void)initWithPicArray:(NSMutableArray *)array picNo:(NSInteger)number placeholderImage:(UIImage*)defaultImage ;

@end
