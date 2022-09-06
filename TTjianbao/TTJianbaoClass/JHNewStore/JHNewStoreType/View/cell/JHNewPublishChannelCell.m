//
//  JHNewPublishChannelCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewPublishChannelCell.h"
#import "JHNewStoreTypeTableCellViewModel.h"

@interface JHNewPublishChannelCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *yellowView;

@end

@implementation JHNewPublishChannelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.font = JHFont(14);
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(7);
            make.right.equalTo(self.contentView).offset(-7);
        }];
        
        self.yellowView = [[UIView alloc] init];
        self.yellowView.backgroundColor = HEXCOLOR(0xFFD70F);
        [self.contentView addSubview:self.yellowView];
        [self.yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(@0);
            make.width.equalTo(@4);
            make.height.equalTo(@26);
        }];
        self.yellowView.hidden = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.font = JHMediumFont(14);
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.yellowView.hidden = NO;
    } else {
        self.titleLabel.font = JHFont(14);
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        
        self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
        
        self.yellowView.hidden = YES;
    }
}

- (void)setViewModel:(JHNewStoreTypeTableCellViewModel *)viewModel{
    _viewModel = viewModel;
    self.titleLabel.text = viewModel.cateName;
}
@end

