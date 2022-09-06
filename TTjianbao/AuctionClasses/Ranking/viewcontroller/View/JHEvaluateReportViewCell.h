//
//  JHEvaluateReportViewCell.h
//  TTjianbao
//
//  Created by Jesse on 2020/7/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEvaluateReportModel.h"

@protocol JHEvaluateReportViewCellDelegate <NSObject>

- (void)pressTitleAction;
@end

@interface JHEvaluateReportViewCell : UICollectionViewCell

@property (nonatomic, weak) id<JHEvaluateReportViewCellDelegate>mDelegate;

- (void)updateData:(id)model;
@end


