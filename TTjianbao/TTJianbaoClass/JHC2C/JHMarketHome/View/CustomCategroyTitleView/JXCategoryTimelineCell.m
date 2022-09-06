//
//  JXCategoryTimelineCell.m
//  JXCategoryView
//
//  Created by jiaxin on 2019/7/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "JXCategoryTimelineCell.h"
#import "JXCategoryTimelineCellModel.h"

@interface JXCategoryTimelineCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) JXCategoryTimelineCellModel *indexModel;
@end

@implementation JXCategoryTimelineCell

- (void)initializeViews
{
    [super initializeViews];

    _timeLabel = [[UILabel alloc] init];
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.timeLabel];

    NSLayoutConstraint *timeLabelCenterX = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *timeLabelCenterY = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    [NSLayoutConstraint activateConstraints:@[timeLabelCenterX, timeLabelCenterY]];
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    JXCategoryTimelineCellModel *myCellModel = (JXCategoryTimelineCellModel *)cellModel;
    _indexModel = myCellModel;
    self.timeLabel.text = myCellModel.timeTitle;
    if (myCellModel.isSelected) {
        self.timeLabel.textColor = myCellModel.timeTitleSelectedColor;
        self.timeLabel.font = myCellModel.timeTitleSelectedFont;
    }else {
//        self.timeLabel.textColor = myCellModel.timeTitleNormalColor;
        self.timeLabel.textColor = _tabAlpha <= 0.0 ? kColor999 : kColor666;
        self.timeLabel.font = myCellModel.timeTitleFont;
    }
    //更新透明度
//    self.titleLabel.alpha = myCellModel.tabAlpha;
}

- (void)setTabAlpha:(CGFloat)tabAlpha{
    _tabAlpha = tabAlpha;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //处理UI
        self.titleLabel.alpha = _tabAlpha;
        if (!_indexModel.isSelected) {
            self.timeLabel.textColor = _tabAlpha <= 0.0 ? kColor999 : kColor666;
        }
     });
}

@end
