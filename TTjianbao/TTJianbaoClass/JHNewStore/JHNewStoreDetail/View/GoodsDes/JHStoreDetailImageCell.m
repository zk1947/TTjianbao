//
//  JHStoreDetailImageCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailImageCell.h"
#import "UIImageView+JHWebImage.h"

@interface JHStoreDetailImageCell()
@property (nonatomic, strong) UIImageView *bgImageView;
@end
@implementation JHStoreDetailImageCell

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
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    @weakify(self)
    [[RACObserve(self.viewModel, imageUrl)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        NSURL *url = [NSURL URLWithString:x];
        [self.bgImageView jhSetImageWithURL:url placeholder:[UIImage imageNamed:@"newStore_default_placehold"]];
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.bgImageView];
}
- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0).inset(12);
        make.top.bottom.equalTo(@0).inset(4);
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailImageViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
 //       _bgImageView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

@end
