//
//  JHLiveRoomPKBottomView.h
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHLiveRoomPKInfoModel;

@protocol JHLiveRoomPKBottomViewDelegate <NSObject>
-(void)pressGoShopBtnEnter;

@end

@interface JHLiveRoomPKBottomView : UIView
@property(nonatomic,weak)id<JHLiveRoomPKBottomViewDelegate>delegate;
-(void)resetViewwithModel:(JHLiveRoomPKInfoModel *)model andType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
