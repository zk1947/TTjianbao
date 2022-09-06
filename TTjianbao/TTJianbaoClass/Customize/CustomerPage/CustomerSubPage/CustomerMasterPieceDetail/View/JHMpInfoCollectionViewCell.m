//
//  JHMpInfoCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMpInfoCollectionViewCell.h"
#import <UIKit/UIKit.h>
 
typedef enum {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
 
@interface myUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;
@end

@implementation myUILabel
@synthesize verticalAlignment = verticalAlignment_;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}
 
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}
 
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}
 
- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end








@interface JHMpInfoCollectionViewCell ()
@property (nonatomic, strong) myUILabel *titleLabel;
@property (nonatomic, strong) myUILabel *subTitleLabel;
@end

@implementation JHMpInfoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (CGFloat)bottomViewHeight {
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    return bottomHeight;
}

- (void)setupViews {
    _titleLabel               = [[myUILabel alloc] init];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.font          = [UIFont fontWithName:kFontMedium size:18.f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(11.f, [self bottomViewHeight] + 15.f, 15.f, 15.f));
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.height.mas_equalTo(25.f);
    }];
    
    _subTitleLabel                     = [[myUILabel alloc] init];
    _subTitleLabel.textColor           = HEXCOLOR(0x333333);
    _subTitleLabel.textAlignment       = NSTextAlignmentLeft;
    _subTitleLabel.font                = [UIFont fontWithName:kFontNormal size:15.f];
    _subTitleLabel.numberOfLines       = 0;
    [_subTitleLabel setVerticalAlignment:VerticalAlignmentTop];
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.f);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
//        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
}

- (void)setViewModel:(NSDictionary *)viewModel {
    self.titleLabel.text = NONNULL_STR(viewModel[@"title"]);
    if (!isEmpty(viewModel[@"desc"])) {
        NSString *str = viewModel[@"desc"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//        [attributedString setColor:COLOR_HEXA_DYNAMIC(0x000000, 1.0f, 0xffffff, 0.55f)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = 0;
        [paragraphStyle setLineSpacing:2.f];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [str length])];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:kFontNormal size:15.f]
                                 range:NSMakeRange(0, [str length])];
        [self.subTitleLabel setAttributedText:attributedString];
    }
}


@end
