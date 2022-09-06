//
//  JHChatMediaModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMediaModel.h"
#import "UserInfoRequestManager.h"

@implementation JHChatMediaModel
- (instancetype)initWithType : (JHChatMediaType) type
                       title : (NSString *)title
                    selTitle : (NSString *)selTitle
                        icon : (NSString *)icon
                     selIcon : (NSString *)selIcon
                  isSelected :(BOOL)isSelected {
    self = [super init];
    if (self) {
        self.type = type;
        self.title = title;
        self.iconName = icon;
        self.selTitle = selTitle;
        self.selIconName = selIcon;
        self.isSelected = isSelected;
    }
    return self;
}

+ (NSArray *)getDefaultMediaList : (BOOL)isBlack isShowCoupon : (BOOL)isShowCoupon{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    JHChatMediaModel *model1 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeCamera
                                title:@"拍摄"
                                selTitle : @"拍摄"
                                icon:@"IM_photo_icon"
                                selIcon :@"IM_photo_icon"
                                isSelected :false];
    
    JHChatMediaModel *model2 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeAlbum
                                title:@"相册"
                                selTitle : @"相册"
                                icon:@"IM_album_icon"
                                selIcon :@"IM_album_icon"
                                isSelected :false];
    JHChatMediaModel *model3 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeOrder
                                title:@"订单"
                                selTitle : @"订单"
                                icon:@"IM_order_icon"
                                selIcon :@"IM_order_icon"
                                isSelected :false];
    JHChatMediaModel *model4 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeService
                                title:@"平台客服"
                                selTitle : @"平台客服"
                                icon:@"IM_service_icon"
                                selIcon :@"IM_service_icon"
                                isSelected :false];
    JHChatMediaModel *model5 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeBlack
                                title:@"拉黑"
                                selTitle : @"取消拉黑"
                                icon:@"IM_black_icon"
                                selIcon :@"IM_black_icon_grey"
                                isSelected :isBlack];
    JHChatMediaModel *model6 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeCoupon
                                title:@"代金券"
                                selTitle : @"代金券"
                                icon:@"IM_coupon_icon"
                                selIcon :@"IM_coupon_icon"
                                isSelected :false];
    JHChatMediaModel *model7 = [[JHChatMediaModel alloc]
                                initWithType:JHChatMediaTypeComplaint
                                title:@"举报"
                                selTitle : @"举报"
                                icon:@"IM_complaint_icon"
                                selIcon :@"IM_complaint_icon"
                                isSelected :false];
    
    [list appendObject:model1];
    [list appendObject:model2];
    [list appendObject:model3];
    [list appendObject:model4];
    [list appendObject:model5];
    
    if (isShowCoupon) { // 商家
        [list appendObject:model6];
    }
    
    [list appendObject:model7];
    
    return list;
}
@end
