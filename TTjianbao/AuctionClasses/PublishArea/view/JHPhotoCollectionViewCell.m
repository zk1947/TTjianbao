//
//  JHPhotoCollectionViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPhotoCollectionViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@implementation JHPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImage.layer.cornerRadius = 2;
    self.photoImage.layer.masksToBounds = YES;
    self.showVideoBt = NO;
}

- (void)setShowVideoBt:(BOOL)showVideoBt {
    self.videoImageView.hidden = !showVideoBt;
}

- (BOOL)showVideoBt {
    return !self.videoImageView.hidden;
}


- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.sd_indexPath);
    }
}

@end
