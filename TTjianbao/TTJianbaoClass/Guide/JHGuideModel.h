//
//  JHGuideModel.h
//  TTjianbao
//
//  Created by lihui on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHGuideDataType) {
    JHGuideDataTypeCommunity=0,       ///文玩社区
    JHGuideDataTypeOriginBuy=1,       ///源头直购
    JHGuideDataTypeAuthenticate=3,  ///免费鉴定
};

@interface JHGuideModel : NSObject

@property (nonatomic, copy) NSString *iconName;     ///图片信息
@property (nonatomic, copy) NSString *title;        ///标题
@property (nonatomic, copy) NSString *detail;       ///描述信息
@property (nonatomic, copy) NSString *btnTitle;   ///按钮标题
@property (nonatomic, assign) JHGuideDataType dataType;
@property (nonatomic, copy) NSString *vcName;     ///图片信息

@end

NS_ASSUME_NONNULL_END
