//
//  JHDraftBoxTextTableCell.h
//  TTjianbao
//  Description:基类>title+content和时间
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHDraftBoxModel.h"

#define kVerticalMargin 10
#define kLeftRightMargin 15
#define kEditImageSize 25
#define kEditingRightMargin (kEditImageSize + kLeftRightMargin) //15间距

@protocol JHDraftBoxTextTableCellDelegate <NSObject>

- (void)pressCellEvent;
@end

@interface JHDraftBoxTextTableCell : UITableViewCell

@property (nonatomic, weak) id<JHDraftBoxTextTableCellDelegate>delegate;
@property (nonatomic, assign) CGFloat editingMargin;
//默认:非编辑样式
@property (nonatomic, strong) UIButton* editImage;
@property (nonatomic, strong) UIButton* bgView;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIImageView* contentImage;

- (void)drawSubviews;
- (void)drawEditSubviews; //修改为编辑样式
- (void)updateData:(JHDraftBoxModel*)model;

@end


