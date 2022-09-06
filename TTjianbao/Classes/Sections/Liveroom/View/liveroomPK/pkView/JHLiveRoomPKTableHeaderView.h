//
//  JHLiveRoomPKTableHeaderView.h
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHLiveRoomPKModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomPKTableHeaderView : UIImageView
@property(nonatomic,copy)void(^headerClickBlock)(NSString *roomId);
- (instancetype)initWithFrame:(CGRect)frame andModel:(JHLiveRoomPKModel *)model andType:(NSString *)type andIsShowUserInfo:(BOOL)isShowUserInfo;
@end

NS_ASSUME_NONNULL_END
