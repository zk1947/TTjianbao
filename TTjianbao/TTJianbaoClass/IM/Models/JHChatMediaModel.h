//
//  JHChatMediaModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// 拍摄
    JHChatMediaTypeCamera,
    /// 相册
    JHChatMediaTypeAlbum,
    /// 平台客服
    JHChatMediaTypeService,
    /// 拉黑
    JHChatMediaTypeBlack,
    /// 订单
    JHChatMediaTypeOrder,
    /// 优惠券
    JHChatMediaTypeCoupon,
    /// 举报
    JHChatMediaTypeComplaint,
} JHChatMediaType;

@interface JHChatMediaModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selTitle;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *selIconName;
@property (nonatomic, assign) JHChatMediaType type;
/// 是否选中。-判断是否拉黑。
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithType : (JHChatMediaType) type
                       title : (NSString *)title
                    selTitle : (NSString *)selTitle
                        icon : (NSString *)icon
                     selIcon : (NSString *)selIcon
                  isSelected :(BOOL)isSelected;


+ (NSArray *)getDefaultMediaList : (BOOL)isBlack isShowCoupon : (BOOL)isShowCoupon;
@end

NS_ASSUME_NONNULL_END
