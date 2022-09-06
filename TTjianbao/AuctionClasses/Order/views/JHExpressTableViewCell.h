//
//  JHExpressTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CornerRadius.h"
#import "ExpressMode.h"
#import "JHOrderExpressViewMode.h"

@interface JHExpressTableViewCell : UITableViewCell
@property(strong,nonatomic)ExpressRecord * expressMode;
@property(strong,nonatomic)ExpressAppraiseMode *expressAppraiseMode;
@property(strong,nonatomic)orderStatusLogVosModel *orderStatusLogMode;
-(void)setCellIndex:(NSInteger)cellIndex andListCount:(NSInteger)count andViewMode:(JHOrderExpressViewMode*)viewMode andSectionType:(JHExpressSectionType)sectionType;
@end

