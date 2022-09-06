//
//  JHFansTaskCell.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFansClubModel.h"
#import "JHUIFactory.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansTaskCell : UITableViewCell
@property (nonatomic, strong) JHFansTaskModel * fansTaskModel;
@property (nonatomic, copy) JHActionBlock  buttonAction;
@property (nonatomic, strong) JHCustomLine *line;
@end

NS_ASSUME_NONNULL_END
