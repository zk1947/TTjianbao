//
//  JHBusinessFansGradeEditTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessFansSettingApplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansGradeEditTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isLastLine;
@property (nonatomic, strong) JHBusinessFansLevelMsgListApplyModel *model;
@property (nonatomic, strong) NSArray *levelArray;
@property (nonatomic,   copy) dispatch_block_t changeBlock;
- (void)setTextFieldText:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
