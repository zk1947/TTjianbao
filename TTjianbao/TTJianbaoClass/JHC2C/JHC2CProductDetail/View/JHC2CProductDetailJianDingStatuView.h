//
//  JHC2CProductDetailJianDingStatuView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHC2CProductDetailJianDingType){
    JHC2CProductDetailJianDingType_NotJianDing = 0,
    JHC2CProductDetailJianDingType_Real,
    JHC2CProductDetailJianDingType_CunYi,
    JHC2CProductDetailJianDingType_GongYiPin,
    JHC2CProductDetailJianDingType_Jia,
} ;

@interface JHC2CProductDetailJianDingStatuView : UIView

@property(nonatomic, copy) void(^goJianDingBlock)(void);

//default JHC2CProductDetailJianDingType_NotJianDing
@property(nonatomic, readonly) JHC2CProductDetailJianDingType type;

- (void)refreshStatusType:(JHC2CProductDetailJianDingType)type;

@end

NS_ASSUME_NONNULL_END
