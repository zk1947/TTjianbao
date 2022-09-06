//
//  JHPublishTopicDetailTableCell.h
//  TTjianbao
//  Description:话题-全部话题&创建话题cell
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPublishTopicModel.h"

@interface JHPublishTopicDetailTableCell : UITableViewCell

- (void)updateData:(JHPublishTopicDetailModel*)model;
@end

