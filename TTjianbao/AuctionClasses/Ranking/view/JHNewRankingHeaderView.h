//
//  JHNewRankingHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@class BannerMode;
@protocol JHNewRankingHeaderViewDelegate <NSObject>

@optional
-(void)bannerTap:(BannerMode*)banner;
@end

@interface JHNewRankingHeaderView : BaseView
@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)NSArray * banners;

@property(weak,nonatomic)id<JHNewRankingHeaderViewDelegate>delegate;
@end
