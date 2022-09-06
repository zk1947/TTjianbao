//
//  JHPostDetailVideoTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailVideoTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "JHPostDetailModel.h"

@interface JHPostDetailVideoTableCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end


    
@implementation JHPostDetailVideoTableCell

- (void)setResourceModel:(JHPostDetailResourceModel *)resourceModel {
    if (!resourceModel) {
        return;
    }
    
    _resourceModel = resourceModel;
    NSString *imgUrl = _resourceModel.data[@"video_cover_url"];
    if (![imgUrl hasPrefix:@"http"]) {
        imgUrl = [NSString stringWithFormat:@"%@%@", ALIYUNCS_FILE_BASE_STRING(@"/"), imgUrl];
    }

    [self.coverImageView jhSetImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.bgImgView];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.playBtn];
//    [self.coverImageView addGestureRecognizer:self.tapGesture];
    [self makeLayouts];
}

- (void)makeLayouts {
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 10, 15));
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 10, 15));
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.center.equalTo(self.coverImageView);
    }];
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"sq_video_icon_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = kColor333;
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = kPlayerViewTag;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 8.f;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.clipsToBounds = YES;
        _bgImgView.layer.cornerRadius = 8.f;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    }
    return _tapGesture;
}

- (void)playClick {
    if (self.playCallback) {
        self.playCallback(self);
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
