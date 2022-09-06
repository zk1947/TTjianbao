//
//  JHRecycleOrderImageCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessImageCell.h"

@interface JHRecycleOrderBusinessImageCell()
/// 背景图
@property (nonatomic, strong) YYAnimatedImageView *bgImageView;
@end

@implementation JHRecycleOrderBusinessImageCell

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
    @weakify(self)
    [[RACObserve(self.viewModel, imageUrl)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.bgImageView jh_setImageWithUrl:x placeHolder: @"newStore_default_header_placeholder"];
    }];
    
}
#pragma mark - setupUI
- (void)setupUI {
    [self addSubview:self.bgImageView];
}
- (void)layoutViews {
    [self.bgImageView jh_cornerRadius:4];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ContentLeftSpace);
        make.right.equalTo(self).offset(-ContentLeftSpace);
        make.top.bottom.equalTo(self);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderBusinessImageViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (YYAnimatedImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _bgImageView;
}
@end
