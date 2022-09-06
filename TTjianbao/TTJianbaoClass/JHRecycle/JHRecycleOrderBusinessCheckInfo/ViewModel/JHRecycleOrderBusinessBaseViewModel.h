//
//  JHRecycleOrderBusinessBaseViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetail.h"

typedef NS_ENUM(NSInteger, RecycleOrderBusinessCellType){
    RecycleOrderBusinessCellTypeDes,
    RecycleOrderBusinessCellTypeVideo,
    RecycleOrderBusinessCellTypeImage,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessBaseViewModel : NSObject
@property (nonatomic, assign) RecycleOrderBusinessCellType cellType;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
