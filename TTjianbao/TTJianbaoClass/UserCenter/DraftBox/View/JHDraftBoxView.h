//
//  JHDraftBoxView.h
//  TTjianbao
//  Description:社区-草稿箱View
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTableViewExt.h"

@interface JHDraftBoxView : JHTableViewExt

@property (nonatomic, copy) JHActionBlock finishAction;

- (instancetype)initWitEditType:(BOOL)editing;
- (void)refreshView;
@end


