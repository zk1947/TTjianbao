//
//  JHPlateDetailController.h
//  TTjianbao
//  板块详情
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateDetailController : JHBaseViewController

///板块ID
@property (nonatomic, copy) NSString *plateId;
@property (nonatomic, copy) NSString *plateName;
///页面来源
@property (nonatomic, copy) NSString *pageFrom;

@end

NS_ASSUME_NONNULL_END

/*
 NSString *urlStr = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/community/communitySection/communitySection.html?plateId=%@"), plateId];
 
分享统计（类型暂按原定义累加）
从话题主页分享话题：object_type=15，from=10，object_flag=话题id
从版块主页分享版块：object_type=16，from=11，object_flag=版块id
*/
