//
//  JHOrderProductView.h
//  TTjianbao
//
//  Created by jiang on 2020/5/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderProductView : JHOrderSubBaseView
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
@property(nonatomic,strong) UILabel * orderStatusLabel;
-(void)initStoneProductViews;
-(void)ConfigCategoryTagTitle:(JHOrderDetailMode*)mode;
@end

NS_ASSUME_NONNULL_END
