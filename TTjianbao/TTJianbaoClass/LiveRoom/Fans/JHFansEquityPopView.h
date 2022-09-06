//
//  JHFansEquityPopView.h
//  TTjianbao
//
//  Created by liuhai on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFansEquityPopView : UIView
@property (nonatomic,copy) NSString *fansClubId;
@property (nonatomic, copy) void (^joinFansClubVlock)(void);
- (instancetype)initWithAnchorId:(NSString *)anchorId andisFans:(BOOL)isfans;

//埋点用
@property (nonatomic,copy) NSString * channel_name;
@property (nonatomic,copy) NSString * channel_id;
@end

NS_ASSUME_NONNULL_END
