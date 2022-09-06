//
//  JHContactCell.h
//  TTjianbao
//
//  Created by YJ on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHContactUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHContactCell : UITableViewCell

@property (strong, nonatomic) JHContactUserInfoModel *model;

@end

NS_ASSUME_NONNULL_END
