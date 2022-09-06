//
//  JHLiveRoomInfoTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomInfoTableCell.h"
#import "NSString+Emotion.h"
#import "YYControl.h"
#import "JHLiveRoomModel.h"
#import "TTjianbaoMarcoUI.h"

@interface JHLiveRoomInfoTableCell ()
///直播间介绍描述
@property (nonatomic, strong) YYLabel *descLabel;
///收起按钮
@property (nonatomic, strong) UIButton *foldButton;
///添加描述
@property (nonatomic, strong) YYControl *addDescView;
///添加图标
@property (nonatomic, strong) UIImageView *addImageView;
///添加文字
@property (nonatomic, strong) UILabel *addDescLabel;

@property (nonatomic, assign) BOOL isShowAll;

@end

@implementation JHLiveRoomInfoTableCell

- (void)setRoomInfo:(JHLiveRoomModel *)roomInfo {
    if (!roomInfo) {
        return;
    }
    _roomInfo = roomInfo;
    if (_roomInfo.showButton) {
        if ([_roomInfo.roomDes isNotBlank]) {
            _addDescView.hidden = YES;
            _descLabel.hidden = NO;
            _descLabel.attributedText = _roomInfo.descAttriText;
        }
        else {
            _addDescView.hidden = NO;
            _descLabel.hidden = YES;
            _descLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
        }
    }
    else {
        _addDescView.hidden = YES;
        _descLabel.hidden = NO;
        if ([_roomInfo.roomDes isNotBlank]) {
            _descLabel.attributedText = _roomInfo.descAttriText;
        }
        else {
            NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:_roomInfo.placeholderString];
            [introText setLineSpacing:5.f];
            [introText setAlignment:NSTextAlignmentLeft];
            [introText setLineBreakMode:NSLineBreakByCharWrapping];
            [introText addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
                                       NSForegroundColorAttributeName:kColor666
            } range:NSMakeRange(0, [_roomInfo.placeholderString length])];

            _descLabel.attributedText = introText;
        }
    }
    
    _foldButton.hidden = !_isShowAll;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isShowAll = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    YYLabel *descLabel = [[YYLabel alloc] init];
    descLabel.text = @"暂无介绍";
    descLabel.font = [UIFont fontWithName:kFontNormal size:12];
    descLabel.textColor = kColor666;
    [self.contentView addSubview:descLabel];
    descLabel.numberOfLines = 3;
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _descLabel = descLabel;
    [self addSeeMoreButton];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"收起" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    [btn addTarget:self action:@selector(foldIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    btn.hidden = YES;
    _foldButton = btn;
    
    YYControl *addView = [[YYControl alloc] init];
    addView.backgroundColor = kColorF5F6FA;
    [self.contentView addSubview:addView];
    _addDescView = addView;
    _addDescView.hidden = YES;
    _addDescView.exclusiveTouch = YES;
    @weakify(self);
    _addDescView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                //点击事件
                [self handleClickAddEvent];
            }
        }
    };
    
    UIImageView *addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_anchor_add"]];
    addImgView.contentMode = UIViewContentModeScaleAspectFit;
    [addView addSubview:addImgView];
    _addImageView = addImgView;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"点击添加";
    addLabel.textColor = kColor999;
    addLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [addView addSubview:addLabel];
    _addDescLabel = addLabel;
    
    [self makeLayouts];
}

- (void)handleClickAddEvent {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)makeLayouts {
    [_foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0);
    }];

    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.foldButton.mas_top);
    }];
    
    [_addDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 5, 15));
    }];
    
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addDescView);
        make.centerY.equalTo(self.addDescView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [_addDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addDescView);
        make.centerY.equalTo(self.addDescView).offset(12);
    }];
    
    [self bringSubviewToFront:_foldButton];
}

#pragma mark -
#pragma mark - 事件处理

//点击展开
- (void)clickMoreEvent {
    _descLabel.numberOfLines = 0;
    _foldButton.hidden = NO;
    _isShowAll = YES;
    [_foldButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
    }];
    if (self.updateBlock) {
        self.updateBlock(self.roomInfo.roomDesAllHeight+10);
    }
}

- (void)foldIntroduction {
    _descLabel.numberOfLines = 3;
    _foldButton.hidden = YES;
    _isShowAll = NO;
    [_foldButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];

    if (self.updateBlock) {
        self.updateBlock(self.roomInfo.roomDesHeight);
    }
}

#pragma mark - 全文按钮

- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"... 展开"];
    
    YYTextHighlight *hlText = [YYTextHighlight new];
    [hlText setColor:kColor666];
    @weakify(self);
    hlText.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        [self clickMoreEvent];
    };
    
    [text setColor:kColor666 range:[text.string rangeOfString:@"..."]];
    [text setColor:HEXCOLOR(0x408FFE) range:[text.string rangeOfString:@"展开"]];
    [text setTextHighlight:hlText range:[text.string rangeOfString:@"展开"]];
    text.font = [UIFont fontWithName:kFontMedium size:13];
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    _descLabel.truncationToken = truncationToken;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
