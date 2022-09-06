//
//  JHStoreDetailEducationCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailEducationCell.h"
#import "JHAppBusinessModelManager.h"

@interface JHStoreDetailEducationCell()
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation JHStoreDetailEducationCell

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
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
   [JHAppBusinessModelManager getImage:@"newStore_education_bg"
                                bModel:_viewModel.currentBusinessModel
                                 block:^(UIImage * _Nullable image) {
       if (image) {
           [_bgImageView setImage:image];
       }
   }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    [self addSubview:self.bgImageView];
}
- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).offset(0);
    }];
}

- (void)setViewModel:(JHStoreDetailEducationViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

#pragma mark - Lazy
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newStore_education_bg"]];
    }
    return _bgImageView;
}
@end
