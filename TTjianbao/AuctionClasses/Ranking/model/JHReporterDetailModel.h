//
//  JHReporterDetailModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHReporterDetailModel : NSObject
@property (nonatomic, copy)NSString *anchorName; // "\U7ea2\U7ea2";
@property (nonatomic, copy)NSString *appraiseId; // 689;
@property (nonatomic, copy)NSString *appraisePrice; // 70000;
@property (nonatomic, copy)NSString *appraisePriceStr; // "7\U4e07";
@property (nonatomic, copy)NSString *createDate; // "2019-02-18";
@property (nonatomic, copy)NSString *videoCoverImg; // "https://jianhuo-test.nos-eastchina1.126.net/user_dir/apply_appraisal/15504716455183899.jpg";
@property (nonatomic, assign)NSInteger videoDuration; // 41;
@property (nonatomic, copy)NSString *videoTitle; // hshsh;
@property (nonatomic, copy)NSString *viewerName; // "\U738b";
@property (nonatomic, assign)NSInteger isGenuine;  //0 假 1真 2未知
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *cateId;
@property (nonatomic, copy)NSString *cateName;
@property (strong,nonatomic)NSString * goodsHolder;
@property (assign,nonatomic)BOOL isLaud;//是否点赞
@property (strong,nonatomic)NSString * lauds;//点赞数
@property (strong,nonatomic)NSString * viewedTimes;
@property (strong,nonatomic)NSString * viewedTimesStr;

@end

NS_ASSUME_NONNULL_END
