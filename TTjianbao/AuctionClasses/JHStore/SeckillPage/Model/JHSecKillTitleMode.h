//
//  JHSecKillTitleMode.h
//  TTjianbao
//
//  Created by jiang on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSecKillTitleMode : NSObject

//"online_at": 1583898257,
//"ft_online_at": "2020-03-11 11:44:17",
@property (strong,nonatomic)NSString* sc_id;
@property (strong,nonatomic)NSString* ses_id;
@property (strong,nonatomic)NSString* title;
@property (strong,nonatomic)NSString* sub_title;
@property (strong,nonatomic)NSString* ft_online_at;//秒杀时间
@property (strong,nonatomic)NSString* ft_offline_at;//截止时间

@property (assign,nonatomic)NSTimeInterval  online_at;
@property (assign,nonatomic)NSTimeInterval  offline_at;

@property (assign,nonatomic)BOOL  is_selected; //
@end

NS_ASSUME_NONNULL_END
