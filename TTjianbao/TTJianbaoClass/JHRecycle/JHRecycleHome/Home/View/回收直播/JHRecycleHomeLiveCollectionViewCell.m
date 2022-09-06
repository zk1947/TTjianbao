//
//  JHRecycleHomeLiveCollectionViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeLiveCollectionViewCell.h"
#import "JHRecycleHomeModel.h"
#import "UIImageView+JHWebImage.h"

@interface JHRecycleHomeLiveCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backImgView;

@property (nonatomic, strong) UIView *statusBackView;
@property (nonatomic, strong) UIView *livingStatusView;
@property (nonatomic, strong) YYAnimatedImageView *playingImage;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *onlineCount;

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation JHRecycleHomeLiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - UI

- (void)setupUI{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //背景图片
    [self.backView addSubview:self.backImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    //直播状态
    [self.backView addSubview:self.statusBackView];
    [self.statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.top.equalTo(self.backView).offset(8);
    }];
    //状态动画
    [self.statusBackView addSubview:self.livingStatusView];
    [self.livingStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.statusBackView);
    }];
    [self.livingStatusView addSubview:self.playingImage];
    [self.playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.livingStatusView .mas_centerY);
        make.left.equalTo(self.livingStatusView .mas_left).offset(3);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    //直播
    [self.livingStatusView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.livingStatusView.mas_centerY);
        make.left.equalTo(self.playingImage.mas_right).offset(3);
        make.right.mas_equalTo(self.livingStatusView.mas_right).offset(-3);
    }];
    //多少人观看
    [self.statusBackView addSubview:self.onlineCount];
    [self.onlineCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.livingStatusView.mas_right).offset(3);
        make.right.equalTo(self.statusBackView.mas_right).offset(-3);
        make.centerY.equalTo(self.statusBackView);
        make.height.equalTo(self.statusBackView);
    }];
    
    UIImageView *infoView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video_list_bottom_back"]];
    [self.backView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset(0);
        make.left.right.equalTo(self.backView);
        make.height.offset(50);
    }];
    
    //头像
    [self.backView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(8);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    //昵称
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(7);
        make.right.equalTo(self.backView).offset(-7);
        make.centerY.equalTo(self.headImgView);
    }];

}

- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHHomeRecycleLiveListModel *liveListModel = dataModel;
    
    [self.backImgView jh_setImageWithUrl:liveListModel.liveImage placeHolder:@"newStore_default_placehold"];
    
//    @weakify(self)
//    [self.backImgView jhSetImageWithURL:[NSURL URLWithString:liveListModel.liveImage] placeholder:kDefaultNewStoreCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
//        if (!image) {
//            @strongify(self)
//            self.backImgView.contentMode = UIViewContentModeScaleAspectFill;
//        }
//    }];
    
    
    [self.headImgView jh_setImageWithUrl:liveListModel.anchorImg placeHolder:@"icon_live_default_avatar"];
    self.nameLabel.text = liveListModel.anchorName;
    
    if ([liveListModel.liveStatus integerValue] == 2) {
        self.playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
        self.statusLabel.text = @"直播";
        self.onlineCount.text = [NSString stringWithFormat:@"%@热度",liveListModel.watchTotalString];
        self.livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
        self.statusLabel.textColor = HEXCOLOR(0x333333);
   
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.livingStatusView.mas_centerY);
            make.left.equalTo(self.playingImage.mas_right).offset(3);
            make.right.mas_equalTo(self.livingStatusView.mas_right).offset(-3);
        }];
        [self.onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.livingStatusView.mas_right).offset(3);
            make.right.equalTo(self.statusBackView.mas_right).offset(-3);
        }];
    }
    else {
        self.onlineCount.text = @"";
        self.statusLabel.text = @"休息中";
        self.statusLabel.textColor = HEXCOLOR(0xffffff);
        self.livingStatusView.backgroundColor = HEXCOLOR(0x808ba3);
        self.playingImage.image = [UIImage imageNamed:@""];
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.livingStatusView.mas_centerY);
            make.left.equalTo(self.playingImage.mas_left);
            make.right.mas_equalTo(self.livingStatusView.mas_right).offset(-3);
        }];
        [self.onlineCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.livingStatusView.mas_right);
            make.right.equalTo(self.statusBackView.mas_right);
        }];
    }


}

#pragma mark - Lazy

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = UIColor.clearColor;
        _backImgView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _backImgView;
}
- (UIView *)statusBackView{
    if (!_statusBackView) {
        _statusBackView = [[UIView alloc] init];
        _statusBackView.backgroundColor = HEXCOLORA(0x6e6e6e, 0.6);
        _statusBackView.layer.cornerRadius = 3;
        _statusBackView.clipsToBounds = YES;
    }
    return _statusBackView;
}
- (UIView *)livingStatusView{
    if (!_livingStatusView) {
        _livingStatusView = [[UIView alloc] init];
        _livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
    }
    return _livingStatusView;
}

- (YYAnimatedImageView *)playingImage{
    if (!_playingImage) {
        _playingImage = [[YYAnimatedImageView alloc]init];
        _playingImage.contentMode = UIViewContentModeScaleAspectFit;
        _playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
    }
    return _playingImage;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"直播";
        _statusLabel.font = [UIFont fontWithName:kFontMedium size:10];
        _statusLabel.textColor= kColor333;
        _statusLabel.numberOfLines = 1;
        _statusLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _statusLabel;
}
- (UILabel *)onlineCount{
    if (!_onlineCount) {
        _onlineCount = [[UILabel alloc] init];
        _onlineCount.text = @"25万热度";
        _onlineCount.font = [UIFont fontWithName:kFontNormal size:10];
        _onlineCount.textColor = HEXCOLOR(0xffffff);
        _onlineCount.numberOfLines = 1;
        _onlineCount.clipsToBounds = YES;
        _onlineCount.textAlignment = NSTextAlignmentLeft;
        _onlineCount.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _onlineCount;
}
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.backgroundColor = UIColor.redColor;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 14;
        _headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImgView.layer.borderWidth = 1.f;
        
    }
    return _headImgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"新疆籽玉世家的旗舰店";
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _nameLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _nameLabel;
}
@end
