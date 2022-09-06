//
//  JHCustomerIntroducationCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerIntroducationCell.h"
#import "JHLiveRoomModel.h"
#import <YYKit/YYKit.h>
#import "TTjianbaoMarcoUI.h"

@interface JHCustomerIntroducationCell ()

///定制师介绍描述
@property (nonatomic, strong) YYLabel *descLabel;
///收起按钮
//@property (nonatomic, strong) UIButton *foldButton;
@property (nonatomic, assign) BOOL isShowAll;
//@property (nonatomic, strong) NSMutableAttributedString *descAttrText;

@end

@implementation JHCustomerIntroducationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isShowAll = NO;
        _isRecycle = NO;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _descLabel = [[YYLabel alloc] init];
    _descLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    _descLabel.textColor = kColor333;
    [self.contentView addSubview:_descLabel];
    _descLabel.numberOfLines = 3;
//    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [self addSeeMoreButton];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"收起" forState:UIControlStateNormal];
//    [btn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:12.f];
//    [btn addTarget:self action:@selector(foldIntroduction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:btn];
//    btn.hidden = YES;
//    _foldButton = btn;
    
//    [_foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-15);
//        make.bottom.equalTo(self.contentView).offset(-15);
//        make.height.mas_equalTo(0);
//    }];

    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.f);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(54.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
}

#pragma mark - 全文按钮

//- (void)addSeeMoreButton {
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"... 展开"];
//
//    YYTextHighlight *hlText = [YYTextHighlight new];
//    [hlText setColor:kColor666];
//    @weakify(self);
//    hlText.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        @strongify(self);
//        [self clickMoreEvent];
//    };
//
//    [text setColor:kColor666 range:[text.string rangeOfString:@"..."]];
//    [text setColor:HEXCOLOR(0x408FFE) range:[text.string rangeOfString:@"展开"]];
//    [text setTextHighlight:hlText range:[text.string rangeOfString:@"展开"]];
//    text.font = [UIFont fontWithName:kFontMedium size:12];
//
//    YYLabel *seeMore = [YYLabel new];
//    seeMore.attributedText = text;
//    [seeMore sizeToFit];
//
//    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
//    _descLabel.truncationToken = truncationToken;
//}

#pragma mark -
#pragma mark - 事件处理

////点击展开
//- (void)clickMoreEvent {
//    _descLabel.numberOfLines = 0;
//    _foldButton.hidden = NO;
//    _isShowAll = YES;
//    _roomInfo.showAllInfo = YES;
//    [_foldButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(15);
//    }];
//    if (self.updateBlock) {
//        self.updateBlock(_roomInfo.roomDesAllHeight+30);
//    }
//}
//
//- (void)foldIntroduction {
//    _descLabel.numberOfLines = 3;
//    _foldButton.hidden = YES;
//    _isShowAll = NO;
//    _roomInfo.showAllInfo = NO;
//    [_foldButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0);
//    }];
//
//    if (self.updateBlock) {
//        self.updateBlock(_roomInfo.roomDesHeight+15);
//    }
//}

- (CGSize)calculationTextWidthWith:(NSString*)string font:(UIFont *)font {
    CGSize width = [string boundingRectWithSize:CGSizeMake(ScreenW -30.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return width;
}

- (void)setRoomInfo:(JHLiveRoomModel *)roomInfo {
    if (!roomInfo) {
        return;
    }
    _roomInfo = roomInfo;
    if (_roomInfo.showButton) {
        _descLabel.attributedText = _roomInfo.customizeDescAttriText;
    } else {
        NSString *instroStr = _isRecycle?@"暂无回收师介绍~":@"暂无定制师介绍~";
        NSMutableAttributedString *attrStr = [_roomInfo.customizeIntro isNotBlank] ? _roomInfo.customizeDescAttriText : [[NSMutableAttributedString alloc] initWithString:instroStr];
        _descLabel.attributedText = attrStr;
    }
        
    CGSize size = [self calculationTextWidthWith:[_descLabel.attributedText string] font:[UIFont fontWithName:kFontNormal size:12.]];///
    
    if (size.height > 54.f) {
        [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54.f);
        }];
    } else {
        [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
    }
    
//    _foldButton.hidden = !_roomInfo.showAllInfo;
//    CGFloat height = _roomInfo.showAllInfo ? 15 : 0;
//    [_foldButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
}


@end
