//
//  JHMallSpecialTopicTableViewCell.h
//  TTjianbao
//
//  Created by 姜超 on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMallSpecialTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMallSpecialTopicTableViewCell : UITableViewCell
@property(nonatomic,strong) NSMutableArray<JHMallSpecialTopicModel *> * specialTopicModes;
@end

NS_ASSUME_NONNULL_END
