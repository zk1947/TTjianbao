//
//  JHIdentificationDetailsModel.h
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHIdentDetailImageOrVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsModel : NSObject

/// 鉴定费用
@property (nonatomic, copy) NSString *appraisalFeeYuan;
///  最终展示的鉴定费用
@property (nonatomic, copy) NSString *showAppraisalFeeYuan;
/// 一级分类名称
@property (nonatomic, copy) NSString *categoryFirstName;
///二级分类名称
@property (nonatomic, copy) NSString *categorySecondName;
/// 展示的分类名称
@property (nonatomic, copy) NSString *showCategoryName;
/// 描述
@property (nonatomic, copy) NSString *productDesc;
/// 视频
@property (nonatomic, strong) NSArray<JHIdentDetailImageOrVideoModel *> *videos;
/// 图片
@property (nonatomic, strong) NSArray<JHIdentDetailImageOrVideoModel *> *images;
/// 头部的高度
@property (nonatomic, assign) CGFloat introduceHeight;
/// 所有的展示
@property (nonatomic, strong) NSArray<JHIdentDetailImageOrVideoModel *> *imagesAndVideosAll;
@end

@interface JHIdentDetailImageOrVideoModel  : NSObject

/// 是视频播放
@property (nonatomic, assign) BOOL isVideo;
/// 最终展示图片的地址
@property (nonatomic, copy) NSString *showImageUrl;

/// ----------- 图片
/// 大图
@property (nonatomic, copy) NSString *big;
/// 高
@property (nonatomic, copy) NSString *h;
///  宽
@property (nonatomic, copy) NSString *w;
/// 小图
@property (nonatomic, copy) NSString *medium;
///  原图
@property (nonatomic, copy) NSString *origin;
/// 缩略图
@property (nonatomic, copy) NSString *small;
/// 新的高度
@property (nonatomic, assign) CGFloat aNewHeight;
/// ----------- 视频
/// 视频封面地址
@property (nonatomic, copy) NSString *converUrl;
/// 视频地址
@property (nonatomic, copy) NSString *url;


@end

NS_ASSUME_NONNULL_END
