//
//  JHCustomerDescCommentTextTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescCommentTextTableViewCell.h"
#import "JHCustomerDescInProcessModel.h"
#import "PPStickerDataManager.h"

@interface JHCustomerDescCommentTextTableViewCell ()
@property (nonatomic, strong) UILabel *userNameLabel;
//@property (nonatomic, strong) UILabel *userSpeakLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation JHCustomerDescCommentTextTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xF9FAF9);
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _userNameLabel               = [[UILabel alloc] init];
    _userNameLabel.textColor     = HEXCOLOR(0x333333);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    _userNameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _userNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
//        make.width.mas_equalTo(70.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
//    _userSpeakLabel               = [[UILabel alloc] init];
//    _userSpeakLabel.textColor     = HEXCOLOR(0x666666);
//    _userSpeakLabel.textAlignment = NSTextAlignmentLeft;
//    _userSpeakLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
//    _userSpeakLabel.numberOfLines = 2;
//    [_userSpeakLabel setPreferredMaxLayoutWidth:ScreenW -118.f-29.f];
//    [self.contentView addSubview:_userSpeakLabel];
//    [_userSpeakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.userNameLabel.mas_right).offset(2.f);
//        make.top.equalTo(self.contentView.mas_top).offset(5.f);
//        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
//        make.height.mas_equalTo(18.f);
//    }];
    
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.textColor     = HEXCOLOR(0x999999);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font          = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    return [self calculationTextWidthWith:string font:font CGSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}


- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font CGSize:(CGSize)cgsize {
    CGSize size = [string boundingRectWithSize:cgsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeCommentItemVOSModel *model = [JHCustomizeCommentItemVOSModel cast:viewModel];
    if (!model) {
        return;
    }
    
    /// 名称 + 内容
    NSString *nameStr = @"";
    if (isEmpty(model.customerName)) {
        nameStr = @"";
    } else {
        nameStr = [NSString stringWithFormat:@"%@：",model.customerName];
    }
    NSString *contentStr = @"";
    if (isEmpty(model.content)) {
        contentStr = @"";
    } else {
        contentStr = model.content;
    }
    NSString *finalStr = [NSString stringWithFormat:@"%@ %@",nameStr,contentStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:finalStr];
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attStr font:self.userNameLabel.font];
    CGSize titleSize = [self calculationTextWidthWith:finalStr font:[UIFont fontWithName:kFontNormal size:12.f] CGSize:CGSizeMake(ScreenWidth - 36.f - 15.f -20.f, CGFLOAT_MAX)];

    if (titleSize.height >17.f) {
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(titleSize.height + 1);
        }];
    } else {
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17.f);
        }];
    }
    
    self.userNameLabel.attributedText = attStr;
    
    
    if (isEmpty(model.pushTimeStr)) {
        self.timeLabel.text = @"";
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    } else {
        self.timeLabel.text = model.pushTimeStr;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16.f);
        }];
    }
}

@end
