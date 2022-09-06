//
//  JHUnionSignShowBaseModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHUnionSignShowType)
{
    JHUnionSignShowTypeNone = 0,
    
    /// 实名认证
    JHUnionSignShowTypeRealName,
    
    /// 营业信息
    JHUnionSignShowTypeShopInfo,
    
    /// 账户信息
    JHUnionSignShowTypeAccountInfo,
    
    /// 电子签约
    JHUnionSignShowTypeSignInfo,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHUnionSignShowBaseModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL hiddenPushIcon;

+ (JHUnionSignShowBaseModel *)creatWithTitle:(NSString *)title desc:(NSString *)desc type:(JHUnionSignShowType)type hiddenPushIcon:(BOOL)hiddenPushIcon;

@end

NS_ASSUME_NONNULL_END
