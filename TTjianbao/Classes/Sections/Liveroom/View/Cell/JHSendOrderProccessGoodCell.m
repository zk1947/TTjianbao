//
//  JHSendOrderProccessGoodCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSendOrderProccessGoodCell.h"
#import "JHProccessGoodSubView.h"


@interface JHSendOrderProccessGoodCell()

@property (nonatomic, strong) JHProccessGoodSubView* goodSubView;
@property (nonatomic, strong) UIButton* customButton;
@end

@implementation JHSendOrderProccessGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawSubview];
    }
    return self;
}

- (void)drawSubview
{
    _goodSubView = [[JHProccessGoodSubView alloc] init];
    [self.contentView addSubview:_goodSubView];
    [self.goodSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenW-52*2);
        make.height.mas_equalTo(kJHSendOrderProccessGoodCellHeight);
    }];
    
    _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customButton setTitle:@"定制" forState:UIControlStateNormal];
    _customButton.userInteractionEnabled = NO;
    _customButton.layer.cornerRadius = 14;
    _customButton.backgroundColor = HEXCOLOR(0xFEE100);
    [_customButton setTitleColor:HEXCOLOR(0x333333) forState: UIControlStateNormal];
    _customButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_customButton addTarget:self action:@selector(pressCustomButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_customButton];
    [_customButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-9);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(28);
    }];
}

- (void)setData:(OrderMode*)model
{
    [_goodSubView setData:model];
}

#pragma event
- (void)pressCustomButton:(UIButton*)button
{
    
}

@end
