//
//  JHChatBlackUserTableViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatBlackUserTableViewCell.h"

@interface JHChatBlackUserTableViewCell ()

@property (nonatomic, strong) UIImageView *headImgv;

@property (nonatomic, strong) UILabel *nameLable;

//@property (nonatomic, strong) UIView *tagBackView;
//
//@property (nonatomic, strong) UIImageView *tagImgv;
//
//@property (nonatomic, strong) UILabel *tagLable;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *line;

@end

@implementation JHChatBlackUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    _headImgv = [[UIImageView alloc]init];
//    _headImgv.image = JHImageNamed(@"common_app_icon");
    [_headImgv jh_cornerRadius:25];
    _headImgv.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImgv];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_headImgv addGestureRecognizer:tap];
    
    _nameLable = [UILabel new];
    _nameLable.text = @"";
    _nameLable.font = JHFont(15);
    _nameLable.textColor = kColor333;
    [self.contentView addSubview:_nameLable];

//    _tagBackView = [UIView new];
//    _tagBackView.backgroundColor = HEXCOLOR(0xFFEFBF);
//    [_tagBackView jh_cornerRadius:6.5];
//    [self.contentView addSubview:_tagBackView];
    
//    _tagImgv = [[UIImageView alloc]init];
//    _tagImgv.image = JHImageNamed(@"common_app_icon");
//    [_tagImgv jh_cornerRadius:6.5];
//    [self.contentView addSubview:_tagImgv];
    
//    _tagLable = [UILabel new];
//    _tagLable.text = @"鉴定师";
//    _tagLable.font = JHFont(10);
//    _tagLable.textColor = HEXCOLOR(0xF88605);
//    [_tagBackView addSubview:_tagLable];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"移除" forState:UIControlStateNormal];
    [_button setTitleColor:kColor666 forState:UIControlStateNormal];
    _button.titleLabel.font = JHFont(13);
    _button.layer.cornerRadius = 15;
    _button.layer.masksToBounds = YES;
    _button.layer.borderWidth = 1;
    _button.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self.contentView addSubview:_line];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.height.mas_equalTo(50);
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgv.mas_right).offset(8);
        make.right.mas_equalTo(-81);
        make.top.mas_equalTo(21);
        make.height.mas_equalTo(21);
    }];

//    [_tagBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_headImgv.mas_right).offset(8);
//        make.top.mas_equalTo(_nameLable.mas_bottom).offset(5);
//        make.height.mas_equalTo(13);
//    }];
//
//    [_tagLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_tagBackView).insets(UIEdgeInsetsMake(1, 14, 1, 5));
//    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(30);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(JHChatBlackUserModel *)model{
    _model = model;
    [_headImgv jhSetImageWithURL:[NSURL URLWithString:_model.img] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    _nameLable.text = _model.name;
}

- (void)tapAction{
    if ([self.delegate respondsToSelector:@selector(gotoPersonPage:)]) {
        [self.delegate gotoPersonPage:_model];
    }
}

- (void)buttonAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:_model];
    }
}

@end
