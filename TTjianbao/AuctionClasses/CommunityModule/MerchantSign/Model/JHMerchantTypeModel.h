//
//  JHMerchantTypeModel.h
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHMerchantType) {
    JHMerchantTypeNone = 0,    ///啥都没有
    JHMerchantTypePerson,  ///个人
    JHMerchantTypeCompany,    ///公司
    
};

NS_ASSUME_NONNULL_BEGIN

@interface JHMerchantTypeModel : NSObject
///图片名称
@property (nonatomic, copy) NSString *imgName;
///标题
@property (nonatomic, copy) NSString *titleText;
///描述
@property (nonatomic, copy) NSString *detailDescription;
///商家类型
@property (nonatomic, assign) JHMerchantType merchantType;


@end


NS_ASSUME_NONNULL_END
