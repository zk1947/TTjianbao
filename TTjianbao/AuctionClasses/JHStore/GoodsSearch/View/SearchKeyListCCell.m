//
//  SearchKeyListCCell.m
//  ForkNews
//
//  Created by wuyd on 2018/5/14.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import "SearchKeyListCCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface SearchKeyListCCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SearchKeyListCCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF0F0F0);
        self.layer.cornerRadius = self.contentView.height/2;
        self.layer.masksToBounds = YES;
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
            _titleLabel.textColor = HEXCOLOR(0x333333);
            _titleLabel.frame = CGRectMake(0, 0, self.width, self.height);
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            //下面两行代码需要一起配合使用，不然不会居中
//            _titleLabel.adjustsFontSizeToFitWidth = YES;
//            _titleLabel.minimumScaleFactor = 0.8;
//            _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [self.contentView addSubview:_titleLabel];
            
            _titleLabel.sd_layout
            .topSpaceToView(self.contentView, 0)
            .leftSpaceToView(self.contentView, 13)
            .rightSpaceToView(self.contentView, 13)
            .bottomSpaceToView(self.contentView, 0);
        }
    }
    return self;
}

- (void)setKeyData:(CSearchKeyData *)keyData {
    _keyData = keyData;
    _titleLabel.text = keyData.keyword;
}

- (void)setKeyData:(CSearchKeyData *)keyData isHot:(BOOL)isHot {
    _keyData = keyData;
    _titleLabel.text = keyData.keyword;
    
    if (isHot) {
        self.backgroundColor = HEXCOLOR(0xF0F0F0);
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    }
}

@end
