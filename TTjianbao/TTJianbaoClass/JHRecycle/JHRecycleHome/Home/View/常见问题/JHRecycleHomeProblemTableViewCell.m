//
//  JHRecycleHomeProblemTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeProblemTableViewCell.h"
#import "JHRecycleHomeModel.h"

@interface JHRecycleHomeProblemTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@end

@implementation JHRecycleHomeProblemTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nextImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(5, 6));
    }];
    
}

- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHHomeRecycleHelpArticleListModel *problemListModel = dataModel;

    self.titleLabel.text = problemListModel.title;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    }
    return _titleLabel;
}
- (UIImageView *)nextImageView{
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] init];
        _nextImageView.image = JHImageNamed(@"recycle_homeMore_right_icon");
    }
    return _nextImageView;
}

@end
