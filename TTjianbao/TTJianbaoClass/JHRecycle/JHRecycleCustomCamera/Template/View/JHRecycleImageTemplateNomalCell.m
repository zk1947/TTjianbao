//
//  JHRecycleImageTemplateNomalCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageTemplateNomalCell.h"
@interface JHRecycleImageTemplateNomalCell()

@end

@implementation JHRecycleImageTemplateNomalCell


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
    [[RACObserve(self.viewModel.templateModel, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) {
            self.bgimageView.image = nil;
            self.deleteButton.hidden = true;
        }else {
            self.deleteButton.hidden = false;
            if (self.bgimageView.image != nil) return;
            self.bgimageView.image = x;
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

#pragma mark - setupUI
- (void)setupUI {
   
    self.bgimageView.backgroundColor = HEXCOLOR(0xf1f1f1);
}
- (void)layoutViews {
   
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleImageTemplateCellViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

@end
