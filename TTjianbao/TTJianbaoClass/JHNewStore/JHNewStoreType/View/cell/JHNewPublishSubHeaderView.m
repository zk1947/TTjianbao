//
//  JHNewPublishSubHeaderView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewPublishSubHeaderView.h"


@interface JHNewPublishSubHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIButton * allBtn;
@end

@implementation JHNewPublishSubHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.font = JHFont(13);
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(@0);
        }];
        [self addSubview:self.allBtn];
        [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.right.equalTo(@0);
            make.width.equalTo(@90);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)allBtnAction{
    if (self.showAllActionBlock) {
        self.showAllActionBlock(self.section);
    }
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn addTarget:self action:@selector(allBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *arrowimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_type_all_arrow"]];
        [_allBtn addSubview:arrowimageView];
        [arrowimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_allBtn).offset(-9);
            make.centerY.equalTo(@0);
        }];
        UILabel *allLbl = [UILabel new];
        allLbl.font = JHFont(12);
        allLbl.textColor = HEXCOLOR(0x999999);
        allLbl.text = @"查看全部";
        [_allBtn addSubview:allLbl];
        [allLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowimageView.mas_left);
            make.centerY.equalTo(@0);
        }];
    }
    return _allBtn;
}
@end
