//
//  JHPublishTopicRecordTableCell.h
//  TTjianbao
//  Description:话题-历史记录&已选话题cell (height:15<上间距>+21<title>+10<间距>+24<topic>+5<下间距>)
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCollectionView.h"

//历史记录
@interface JHPublishTopicRecordTableCell : UITableViewCell

@property (nonatomic, weak) id<JHDetailCollectionDelegate> delegate;
@property (nonatomic, copy) JHActionBlock deleteTopicBlock;

- (void)updateData:(NSArray*)array;
@end

//选中话题-带x删除
@interface JHPublishTopicRecordTableCellExt : JHPublishTopicRecordTableCell

@end
