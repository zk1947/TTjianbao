//
//  JHMarketSloganTableViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketSloganTableViewCell.h"

@interface JHMarketSloganTableViewCell ()

@property (nonatomic, strong) UIImageView *sloganImageView;

@end

@implementation JHMarketSloganTableViewCell

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
    
    self.backgroundColor = kColorFFF;
    self.contentView.backgroundColor = kColorFFF;
    
    _sloganImageView = [[UIImageView alloc]init];
    _sloganImageView.contentMode = UIViewContentModeScaleAspectFill;
    _sloganImageView.image = JHImageNamed(@"c2c_market_explain_icon");
    [self.contentView addSubview:_sloganImageView];
    [_sloganImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 0, 12));
        //9.8
        make.height.mas_equalTo((kScreenWidth-24)/9.8);
    }];
    
}

@end
