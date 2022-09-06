//
//  JHStoreHomeActivityTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeActivityTableCell.h"
#import "JHStoreHomeCardModel.h"
#import "UIImageView+JHWebImage.h"
#import "UIView+CornerRadius.h"

@interface JHStoreHomeActivityTableCell ()
@property (nonatomic,strong) YYAnimatedImageView *activityImageView;
@end

@implementation JHStoreHomeActivityTableCell

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
        _activityImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_activityImageView];
        [_activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
        }];
        [self layoutIfNeeded];
        _activityImageView.clipsToBounds = YES;
        [_activityImageView yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
    }
}

- (void)setShowcaseModel:(JHStoreHomeShowcaseModel *)showcaseModel {
    if (!showcaseModel) return;
    _showcaseModel = showcaseModel;
    [_activityImageView setImageWithURL:[NSURL URLWithString:_showcaseModel.bg_img] placeholder:kDefaultCoverImage];
}

@end
