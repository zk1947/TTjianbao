//
//  JHLiveRoomSheetMoreView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBottomAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CurrentAudienceType) {
    CurrentAudienceTypeNormal,
    CurrentAudienceTypeCustom,
    CurrentAudienceTypeRecycle,
};

@interface JHLiveRoomSheetMoreView : JHBottomAnimationView
@property (nonatomic, assign) BOOL isCustomizeAudience;
@property (nonatomic, assign) CurrentAudienceType audienceType;
@property (nonatomic, assign) BOOL auctionHidden;
///  竞拍-0     发红包-1   投诉建议-2  客服-3
@property (nonatomic, copy) void (^ clickBlock) (NSInteger index);

+ (void)showSheetViewWithAuctionHidden:(BOOL)hidden isCustomizeAudience:(CurrentAudienceType)audienceType text:(NSString *)text block:(void (^)(NSInteger))clickBlock;

@end

NS_ASSUME_NONNULL_END
