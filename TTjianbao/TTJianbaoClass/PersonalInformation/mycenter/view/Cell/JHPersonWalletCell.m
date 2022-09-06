//
//  JHPersonWalletCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPersonWalletCell.h"
#import "JHMyCenterDotModel.h"
#import <NSString+YYAdd.h>
#import "JHMySectionModel.h"
#import "JHMyCenterDotNumView.h"

@interface JHPersonWalletCell ()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *countLabel;

@end
@implementation JHPersonWalletCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.countLabel = [UILabel new];
        self.countLabel.font =  JHDINBoldFont(19);
        self.countLabel.textColor = HEXCOLOR(0x222222);
                
        self.labelTitle = [UILabel new];
        self.labelTitle.font = JHFont(12);
        self.labelTitle.textColor = HEXCOLOR(0x222222);
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.labelTitle];
        
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.labelTitle.mas_bottom).offset(2);
            make.centerX.equalTo(self.contentView);
        }];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
        }];

        
        
    }
    return self;
}

- (void)setModel:(JHMyCellModel *)model {
    _model = model;
    self.labelTitle.text = model.title;
    self.countLabel.text = model.countString;
}
@end
