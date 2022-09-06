//
//  JHAppraiseRecordModel.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/14.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAppraiseRecordModel : NSObject
@property (nonatomic, copy) NSString *recordTime;
@property (nonatomic, assign) NSInteger appraiseSecond;
//主播获取
@property (nonatomic, copy) NSString *viewerIcon;
@property (nonatomic, copy) NSString *viewerName;

//观众获取
/** 满意度 */
@property (nonatomic, assign) NSInteger anchorGrade;
@property (nonatomic, copy) NSString *anchorIcon;
@property (nonatomic, copy) NSString *anchorName;

@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSString *videoUrl;


@end
