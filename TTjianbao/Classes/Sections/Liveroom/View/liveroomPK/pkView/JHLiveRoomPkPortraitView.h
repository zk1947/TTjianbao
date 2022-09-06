//
//  JHLiveRoomPkPortraitView.h
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomPkPortraitView : BaseView
+ (UIView *)headPortrait:(CGSize)size andranking:(NSInteger)ranking andUrl:(NSString *)url isLive:(BOOL)islive;

+ (UILabel *)rankingLabel:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
