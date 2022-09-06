//
//  JHImageAppraisalFinishedCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHImageAppraisalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHImageAppraisalFinishedCell : UITableViewCell
- (void)setCellModelData:(JHImageAppraisalRecordInfoModel *)model withType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
