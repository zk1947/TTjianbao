//
//  JHRecycleOrderDetailArbitrationCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailArbitrationCell.h"

#import "JHRecycleOrderToolbarView.h"

@interface JHRecycleOrderDetailArbitrationCell()
/// 描述
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
/// toolbar
@property (nonatomic, strong) JHRecycleOrderToolbarView *toolbar;
@end
@implementation JHRecycleOrderDetailArbitrationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions

#pragma mark - Private Functions

#pragma mark - Bind
- (void)bindData {
    RAC(self.describeLabel, text) = [RACObserve(self.viewModel, describeText)
                                               takeUntil:self.rac_prepareForReuseSignal];

    @weakify(self)
    [[RACObserve(self.viewModel, attDescribeText)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if (x != nil) {
            self.priceLabel.attributedText = x;
            self.priceLabel.hidden = false;
            [self.describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.priceLabel.mas_bottom).offset(RecycleOrderNomalTopSpace);
            }];
        }else {
            self.priceLabel.hidden = true;
            [self.describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.content).offset(RecycleOrderNomalTopSpace);
            }];
        }
    }];

}
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.priceLabel];
    [self.content addSubview:self.describeLabel];
    [self.content addSubview:self.toolbar];
    
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerBottom];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content).offset(RecycleOrderNomalTopSpace);
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(RecycleOrderNomalTopSpace);
//        make.bottom.equalTo(self.toolbar.mas_top).offset(-RecycleOrderNomalBottomSpace);
    }];
    
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.height.mas_equalTo(RecycleOrderArbitrationToolbarHeight);
        make.bottom.equalTo(self.content).offset(-RecycleOrderNomalBottomSpace);
    }];
}

#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailArbitrationViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
    self.toolbar.viewModel = viewModel.toolbarViewModel;
}
- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _describeLabel.textColor = HEXCOLOR(0x666666);
        _describeLabel.textAlignment = NSTextAlignmentJustified;
        _describeLabel.numberOfLines = 0;
        _describeLabel.font = [UIFont fontWithName:kFontNormal size:RecycleOrderDescribeFontSize];
    }
    return _describeLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0x666666);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}
- (JHRecycleOrderToolbarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[JHRecycleOrderToolbarView alloc]initWithFrame:CGRectZero];
        _toolbar.isHighlight = false;
        _toolbar.leftSpace = LeftSpace * 2;
    }
    return _toolbar;
}
@end
