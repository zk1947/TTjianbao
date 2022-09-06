//
//  JHCustomizeAddCompleteModel.h
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCustomizeAddCompletePictModel;
@interface JHCustomizeAddCompleteModel : NSObject
@property (nonatomic, assign) NSInteger customizeOrderId; /// 定制订单id
@property (nonatomic,   copy) NSString *finishRemark;     /// 完成备注
@property (nonatomic, strong) NSArray<JHCustomizeAddCompletePictModel *> *worksImgList;  /// 图像信息

@end

/// 图片
@interface JHCustomizeAddCompletePictModel : NSObject
@property (nonatomic, strong) NSString *coverUrl; /// 封面图片
@property (nonatomic, assign) NSInteger type;     /// 定制师图片类型 0 图片 1 视频
@property (nonatomic, strong) NSString *url;      /// 地址
@end



NS_ASSUME_NONNULL_END
