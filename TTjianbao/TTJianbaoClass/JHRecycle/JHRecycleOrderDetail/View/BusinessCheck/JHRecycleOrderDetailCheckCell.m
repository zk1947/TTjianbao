//
//  JHRecycleOrderDetailCheckCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailCheckCell.h"
#import "JHRecycleOrderToolbarView.h"
@interface JHRecycleOrderDetailCheckCell()
/// 描述
@property (nonatomic, strong) YYLabel *describeLabel;
/// toolbar
@property (nonatomic, strong) JHRecycleOrderToolbarView *toolbar;

@end
@implementation JHRecycleOrderDetailCheckCell

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
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
#pragma mark - Private Functions
- (void)addSeeMoreButton {
    
    NSDictionary *linkDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x408ffe),
                               NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    NSDictionary *textDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                               NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                                       initWithString:@"...  "
                                       attributes:textDict];
    
    NSMutableAttributedString *linkAtt = [[NSMutableAttributedString alloc]
                                   initWithString:@" 查看商家说明"
                                   attributes: linkDict] ;

    YYAnimatedImageView *imageView1= [[YYAnimatedImageView alloc]
                                      initWithImage:[UIImage imageNamed:@"recycle_orderDetail_business_play_icon"]];
    imageView1.frame = CGRectMake(0, -2, 12, 12);

    YYAnimatedImageView *imageView2= [[YYAnimatedImageView alloc]
                                      initWithImage:[UIImage imageNamed:@"recycle_orderDetail_business_detail_icon"]];
    imageView2.frame = CGRectMake(0, -2, 12, 12);
    
    NSMutableAttributedString *attachText1= [NSMutableAttributedString attachmentStringWithContent:imageView1 contentMode:UIViewContentModeCenter attachmentSize:imageView1.frame.size alignToFont:linkAtt.font alignment:YYTextVerticalAlignmentCenter];

    NSMutableAttributedString *attachText2= [NSMutableAttributedString attachmentStringWithContent:imageView2 contentMode:UIViewContentModeCenter attachmentSize:imageView2.frame.size alignToFont:linkAtt.font alignment:YYTextVerticalAlignmentCenter];
    
    
    [linkAtt insertAttributedString:attachText1 atIndex:0];
    [linkAtt appendAttributedString:attachText2];
    [text appendAttributedString:linkAtt];
    self.describeLabel.truncationToken = text;
}

#pragma mark - Bind
- (void)bindData {
    RAC(self.describeLabel, attributedText) = [RACObserve(self.viewModel, attDescribeText)
                                               takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.describeLabel];
    [self.content addSubview:self.toolbar];
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerBottom];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.top.equalTo(self.content).offset(RecycleOrderNomalTopSpace);
        make.bottom.equalTo(self.toolbar.mas_top).offset(-RecycleOrderCheckToolbarTopSpace);
    }];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.height.mas_equalTo(RecycleOrderArbitrationToolbarHeight);
        make.bottom.equalTo(self.content).offset(-RecycleOrderNomalBottomSpace);
    }];
}

#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailCheckViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
    self.toolbar.viewModel = viewModel.toolbarViewModel;
}

- (YYLabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _describeLabel.textColor = HEXCOLOR(0x666666);
        _describeLabel.textAlignment = NSTextAlignmentJustified;
        _describeLabel.numberOfLines = RecycleOrderDescribeNumberOfLines;
//        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _describeLabel.font = [UIFont fontWithName:kFontNormal size:RecycleOrderDescribeFontSize];
        [self addSeeMoreButton];
    }
    return _describeLabel;
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
