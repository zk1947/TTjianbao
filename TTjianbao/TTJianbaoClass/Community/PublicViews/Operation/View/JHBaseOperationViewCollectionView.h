//
//  JHBaseOperationViewCollectionView.h
//  TTjianbao
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseOperationViewCell.h"

#define operationCellHeight 80
#define operationHeaderHeight 30

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseOperationViewCollectionView : UIView

@property (nonatomic, assign) JHOperationType operationType;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL showHeader;

@property (nonatomic, copy) void(^ operationBlock)(JHOperationType operationType);
@end

NS_ASSUME_NONNULL_END
