//
//  JHPostDetailTextLinkCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kJHPostDetailTextLinkIdentifer = @"JHPostDetailTextLinkIdentifer";
@interface JHPostDetailTextLinkCell : UITableViewCell

- (void)setContent:(NSMutableAttributedString *)content isEssence:(BOOL)isEssence;
@end

