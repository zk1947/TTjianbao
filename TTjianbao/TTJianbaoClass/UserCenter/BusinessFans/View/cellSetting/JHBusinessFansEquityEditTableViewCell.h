//
//  JHBusinessFansEquityEditTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessFansSettingApplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansEquityEditTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isLastLine;
@property (nonatomic, strong) JHBusinessFansRewardConfigVoListApplyModel *model;
@property (nonatomic,   copy) dispatch_block_t changeBlock;

@property (nonatomic,   copy) dispatch_block_t showYouHuiQuanBlock;

@property (nonatomic, strong) UILabel        *titleNameLabel;
@property (nonatomic, strong) UIView         *lineView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray <UITextField*>*textFieldArray;

@property (nonatomic, strong) UIView         *addView;
@property (nonatomic, strong) UILabel        *codeLbl;

- (void)equityEditInfoCallBack;
@end

NS_ASSUME_NONNULL_END
