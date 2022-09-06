//
//  JHMessageCommentTableViewCell.h
//  TTjianbao
//  Descripiton:评论cell<社区>
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessageHeader.h"
#import "JHMessageLikesTableViewCell.h"

@interface JHMessageCommentTableViewCell : JHMessageLikesTableViewCell

@property (nonatomic, copy) JHActionBlocks actionEvents;
@end

