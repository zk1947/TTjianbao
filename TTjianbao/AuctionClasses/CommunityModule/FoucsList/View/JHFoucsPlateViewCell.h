//
//  JHFoucsPlateViewCell.h
//  TTjianbao
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHFoucsPlateModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHFoucsPlateViewCell : UITableViewCell
-(void)resetCellDataWithModel:(JHFoucsPlateModel*)model;
@end

NS_ASSUME_NONNULL_END
