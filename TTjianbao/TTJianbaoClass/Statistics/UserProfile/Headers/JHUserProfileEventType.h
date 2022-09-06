//
//  JHUserProfileEventType.h
//  TTjianbao
//  Description:用户画像事件类型(event type)
//  Created by Jesse on 2020/8/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHUserProfileEventType_h
#define JHUserProfileEventType_h

//MARK: # 浏览时长对应的关键字
#define JHUPBrowseKey @"type" //浏览时长key
#define JHUPBrowseBegin @"0" //浏览开始
#define JHUPBrowseEnd @"1" //浏览结束

///事件key
#define JHUPEventKey @"status"

///事件开始
#define JHUPEventKeyBegin @"0"

///事件结束
#define JHUPEventKeyEnd @"1"

/************************新的头文件加在此处以下***********************/
#import "JHUserProfileSourceMall.h"
#import "JHUserProfileCommunity.h"
#import "JHUserProfileAppraise.h"


#endif /* JHUserProfileEventType_h */
