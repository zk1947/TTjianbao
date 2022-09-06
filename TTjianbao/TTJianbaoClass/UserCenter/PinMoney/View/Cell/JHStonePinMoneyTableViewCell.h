//
//  JHStonePinMoneyTableViewCell.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAccountFlowModel.h"
typedef void(^ClickBlock)(NSInteger cellIndex ,BOOL multiLine);
NS_ASSUME_NONNULL_BEGIN

@interface JHStonePinMoneyTableViewCell : UITableViewCell

//- (void)updateData:(JHAccountFlowModel*)model;
@property (nonatomic,copy) ClickBlock buttonBlock;

@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,strong) JHAccountFlowModel *model;
@end

NS_ASSUME_NONNULL_END
