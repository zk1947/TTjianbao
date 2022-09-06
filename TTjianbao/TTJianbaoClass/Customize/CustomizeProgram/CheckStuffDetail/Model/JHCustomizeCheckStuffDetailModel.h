//
//  JHCustomizeCheckStuffDetailModel.h
//  TTjianbao
//
//  Created by user on 2020/12/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class JHCustomizeCheckStuffDetailPictsModel;
@interface JHCustomizeCheckStuffDetailModel : NSObject
@property (nonatomic, assign) NSInteger customizeFeeId;   /// 类别id
@property (nonatomic,   copy) NSString *customizeFeeName; /// 类别名字
@property (nonatomic, assign) NSInteger customizeOrderId; /// 定制订单id
@property (nonatomic, assign) NSInteger goodsCateId;      /// 分类id
@property (nonatomic,   copy) NSString *goodsCateName;    /// 分类名字
@property (nonatomic, assign) NSInteger ID;               /// id
@property (nonatomic,   copy) NSString *materialDesc;     /// 原料信息
@property (nonatomic, strong) NSArray<JHCustomizeCheckStuffDetailPictsModel *> *materialList;  /// 原料影像
@property (nonatomic,   copy) NSString *materialName;     /// 原料名称
@property (nonatomic, assign) NSInteger materialSource;   /// 原料来源：0 平台原料 1 自有原料
@property (nonatomic, assign) NSInteger sourceOrderId;    /// 来源订单id

@end

/// 图片
@interface JHCustomizeCheckStuffDetailPictsModel : NSObject
@property (nonatomic, strong) NSString *coverUrl; /// 封面图片
@property (nonatomic, assign) NSInteger type;     /// 定制师图片类型 0 图片 1 视频
@property (nonatomic, strong) NSString *url;      /// 地址
@end






NS_ASSUME_NONNULL_END
