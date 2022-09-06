//
//  JHMallSectionModel.h
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESAudienceLiveViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JHMallSectionType) {
     JHMallSectionTypeMallGroup,          ///普通
     JHMallSectionTypeWatchTrack,             ///足迹
     JHMallSectionTypeFollow,              ///关注
     JHMallSectionTypeRecommend,               ///推荐
};
@interface JHMallSectionModel : NSObject
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) JHMallSectionType sectionType;
@property (nonatomic, assign) JHGestureChangeLiveRoomFromType listFromType;
@end

NS_ASSUME_NONNULL_END
