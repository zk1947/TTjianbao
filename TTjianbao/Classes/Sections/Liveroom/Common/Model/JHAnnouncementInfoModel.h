//
//  JHAnnouncementInfoModel.h
//  TTjianbao
//
//  Created by Donto on 2020/7/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAnnouncementInfoModel : NSObject

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *announcementId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) BOOL buttonLightFlag;  //完成添加按钮高亮标识，0不高亮，1高亮

@end

NS_ASSUME_NONNULL_END
