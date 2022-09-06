//
//  JHCustomerPublishModel.h
//  TTjianbao
//
//  Created by user on 2020/11/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 证书保存
 */
@interface JHCustomerEditCerPublishModel : NSObject
@property (nonatomic,   copy) NSString *awards;            /// 奖项
@property (nonatomic,   copy) NSString *certificateTime;   /// 发证日期
@property (nonatomic,   copy) NSString *holder;            /// 持证人
@property (nonatomic, assign) NSInteger ID;                /// ID
@property (nonatomic,   copy) NSString *imgUrl;            /// 证书图片
@property (nonatomic,   copy) NSString *name;              /// 名称
@property (nonatomic,   copy) NSString *organization;      /// 发证机构
@end

/*
 * 代表作保存
 */
@interface JHCustomerEditOpusPicsPublishModel : NSObject
@property (nonatomic,   copy) NSString *coverUrl; /// 视频封面
@property (nonatomic, assign) NSInteger type;     /// 定制师图片类型 0 图片 1 视频
@property (nonatomic,   copy) NSString *url;      /// 地址
@end

@interface JHCustomerEditOpusPublishModel : NSObject
@property (nonatomic,   copy) NSString                           *desc;                /// 描述
@property (nonatomic,   copy) NSString                           *title;               /// 名称
@property (nonatomic, assign) NSInteger                          ID;                   /// ID
@property (nonatomic, strong) NSArray<JHCustomerEditOpusPicsPublishModel *> *opusImgs; /// 持证人
@end


NS_ASSUME_NONNULL_END
