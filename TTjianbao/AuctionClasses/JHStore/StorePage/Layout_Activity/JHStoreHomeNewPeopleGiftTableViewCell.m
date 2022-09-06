//
//  JHStoreHomeNewPeopleGiftTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/1/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeNewPeopleGiftTableViewCell.h"
#import "JHStoreHomeCardModel.h"
#import "UIImageView+JHWebImage.h"
#import "UIView+CornerRadius.h"

@interface JHStoreHomeNewPeopleGiftTableViewCell ()
@property (nonatomic,strong) YYAnimatedImageView *activityImageView;
@end

@implementation JHStoreHomeNewPeopleGiftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_activityImageView) {
        _activityImageView = [[YYAnimatedImageView alloc] initWithImage:kDefaultCoverImage];
        _activityImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_activityImageView];
        [_activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 5.f, 10));
            make.height.mas_equalTo((ScreenW - 20)*4.f/9.f);
        }];
        [self layoutIfNeeded];
        _activityImageView.clipsToBounds = YES;
        [_activityImageView yd_setCornerRadius:5.f corners:UIRectCornerAllCorners];
    }
}

- (void)setAnewPeopleModel:(JHStoreHomeNewPeopleModel *)anewPeopleModel {
    if (!anewPeopleModel) return;
    _anewPeopleModel = anewPeopleModel;
    [_activityImageView setImageWithURL:[NSURL URLWithString:anewPeopleModel.img] placeholder:kDefaultCoverImage];
}

@end
