//
//  UITitleBarBackgroundCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITitleBarBackgroundCell.h"
#import "UITitleBarBackgroundCellModel.h"

@interface UITitleBarBackgroundCell()
@property (nonatomic, strong) CALayer *bgLayer;
@end

@implementation UITitleBarBackgroundCell

- (void)initializeViews {
    [super initializeViews];

    self.bgLayer = [CALayer layer];
    [self.contentView.layer insertSublayer:self.bgLayer atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UITitleBarBackgroundCellModel *myCellModel = (UITitleBarBackgroundCellModel *)self.cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGFloat bgWidth = self.contentView.bounds.size.width;
    if (myCellModel.bgWidth != JXCategoryViewAutomaticDimension) {
        bgWidth = myCellModel.bgWidth;
    }
    CGFloat bgHeight = self.contentView.bounds.size.height;
    if (myCellModel.bgHeight != JXCategoryViewAutomaticDimension) {
        bgHeight = myCellModel.bgHeight;
    }
    self.bgLayer.bounds = CGRectMake(0, 0, bgWidth, bgHeight);
    self.bgLayer.position = self.contentView.center;
    [CATransaction commit];
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    UITitleBarBackgroundCellModel *myCellModel = (UITitleBarBackgroundCellModel *)cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.bgLayer.borderWidth = myCellModel.borderLineWidth;
    self.bgLayer.cornerRadius = myCellModel.bgCornerRadius;
    if (myCellModel.isSelected) {
        self.bgLayer.backgroundColor = myCellModel.selectedBgColor.CGColor;
        self.bgLayer.borderColor = myCellModel.selectedBorderColor.CGColor;
    } else {
        self.bgLayer.backgroundColor = myCellModel.normalBgColor.CGColor;
        self.bgLayer.borderColor = myCellModel.normalBorderColor.CGColor;
    }
    [CATransaction commit];
}

@end
