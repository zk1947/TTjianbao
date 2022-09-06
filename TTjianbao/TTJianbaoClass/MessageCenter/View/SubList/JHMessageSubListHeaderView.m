//
//  JHMessageSubListHeaderView.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageSubListHeaderView.h"

@interface JHMessageSubListHeaderView ()

@property (nonatomic, strong) UIView* headerView;

@end

@implementation JHMessageSubListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        //时间背景
        [_headerView addSubview:self.headerSubview];
        [_headerSubview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView).offset(0);
            make.bottom.equalTo(_headerView).offset(-10);
            make.height.offset(kHeaderContentHeight);
        }];
        //时间
        [_headerSubview addSubview:self.headerSubviewTitle];
        [_headerSubviewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerSubview).offset(12);
            make.right.equalTo(_headerSubview).offset(-12);
            make.centerY.equalTo(_headerSubview).offset(0);
        }];
    }
    
    return self;
}

- (UIView *)headerView
{
    if(!_headerView)
    {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIView *)headerSubview
{
    if(!_headerSubview)
    {
        _headerSubview = [[UIView alloc] init];
        _headerSubview.backgroundColor = HEXCOLOR(0xE1E1E1);
        _headerSubview.layer.cornerRadius = 7.5;
    }
    return _headerSubview;
}

- (UILabel *)headerSubviewTitle
{
    if(!_headerSubviewTitle)
    {
        _headerSubviewTitle = [[UILabel alloc] init];
        _headerSubviewTitle.font = JHFont(11);
        _headerSubviewTitle.textColor = HEXCOLOR(0xFFFFFF);
        _headerSubviewTitle.numberOfLines = 1;
        _headerSubviewTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _headerSubviewTitle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _headerSubviewTitle;
}

- (void)updateData:(NSString*)text section:(NSInteger)section
{
    float offsetY = section==0 ? 10 : 0;
    //间距
    [_headerSubview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(offsetY);
    }];
    //显示文字
    _headerSubviewTitle.text = text;
}

@end
