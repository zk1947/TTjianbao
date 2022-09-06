//
//  JHSeckillListViewController.h
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreApiManager.h"
#import "JHSecKillTitleMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSeckillListViewController : UIViewController
//本场次id
@property (nonatomic, strong) NSString *ses_id;
@property (nonatomic, strong) JHSecKillTitleMode *titleMode;
-(void)loadNewData;
@end

NS_ASSUME_NONNULL_END
