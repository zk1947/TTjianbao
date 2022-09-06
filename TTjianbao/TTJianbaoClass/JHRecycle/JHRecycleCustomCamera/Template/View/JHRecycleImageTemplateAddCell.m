//
//  JHRecycleImageTemplateAddCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageTemplateAddCell.h"
@interface JHRecycleImageTemplateAddCell()
@property (nonatomic, strong) UIImageView *addImageView;

@end
@implementation JHRecycleImageTemplateAddCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
- (void)didClickDeleteWithAction : (UIButton *)sender {
    [self.viewModel.deleteEvent sendNext:nil];
}
#pragma mark - Bind
- (void)bindData {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel.templateModel, titleText) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [[RACObserve(self.viewModel.templateModel, thumbnailImage)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) {
            self.addImageView.hidden = false;
            self.bgimageView.image = nil;
            self.deleteButton.hidden = true;
        }else {
            self.deleteButton.hidden = false;
            if (self.bgimageView.image != nil) return;
            self.addImageView.hidden = true;
            self.bgimageView.image = x;
            [self imageScaleAnimation];

        }
    }];
    
    [[RACObserve(self.viewModel, isSelected)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL selected = [x boolValue];
        if (selected == true) {
            [self setupSelectedImageUI];
        }else {
            [self setupNomalImageUI];
        }
    }];
}

- (void)imageScaleAnimation{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgimageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        self.bgimageView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    
    [self addSubview:self.addImageView];
}
- (void)layoutViews {
   
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgimageView);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleImageTemplateCellViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _addImageView.image = [UIImage imageNamed:@"recycle_template_add_icon"];
    }
    return _addImageView;
}
@end
