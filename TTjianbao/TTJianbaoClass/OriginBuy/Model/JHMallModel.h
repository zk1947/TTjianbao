//
//  JHMallModel.h
//  TTjianbao
//
//  Created by lihui on 2020/12/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMallBannerModel;
@class JHMallCategoryModel;
@class TargetModel;
@class JHMallOperateModel;

@interface JHMallModel : NSObject

///顶部直播间轮播数据
@property (nonatomic, strong)  NSArray <JHMallBannerModel*>*slideShow;
///隐藏运营位 -- 背景
@property (nonatomic, strong) JHMallOperateModel *hidePperationPosition;
///首页金刚位/分类数据
@property (nonatomic, strong) NSArray <JHMallCategoryModel *>*operationSubjectList;
///运营位数据
@property (nonatomic, strong) NSArray <JHMallOperateModel*>*operationPosition;

@end

@interface JHMallBannerModel : NSObject
///跳转参数
@property (nonatomic, copy) NSString *landingTarget;
///自定义属性
@property (strong, nonatomic) TargetModel *target;
///直播状态：0 休息中 1 ：禁用 2：直播中
@property (nonatomic, assign) NSInteger status;
///直播间封面图
@property (nonatomic, copy) NSString *smallCoverImg;
@end

///金刚位模型
@interface JHMallCategoryModel : NSObject
///编码
@property (nonatomic, copy) NSString *code;
/** 角标图片*/
@property (nonatomic, copy) NSString *corner;
@property (nonatomic, copy) NSString *icon;
///专题名称
@property (nonatomic, copy) NSString *name;
///专题Id
@property (nonatomic, copy) NSString *operationSubjectId;
///落地页数据
//@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSDictionary *target;
///自定义数据
@property (nonatomic, copy) TargetModel *targetModel;
/// 类型
@property (nonatomic, copy) NSString *landingName;
@end

@class JHMallOperateImgModel;

///运营位数据模型
@interface JHMallOperateModel : NSObject
///直播列表展示位置 0 不展示
@property (nonatomic, copy) NSString *definiLocation;
///运营位名称
@property (nonatomic, copy) NSString *definiName;
///运营位序号
@property (nonatomic, assign) int definiSerial;
///运营位类型：1:单图 2:多图平铺 3:轮播图 4:背景图 5:单图多触点
@property (nonatomic, assign) int definiType;

@property (nonatomic, assign) float cellHeight;
//icon：ICON色值；unselected： 未选中字色值；selected：选中字色值 ,
@property (nonatomic, strong) NSString *icon;
///运营位主题id
@property (nonatomic, strong) NSString *operationDefiniId;
@property (nonatomic, strong) NSArray <JHMallOperateImgModel*>*definiDetails;
///是否留白：0 否；1 是
@property (nonatomic, assign) BOOL interSpace;
///多触点图片地址 如果是单图多触点就就用这个图片地址
@property (nonatomic, copy) NSString *moreHotImgUrl;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic,   copy) NSString *moreHotImgProportion;
@end

@interface JHMallOperateImgModel : NSObject
 //1:普通图片 2:背景图片 3:顶部导航图 ,
@property (nonatomic, assign) int imageType;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *landingTarget;
@property (nonatomic, strong) NSString *detailsId;
@property (nonatomic, strong) TargetModel *target;
@end

NS_ASSUME_NONNULL_END
