//
//  JHAudienceListView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/7.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#define showCount ((ScreenW>375)?5:((ScreenW==375)?4:3))

#import "BaseView.h"

@interface JHAudienceListView : BaseView

- (void)reloadData:(NSMutableArray *)array;
@end
