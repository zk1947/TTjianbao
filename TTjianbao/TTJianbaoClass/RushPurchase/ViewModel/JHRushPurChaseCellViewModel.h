//
//  JHRushPurChaseCellViewModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRushPurChaseModel.h"

typedef NS_ENUM(NSUInteger, JHRushPurChaseCell_Status) {
    JHRushPurChaseCell_Status_RushPur  =  0,
    JHRushPurChaseCell_Status_Empty,
    JHRushPurChaseCell_Status_ReMind,
    JHRushPurChaseCell_Status_ReMinded,
    JHRushPurChaseCell_Status_XiaJia,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHRushPurChaseCellViewModel : NSObject

@property(nonatomic, strong) NSString * leftImageUrl;

@property(nonatomic, strong) NSString * title;
//营销标签
@property (nonatomic, strong) NSArray<NSString*> * productTagList;

@property(nonatomic, strong) NSAttributedString * currentPriceAtt;

@property(nonatomic, strong) NSAttributedString * basePriceAtt;

@property(nonatomic) JHRushPurChaseCell_Status status;

@property (nonatomic) NSInteger seckillProgress;

@property(nonatomic, strong) NSString * productId;

@property(nonatomic, strong) NSString * showId;

@property (nonatomic, strong) NSString*  saveMoney;

@property (nonatomic) NSInteger sellStock;


+ (JHRushPurChaseCellViewModel*)rushPurChaseCellViewModelWithModel:(JHRushPurChaseSeckillProductInfoModel*)model;

@end

NS_ASSUME_NONNULL_END
