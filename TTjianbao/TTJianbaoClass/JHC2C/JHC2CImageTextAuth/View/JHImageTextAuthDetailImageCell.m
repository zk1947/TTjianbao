//
//  JHImageTextAuthDetailImageCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextAuthDetailImageCell.h"

@interface JHImageTextAuthDetailImageCell ()

@property (nonatomic, strong) UIImageView *imagev;

@end

@implementation JHImageTextAuthDetailImageCell

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
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
    }];
}

- (void)setModel:(JHImageTextWaitAuthDetailImageModel *)model{
    _model = model;
    [_imagev jhSetImageWithURL:[NSURL URLWithString:_model.origin] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
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
