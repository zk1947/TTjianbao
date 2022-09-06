//
//  JHStoreDetailSecurityCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSecurityCell.h"
#import "UIView+JHGradient.h"

@interface JHStoreDetailSecurityCell()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation JHStoreDetailSecurityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
- (void)setViewModel:(JHStoreDetailSecurityViewModel *)viewModel{
    _viewModel = viewModel;
    NSString *imageName = viewModel.directDelivery ? @"newStore_security_bg_zhifa" : @"newStore_security_bg";
    self.bgImageView.image = [UIImage imageNamed:imageName];
//    [self bindData];

}
#pragma mark - Public Functions

#pragma mark - Private Functions

#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    
    [JHAppBusinessModelManager getImage:@"newStore_security_bg"
                                 bModel:_viewModel.currentBusinessModel
                                  block:^(UIImage * _Nullable image) {
        if (image) {
            [_bgImageView setImage:image];
        }
    }];
    
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.bgImageView];
}
- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).offset(0);
    }];
}

#pragma mark - Lazy
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newStore_security_bg"]];
    }
    return _bgImageView;
}
@end
