//
//  JHCoverCollectionViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/22.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHCoverCollectionViewCell.h"

@implementation JHCoverCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(JHCoverModel *)model {
    _model = model;
    self.coverBtn.selected = model.isDefault;
    self.deleteBtn.hidden = model.isDefault;
    self.coverBtn.tag = self.tag;
    self.deleteBtn.tag = self.tag;
    
}

- (IBAction)seletedAction:(id)sender {
    if (self.clickAction) {
        self.clickAction(sender);
    }
}

- (IBAction)deleteAction:(id)sender {
    if (self.deleteAction) {
        self.deleteAction(sender);
    }
}


@end
