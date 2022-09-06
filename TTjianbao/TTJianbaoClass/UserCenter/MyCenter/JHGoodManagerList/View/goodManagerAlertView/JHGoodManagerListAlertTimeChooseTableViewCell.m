//
//  JHGoodManagerListAlertTimeChooseTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListAlertTimeChooseTableViewCell.h"
#import "JHGoodManagerSingleton.h"

@interface JHGoodManagerListAlertTimeChooseTableViewCell ()
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *selButton;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

@implementation JHGoodManagerListAlertTimeChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
        
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x222222);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14.f);
    }];
    
    _selButton                            = [UIButton buttonWithType:UIButtonTypeCustom];
    _selButton.titleLabel.font            = [UIFont fontWithName:kFontNormal size:13.f];
    [_selButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_selButton addTarget:self action:@selector(selButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _selButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_selButton];
    [_selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(97.f);
        make.right.equalTo(self.contentView.mas_right).offset(-27.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.mas_equalTo(48.f);
    }];
    
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.image = [UIImage imageNamed:@"jhGoodManagerList_right"];
    [self.contentView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.centerY.equalTo(self.selButton.mas_centerY);
        make.width.mas_equalTo(5.f);
        make.height.mas_equalTo(11.f);
    }];
    
    /// 横划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selButton.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.selButton.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)selButtonClickAction:(UIButton *)sender {
    [self chooseGoodType];
}

- (void)setViewModel:(NSDictionary *)viewModel {
    
    NSMutableAttributedString *star = [[NSMutableAttributedString alloc] initWithString:viewModel[@"name"] attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontMedium size:15.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x222222)
    }];
    NSMutableAttributedString *end = [[NSMutableAttributedString alloc] initWithString:@" *" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontMedium size:15.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    [commentString appendAttributedString:star];
    [commentString appendAttributedString:end];
    
    
    self.nameLabel.attributedText = commentString;
    [self.selButton setTitle:viewModel[@"placeholder"] forState:UIControlStateNormal];
}


- (void)chooseGoodType {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选商品发布类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"立即上架" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        if (self.putOnNowBlock) {
            self.putOnNowBlock();
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"指定时间上架" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [JHGoodManagerSingleton shared].putOnType = @"3";
        
        if (self.putOnwithTimeBlock) {
            self.putOnwithTimeBlock();
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [JHRootController presentViewController:alert animated:YES completion:nil];
}


@end
