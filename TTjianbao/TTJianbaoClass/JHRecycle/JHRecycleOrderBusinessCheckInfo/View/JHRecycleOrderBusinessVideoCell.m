//
//  JHRecycleOrderBusinessVideoCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessVideoCell.h"
@interface JHRecycleOrderBusinessVideoCell()

@property (nonatomic, strong) UIButton *playButton;
@end
@implementation JHRecycleOrderBusinessVideoCell

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
- (void)didClickPlay : (UIButton *)sender {
    if (self.viewModel.videoUrl == nil) return;
    [self.viewModel.playEvent sendNext:nil];
    self.bgImageView.hidden = true;
    self.playButton.hidden = true;
}
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
    [self addSubview:self.videoView];
    [self.videoView addSubview:self.bgImageView];
    [self addSubview:self.playButton];
}
- (void)layoutViews {
    [self.videoView jh_cornerRadius:4];
   
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ContentLeftSpace);
        make.right.equalTo(self).offset(-ContentLeftSpace);
        make.top.bottom.equalTo(self);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoView);
//        make.left.equalTo(self.videoView).offset(ContentLeftSpace);
//        make.right.equalTo(self.videoView).offset(-ContentLeftSpace);
//        make.top.bottom.equalTo(self.videoView);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderBusinessVideoViewModel *)viewModel {
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
- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoView.backgroundColor = UIColor.whiteColor;
    }
    return _videoView;
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.jh_imageName(@"newStore_play_icon")
        .jh_action(self, @selector(didClickPlay:));
    }
    return _playButton;
}
@end
