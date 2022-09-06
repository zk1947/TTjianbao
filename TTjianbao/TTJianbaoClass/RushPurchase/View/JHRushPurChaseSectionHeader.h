//
//  JHRushPurChaseSectionHeader.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailCountdownView.h"
#import "JHRushPurBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRushPurChaseSectionHeader : UIView

/// 当前选中的index
@property(nonatomic) NSInteger  seletedIndex;

@property(nonatomic, strong) UIView * backView;

//秒杀时间段
@property (nonatomic, strong) NSArray<JHRushPurChaseSeckillTimeModel*> * seckillTimeList;

@property(nonatomic, strong) NSString * seckillCountdownDesc;

@property(nonatomic) NSInteger  seckillCountdown;

@end

NS_ASSUME_NONNULL_END
