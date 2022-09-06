//
//  HomeTableViewHeader.h
//  TTjianbao
//
//  Created by jiangchao on 2018/11/27.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerMode;

typedef NS_ENUM(NSUInteger,HomeHeaderButtonType) {
    
    HeaderButtonTypeFreeAppraisal=1 ,
    HeaderButtonTypeExpert,
    HeaderButtonTypeAllAppraisal,
    HeaderButtonTypeServe,
};

@protocol HomeTableViewHeaderDelegate <NSObject>

@optional
-(void)bannerTap:(BannerMode*)banner;
-(void)headerButtonPress:(UIButton*)btn;
@end
#import "BaseView.h"

@interface HomeTableViewHeader : BaseView
@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)NSArray * banners;

@property(weak,nonatomic)id<HomeTableViewHeaderDelegate>delegate;
@end


