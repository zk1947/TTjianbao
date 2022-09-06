//
//  JHRecycleOrderDetailStatusDescribeCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailStatusDescribeCell.h"


@interface JHRecycleOrderDetailStatusDescribeCell()
/// 描述
@property (nonatomic, strong) YYLabel *describeLabel;

@end
@implementation JHRecycleOrderDetailStatusDescribeCell

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
    @weakify(self)
    [[RACObserve(self.viewModel, describeText)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return ;
        self.describeLabel.text = x;
        self.describeLabel.textColor = HEXCOLOR(0x666666);
    }];
    [[RACObserve(self.viewModel, attDescribeText)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return ;
        self.describeLabel.attributedText = x;
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.describeLabel];
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerBottom];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.top.equalTo(self.content).offset(RecycleOrderNomalTopSpace);
        make.bottom.equalTo(self.content).offset(-RecycleOrderNomalBottomSpace);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailStatusDescribeViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (YYLabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _describeLabel.textColor = HEXCOLOR(0x666666);
        _describeLabel.textAlignment = NSTextAlignmentJustified;
        _describeLabel.numberOfLines = 0;
//        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _describeLabel.font = [UIFont fontWithName:kFontNormal size:RecycleOrderDescribeFontSize];
    }
    return _describeLabel;
}
@end
