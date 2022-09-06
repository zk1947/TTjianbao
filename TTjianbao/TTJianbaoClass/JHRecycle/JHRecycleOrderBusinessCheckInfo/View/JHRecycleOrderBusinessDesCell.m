//
//  JHRecycleOrderBusinessDesCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessDesCell.h"
@interface JHRecycleOrderBusinessDesCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation JHRecycleOrderBusinessDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
#pragma mark - Private Functions


#pragma mark - Bind
- (void)bindData {
    
    RAC(self.titleLabel, attributedText) = [RACObserve(self.viewModel, attDesText)
                                            takeUntil:self.rac_prepareForReuseSignal];
    
}
#pragma mark - setupUI
- (void)setupUI {
    [self addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ContentLeftSpace);
        make.right.equalTo(self).offset(-ContentLeftSpace);
        make.top.equalTo(self).offset(0);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderBusinessDesViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
@end
