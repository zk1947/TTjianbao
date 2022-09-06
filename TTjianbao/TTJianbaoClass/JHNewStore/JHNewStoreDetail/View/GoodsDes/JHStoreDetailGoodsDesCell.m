//
//  JHStoreDetailGoodsDesCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailGoodsDesCell.h"
CGFloat desMaxHeight = 100.f;
@interface JHStoreDetailGoodsDesCell()
@property (nonatomic, strong) YYLabel *titleLabel;

@property(nonatomic, copy) NSString * fullStr;

@property(nonatomic) BOOL  openFold;
@end
@implementation JHStoreDetailGoodsDesCell

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
        [self layoutViews];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - setupUI
- (void)setupUI{
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
}
- (void)layoutViews{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(LeftSpace);
        make.right.equalTo(@0).offset(-LeftSpace);
        make.top.bottom.equalTo(@0);
    }];
}


- (void)setDesLblAttStringFold:(BOOL)fold{
    NSString* str = self.fullStr;
    CGFloat wide = kScreenWidth - 24.f;
    CGFloat height = [str boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName : JHFont(13)}
                      context:nil].size.height;
    if (height <= desMaxHeight) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                attributes:@{NSFontAttributeName : JHFont(13),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
        self.titleLabel.attributedText = att;

    }else{
        if (fold) {
            str = [self getRightLengthOfString:str];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                    attributes:@{NSFontAttributeName : JHFont(13),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
            @weakify(self);
            [att setTextHighlightRange:NSMakeRange(str.length - 2, 2) color:HEXCOLOR(0x2F66A0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self desFoldStatusChange];
            }];
            self.titleLabel.attributedText = att;

        }else{
//            NSString* str = self.fullStr;
//            NSString* str = [self.fullStr stringByAppendingString:@"收起"];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                    attributes:@{NSFontAttributeName : JHFont(13),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
//            [att setTextHighlightRange:NSMakeRange(str.length - 2, 2) color:HEXCOLOR(0x007AFF) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                [self foldBtnActionWithSender:self.foldBtn];
//            }];
            self.titleLabel.attributedText = att;
        }
    }

}
- (void)desFoldStatusChange{
    self.viewModel.openFold = YES;
    [self.viewModel.reloadCellSubject sendNext:RACTuplePack(@(self.viewModel.sectionIndex), @(self.viewModel.rowIndex))];
}

- (NSString*)getRightLengthOfString:(NSString*)str{
    NSString *appStr = @"... 展开";
    NSUInteger index = MIN(310, str.length);
    NSString* newStr;
    CGFloat wide = kScreenWidth - 24.f;
    CGFloat height = desMaxHeight + 10;
    while (height > desMaxHeight) {
        index -= 2;
        newStr = [str substringToIndex:index];
        newStr = [newStr stringByAppendingString:appStr];
        height = [newStr boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : JHFont(13)}
                          context:nil].size.height;
    }
    return newStr;
}


#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailGoodsDesViewModel *)viewModel {
    _viewModel = viewModel;
    NSString *title = [viewModel.titleText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.fullStr = title;
    [self setDesLblAttStringFold:!viewModel.openFold];
}
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = kScreenWidth - 24.f;
        
    }
    return _titleLabel;
}
@end
