//
//  JHStoneDetailTabelViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DetailSectionType)
{
    DetailSectionTypeTopInfo = 0,
    DetailSectionTypeOfferPrice,
    DetailSectionTypeTotal,
    DetailSectionTypeFamily,
    DetailSectionTypeChange,
};

@interface JHStoneDetailTabelViewModel : NSObject

@property (nonatomic, assign) DetailSectionType detailSectionType;

@property (nonatomic, copy) NSString *detailSectionTitle;

@end

NS_ASSUME_NONNULL_END
