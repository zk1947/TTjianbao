//
//  JXCategoryTitleAttributeView.h
//  JXCategoryView
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleAttributeCell.h"
#import "JXCategoryTitleAttributeCellModel.h"

@implementation JXCategoryTitleAttributeCell

- (void)initializeViews {
    [super initializeViews];

    self.titleLabel.numberOfLines = 2;
    self.maskTitleLabel.numberOfLines = 2;
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    JXCategoryTitleAttributeCellModel *myCellModel = (JXCategoryTitleAttributeCellModel *)cellModel;

    self.titleLabel.numberOfLines = myCellModel.titleNumberOfLines;
    if (myCellModel.isSelected && myCellModel.selectedAttributeTitle != nil) {
        self.titleLabel.attributedText = myCellModel.selectedAttributeTitle;
    }else {
        self.titleLabel.attributedText = myCellModel.attributeTitle;
    }

    self.maskTitleLabel.numberOfLines = myCellModel.titleNumberOfLines;
    if (myCellModel.isSelected && myCellModel.selectedAttributeTitle != nil) {
        self.maskTitleLabel.attributedText = myCellModel.selectedAttributeTitle;
    }else {
        self.maskTitleLabel.attributedText = myCellModel.attributeTitle;
    }
}



@end
