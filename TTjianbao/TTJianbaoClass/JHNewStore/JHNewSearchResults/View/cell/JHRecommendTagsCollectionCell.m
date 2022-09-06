//
//  JHRecommendTagsCollectionCell.m
//  TTjianbao
//
//  Created by hao on 2021/10/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecommendTagsCollectionCell.h"
#import "JHNewSearchResultRecommendTagsModel.h"
#import "JHAnimatedImageView.h"

@interface JHRecommendTagsCollectionCell ()
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *tagNameLabel;

@end

@implementation JHRecommendTagsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark  - 设置UI
- (void)setupUI{
    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.tagNameLabel];

    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.width);
    }];
    
    
    [self.tagNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
   
    
}
#pragma mark - LoadData
//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHNewSearchResultRecommendTagsListModel *tagsModel = dataModel;
    self.tagNameLabel.text = tagsModel.tagWord;
    [self.tagImageView jh_setImageWithUrl:tagsModel.tagIocnUrl placeHolder:@"newStore_hoder_image"];

}

#pragma mark - Action

#pragma mark - Delegate

#pragma mark - Lazy
- (UIImageView *)tagImageView{
    if (!_tagImageView) {
        _tagImageView = [UIImageView new];
        [_tagImageView jh_cornerRadius:4.0];
        _tagImageView.image = JHImageNamed(@"newStore_hoder_image");
        _tagImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _tagImageView;
}
- (UILabel *)tagNameLabel{
    if (!_tagNameLabel) {
        _tagNameLabel = [UILabel new];
        _tagNameLabel.textColor = HEXCOLOR(0x999999);
        _tagNameLabel.font = JHFont(11);
        _tagNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagNameLabel;
}

@end
