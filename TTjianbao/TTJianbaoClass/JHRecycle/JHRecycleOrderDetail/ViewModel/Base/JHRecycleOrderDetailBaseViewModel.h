//
//  JHRecycleOrderBaseViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-BaseViewModel

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetail.h"

typedef NS_ENUM(NSInteger, RecycleOrderDetailCellType){
    /// 订单信息栏
    RecycleOrderDetailInfoCell,
    RecycleOrderDetailInfoTopCell,
    RecycleOrderDetailInfoBottomCell,
    /// 客服栏
    RecycleOrderDetailServiceCell,
    /// 商品信息栏
    RecycleOrderDetailProductCell,
    /// 地址栏
    RecycleOrderDetailAddressCell,
    /// 点单状态栏Title
    RecycleOrderDetailStatusTitleCell,
    /// 点单状态栏-描述
    RecycleOrderDetailStatusDescribeCell,
    /// 商家验收
    RecycleOrderDetailCheckCell,
    /// 仲裁
    RecycleOrderDetailArbitrationCell,
    
};


NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailBaseViewModel : NSObject
@property (nonatomic, assign)RecycleOrderDetailCellType cellType;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) RACSubject *reloadCell;
@property (nonatomic, strong) RACSubject *clickEvent;
@property (nonatomic, strong) RACSubject *reloadData;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) NSInteger rowIndex;

@property (nonatomic, assign) RecycleOrderDetailCornerType rectCornerType;


@end

NS_ASSUME_NONNULL_END
