//
//  JHRecycleImageInfoTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageInfoTableViewCell.h"
#import "JHRecycleDetailModel.h"
#import "UIImageView+JHWebImage.h"

@interface JHRecycleImageInfoTableViewCell ()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation JHRecycleImageInfoTableViewCell

- (void)setupViews{
    [self.backView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.backView).offset(0);
    }];
    @weakify(self)
    [self.imgView jh_addTapGesture:^{
        @strongify(self)
        if (self.selectImageBlack) {
            self.selectImageBlack(self);
        }
    }];
}
- (void)bindViewModel:(id)dataModel{
    JHRecycleDetailImageUrlModel *imgUrlModel = dataModel;
    @weakify(self)
    [self.imgView jhSetImageWithURL:[NSURL URLWithString:imgUrlModel.medium] placeholder:JHImageNamed(@"newStore_default_placehold") completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        @strongify(self)
        if (image) {
            self.imgView.contentMode = UIViewContentModeScaleToFill;
        }
    }];
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = HEXCOLOR(0xF5F5F5);
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
@end
