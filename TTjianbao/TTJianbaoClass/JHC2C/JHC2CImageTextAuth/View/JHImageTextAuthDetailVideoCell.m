//
//  JHImageTextAuthDetailVideoCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextAuthDetailVideoCell.h"

@interface JHImageTextAuthDetailVideoCell ()

@property (nonatomic, strong) UIImageView *imagev;

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation JHImageTextAuthDetailVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    _imagev = [[UIImageView alloc]init];
    _imagev.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imagev];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:JHImageNamed(@"recycle_video_icon") forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.mas_equalTo(self.contentView);
    }];
}

- (void)setModel:(JHImageTextWaitAuthDetailVideoModel *)model{
    _model = model;
    [_imagev jhSetImageWithURL:[NSURL URLWithString:_model.converUrl] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
}

- (void)playButtonAction:(UIButton *)btn{
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:_model];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
