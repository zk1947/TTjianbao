//
//  JHSaleLiveRoomCustomizeList.h
//  TTjianbao
//
//  Created by apple on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSaleLiveRoomCustomizeListModel : NSObject
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *roomId;
@end

@interface JHSaleLiveRoomCustomizeList : UIView
@property (nonatomic, copy) NSString *channelLocalId;
@end

NS_ASSUME_NONNULL_END
