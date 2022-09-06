//
//  JHMallOperationModel.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLiveRoomMode.h"
NS_ASSUME_NONNULL_BEGIN
@class JHOperationDetailModel;
@class JHOperationImageModel;
@interface JHMallOperationModel : NSObject

@property (nonatomic, strong)  NSArray <JHLiveRoomMode*>*slideShow;//轮播
@property (nonatomic, strong) JHOperationDetailModel  *backGround;//背景
@property (nonatomic, strong) NSArray  <JHOperationDetailModel*>*operationPosition;
@property (nonatomic, assign) float  height;
@end

@interface JHOperationDetailModel : NSObject
//运营位序号
@property (nonatomic, assign) int  definiSerial;
//运营位类型
@property (nonatomic, assign) int  definiType;
//icon：ICON色值；unselected： 未选中字色值；selected：选中字色值 ,
@property (nonatomic, strong) NSString  *icon;

@property (nonatomic, assign) float  cellHeight;
//
@property (nonatomic, strong) NSArray <JHOperationImageModel*>*definiDetails;

@property (nonatomic, strong) NSString  *operationDefiniId;
@end

@interface JHOperationImageModel : NSObject
 //1:普通图片 2:背景图片 3:顶部导航图 ,
@property (nonatomic, assign) int   imageType;
@property (nonatomic, strong) NSString  *imageUrl;
@property (nonatomic, strong) NSString  *landingTarget;
@property (nonatomic, strong) NSDictionary  *target;

@property (nonatomic, strong) NSString  *detailsId;

@end

NS_ASSUME_NONNULL_END
