//
//  MallHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerMode;
@protocol JHMallHeaderViewDelegate <NSObject>

@optional
-(void)bannerTap:(BannerMode*)banner;
-(void)headerButtonPress:(UIButton*)btn;
@end
#import "BaseView.h"

#define TipsHeight ((int)ceil((58.*(ScreenW-40.))/335.+20.))
@interface JHMallHeaderView : BaseView
@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)NSArray * banners;
@property (nonatomic, copy) NSString *orderCount;

@property(weak,nonatomic)id<JHMallHeaderViewDelegate>delegate;
@end
