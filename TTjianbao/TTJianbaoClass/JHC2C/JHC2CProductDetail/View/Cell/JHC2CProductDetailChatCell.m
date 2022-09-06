//
//  JHC2CProductDetailChatCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailChatCell.h"
#import "JHSQModel.h"

@interface JHC2CProductDetailChatCell()

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIView * lineView;
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * nameLbl;
@property(nonatomic, strong) UILabel * detaiLbl;
@property(nonatomic, strong) UILabel * timeLbl;
@property(nonatomic, strong) UIButton * likeBtn;
@end

@implementation JHC2CProductDetailChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.detaiLbl];
    [self.backView addSubview:self.timeLbl];
    [self.backView addSubview:self.likeBtn];
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionWithSender:)];
//    [self.contentView addGestureRecognizer:tap];
//
//    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressActionWithSender:)];
//    longPress.minimumPressDuration = 1.5;
//    [self.contentView addGestureRecognizer:longPress];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(@0).inset(12);
        make.height.mas_equalTo(0.5);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
    }];
    [self.detaiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(4);
        make.left.equalTo(self.nameLbl);
        make.right.equalTo(@0).offset(-12);
    }];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detaiLbl.mas_bottom).offset(13);
        make.left.equalTo(self.nameLbl);
        make.bottom.equalTo(@0).offset(-16);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLbl);
        make.right.equalTo(@0).offset(-15);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
}

- (void)tapActionWithSender:(UIGestureRecognizer*)sender{
    if (self.tapCellBlcok) {
        self.tapCellBlcok();
    }
}

- (void)longPressActionWithSender:(UIGestureRecognizer*)sender{
    if (self.longPressCellBlcok) {
        self.longPressCellBlcok();
    }
}

- (void)likeBtnActionWithSender:(UIButton*)sender{
    if (self.likeBtnTapBlcok) {
        self.likeBtnTapBlcok();
    }
}

- (void)setCommentModel:(JHCommentModel *)commentModel{
    if (!commentModel) {
        return;
    }
    _commentModel = commentModel;
    [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:_commentModel.publisher.avatar] placeholder:kDefaultAvatarImage];
    self.nameLbl.text = [_commentModel.publisher.user_name isNotBlank] ? _commentModel.publisher.user_name :@"暂无昵称";
    ///判断是否是作者显示作者标签
    self.detaiLbl.text = _commentModel.content ? : @"暂无";
    
    self.timeLbl.text = _commentModel.time;
    self.likeBtn.selected = _commentModel.is_like;
    NSString * likeNum = _commentModel.like_num > 0 ? @(_commentModel.like_num).stringValue : @"";
    [self.likeBtn setTitle:likeNum forState:UIControlStateNormal];

}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}
- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(13);
        label.text = @"产品经理23049";
        label.textColor = HEXCOLOR(0x333333);
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UILabel *)detaiLbl{
    if (!_detaiLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.text = @"刚工作的几年比谁更踏实，再过几年比谁更激情";
        label.textColor = HEXCOLOR(0x333333);
        label.numberOfLines = 4;
        _detaiLbl = label;
    }
    return _detaiLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(11);
        label.text = @"2021-09-08";
        label.textColor = HEXCOLOR(0x999999);
        _timeLbl = label;
    }
    return _timeLbl;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.backgroundColor = UIColor.getRandomColor;
        view.layer.cornerRadius = 13;
        view.layer.masksToBounds = YES;
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF0F0F0);
        _lineView = view;
    }
    return _lineView;
}
- (UIButton *)likeBtn{
    if (!_likeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_zan_unsel"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_zan_sel"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_zan_sel"] forState:UIControlStateDisabled];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(11);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        [btn addTarget:self action:@selector(likeBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        btn.userInteractionEnabled = NO;
        _likeBtn = btn;
    }
    return _likeBtn;
}
@end

