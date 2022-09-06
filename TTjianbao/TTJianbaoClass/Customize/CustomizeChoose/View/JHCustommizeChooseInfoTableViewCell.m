//
//  JHCustommizeChooseInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustommizeChooseInfoTableViewCell.h"
#import "TTjianbaoMarcoUI.h"
#import "UIView+JHGradient.h"
#import "JHCustomizeChooseTagView.h"
#import "JHCustomizeChooseOpusView.h"
#import "UIButton+ImageTitleSpacing.h"
//#import "JHCustomizeChooseMoneyView.h"
#import "JHCustomizeChooseModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"

#import <UIKit/UIKit.h>
 
typedef enum {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
 
@interface MYCustomizeUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;
@end

@implementation MYCustomizeUILabel
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





























@interface JHCustommizeChooseInfoTableViewCell ()
@property (nonatomic, strong) UIView                     *iconView;
@property (nonatomic, strong) UIImageView                *iconImageView;
@property (nonatomic, strong) UIView                     *iconBorderView;
@property (nonatomic, strong) YYAnimatedImageView        *liveGifView;
@property (nonatomic, strong) UILabel                    *nickNameLabel;      /// 昵称
@property (nonatomic, strong) UIButton                   *autherationButton;  /// 认证定制师标识
@property (nonatomic, strong) UIButton                   *applyButton;        /// 申请定制按钮
@property (nonatomic, strong) UILabel                    *areaLabel;          /// 例：江西省工艺美术师
@property (nonatomic, strong) UILabel                    *queueCountLabel;    /// 排队人数
@property (nonatomic, strong) UILabel                    *favRateLabel;       /// 好评率
@property (nonatomic, strong) UILabel                    *descLabel;          /// 简介
@property (nonatomic, strong) JHCustomizeChooseTagView   *tagView;            /// 标签滚动视图
@property (nonatomic, strong) UILabel                    *opusLabel;          /// 代表作标题
@property (nonatomic, strong) JHCustomizeChooseOpusView  *opusView;           /// 代表作
//@property (nonatomic, strong) JHCustomizeChooseMoneyView *moneyView;          /// 价格
@property (nonatomic, assign) BOOL                        needShowAll;
@property (nonatomic, assign) CGFloat                     needShowAllHeight;
@property (nonatomic, strong) UIView                     *lineView;
@property (nonatomic, strong) MYCustomizeUILabel         *stuffDetailLabel;
@property (nonatomic, strong) MYCustomizeUILabel         *moneyLabel;
@property (nonatomic, strong) UIButton                   *showAllBtn; /// 展开按钮
@end

@implementation JHCustommizeChooseInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
//    self.contentView.layer.cornerRadius = 8.f;
//    self.contentView.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 8.f;
//    self.layer.masksToBounds = YES;
    
    _iconView = [[UIView alloc] init];
    _iconView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.size.mas_equalTo(CGSizeMake(38.f, 38.f));
    }];
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius  = 17.f;
    _iconImageView.layer.masksToBounds = YES;
    [_iconView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
        
    /// 黄圈的view
    _iconBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
    [_iconView addSubview:_iconBorderView];
    _iconBorderView.hidden = YES;
    [_iconBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView);
    }];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
    NSData *data   = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data];
    _liveGifView   = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
    _liveGifView.hidden = YES;
    [self.contentView addSubview:_liveGifView];
    [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.iconBorderView);
        make.size.mas_equalTo(CGSizeMake(13.f, 13.f));
    }];
    
    _nickNameLabel           = [[UILabel alloc] init];
    _nickNameLabel.textColor = kColor333;
    _nickNameLabel.font      = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10.f);
        make.top.equalTo(self.iconBorderView.mas_top);
        make.height.mas_equalTo(21.f);
    }];
    _nickNameLabel.userInteractionEnabled = YES;
        
    _autherationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_autherationButton setImage:[UIImage imageNamed:@"customize_authen_icon"] forState:UIControlStateNormal];
    [_autherationButton setTitle:@"认证定制师" forState:UIControlStateNormal];
    [_autherationButton setTitleColor:kColor999 forState:UIControlStateNormal];
    _autherationButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:10.f];
    [_autherationButton addTarget:self action:@selector(imageViewTapAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_autherationButton];
    [_autherationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickNameLabel.mas_centerY);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(65.f, 14.f));
    }];
    [_autherationButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3.];
    
    
    _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _applyButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    _applyButton.layer.cornerRadius = 15.f;
    _applyButton.layer.masksToBounds = YES;
    [_applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_applyButton];
    [_applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.contentView.mas_top).offset(14.f);
        make.size.mas_equalTo(CGSizeMake(78.f, 30.f));
    }];
        
    
    _areaLabel           = [[UILabel alloc] init];
    _areaLabel.textColor = kColor999;
    _areaLabel.font      = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_areaLabel];
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_left);
        make.top.equalTo(self.nickNameLabel.mas_bottom);
        make.height.mas_equalTo(17.f);
    }];
    _areaLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAciton)];
    [_iconView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAciton)];
    [_iconBorderView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAciton)];
    [_nickNameLabel addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAciton)];
    [_areaLabel addGestureRecognizer:tap3];
    
    
    /// 标签
    _tagView = [[JHCustomizeChooseTagView alloc] init];
    [self.contentView addSubview:_tagView];
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.iconView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(24.f);
    }];
    
    _descLabel               = [[UILabel alloc] init];
    _descLabel.numberOfLines = 2;
    _descLabel.textColor     = kColor999;
    _descLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.tagView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(18.f);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.descLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    _queueCountLabel           = [[UILabel alloc] init];
    _queueCountLabel.textColor = kColor666;
    _queueCountLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_queueCountLabel];
    [_queueCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left);
        make.top.equalTo(self.lineView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    _favRateLabel           = [[UILabel alloc] init];
    _favRateLabel.textColor = kColor666;
    _favRateLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_favRateLabel];
    [_favRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.queueCountLabel.mas_right).offset(10.f);
        make.centerY.equalTo(self.queueCountLabel.mas_centerY);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 可定制材质
    _stuffDetailLabel = [[MYCustomizeUILabel alloc] init];
    _stuffDetailLabel.textColor = kColor666;
    _stuffDetailLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    _stuffDetailLabel.numberOfLines = 0;
    [self.contentView addSubview:_stuffDetailLabel];
    [_stuffDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.queueCountLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 可定制类别
    _moneyLabel               = [[MYCustomizeUILabel alloc] init];
    _moneyLabel.textColor     = kColor666;
    _moneyLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _moneyLabel.numberOfLines = 0;
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.stuffDetailLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(17.f);
    }];
    
    _showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showAllBtn setTitle:@"展开" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _showAllBtn.backgroundColor = HEXCOLOR(0xffffff);
    _showAllBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    _showAllBtn.selected = NO;
    _showAllBtn.hidden = YES;
    [self.contentView addSubview:_showAllBtn];
    [_showAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.bottom.equalTo(self.moneyLabel.mas_bottom);
        make.height.mas_equalTo(17.f);
    }];
    
    
    _opusLabel               = [[UILabel alloc] init];
    _opusLabel.textColor     = kColor333;
    _opusLabel.text          = @"代表作";
    _opusLabel.font          = [UIFont fontWithName:kFontMedium size:12.f];
    [self.contentView addSubview:_opusLabel];
    [_opusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    _opusView = [[JHCustomizeChooseOpusView alloc] init];
    [self.contentView addSubview:_opusView];
    [_opusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.opusLabel.mas_bottom).offset(3.f);
        make.height.mas_equalTo(80.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    @weakify(self);
    _opusView.opusClickAcion = ^{
        @strongify(self);
        if (self.opusListClickAction) {
            self.opusListClickAction();
        }
    };
}


- (void)showButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.needShowAll = sender.isSelected;
    [self.showAllBtn setTitle:sender.selected?@"收起":@"展开" forState:UIControlStateNormal];
    if (self.showAllAction) {
        self.showAllAction();
    }
}


- (void)imageViewTapAciton {
    if (self.iconClickAction) {
        self.iconClickAction();
    }
}

- (void)applyButtonAction:(UIButton *)sender {
    if (self.applyBtnAction) {
        self.applyBtnAction();
    }
}

- (CGSize)calculationTextWidthWith:(NSString*)string font:(UIFont *)font {
    CGSize width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return width;
}


- (CGSize)calculationTextWidthWith:(NSString*)string font:(UIFont *)font cgsize:(CGSize)cgsize {
    CGSize width = [string boundingRectWithSize:cgsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return width;
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeChooseModel *model = [JHCustomizeChooseModel cast:viewModel];
    if (!model) {
        return;
    }
    [JHDispatch ui:^{
        NSString *nameStr = NONNULL_STR(model.name);
        if (nameStr.length >8) {
            nameStr = [NSString stringWithFormat:@"%@...",[nameStr substringWithRange:NSMakeRange(0, 8)]];
        }
        self.nickNameLabel.text = nameStr;
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultCoverImage];
        
        if (model.status == 2) {
            self.liveGifView.hidden   = NO;
            self.iconBorderView.hidden = NO;
            if ([model.canCustomize isEqualToString:@"1"]) {
                [_applyButton setTitle:@"申请定制" forState:UIControlStateNormal];
                [_applyButton setTitleColor:kColor333 forState:UIControlStateNormal];
                [_applyButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            } else {
                [_applyButton setTitle:@"暂停申请" forState:UIControlStateNormal];
                [_applyButton setTitleColor:kColor999 forState:UIControlStateNormal];
                _applyButton.backgroundColor = HEXCOLOR(0xEEEEEE);
                [_applyButton jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            }
        } else {
            self.liveGifView.hidden   = YES;
            self.iconBorderView.hidden = YES;
            [_applyButton setTitle:@"暂停申请" forState:UIControlStateNormal];
            [_applyButton setTitleColor:kColor999 forState:UIControlStateNormal];
            _applyButton.backgroundColor = HEXCOLOR(0xEEEEEE);
            [_applyButton jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        }
        
        NSString *titleString = NONNULL_STR(model.title);
        if (titleString.length >11) {
            titleString = [NSString stringWithFormat:@"%@...",[nameStr substringWithRange:NSMakeRange(0, 11)]];
        }
        self.areaLabel.text = titleString;
        
        /// 标签
        [self.tagView setViewModel:model.tags];
        if (model.tags.count >0) {
            BOOL showHeight = NO;
            for (NSString *str in model.tags) {
                if (!isEmpty(str)) {
                    showHeight = YES;
                }
            }
            if (showHeight) {
                [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.iconView.mas_bottom).offset(10.f);
                    make.height.mas_equalTo(24.f);
                }];
            } else {
                [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.iconView.mas_bottom).offset(0.f);
                    make.height.mas_equalTo(0.f);
                }];
            }
        } else {
            [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.iconView.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
        
        /// 详情
        if (!isEmpty(model.introduction)) {
            self.descLabel.text       = model.introduction;
            CGSize size = [self calculationTextWidthWith:model.introduction font:[UIFont fontWithName:kFontNormal size:12.f]];
            if (size.width > (ScreenWidth -40.f)) {
                [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tagView.mas_bottom).offset(10.f);
                    make.height.mas_equalTo(36.f);
                }];
                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.descLabel.mas_bottom).offset(10.f);
                    make.height.mas_equalTo(0.5f);
                }];
            } else {
                [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tagView.mas_bottom).offset(10.f);
                    make.height.mas_equalTo(18.f);
                }];
                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.descLabel.mas_bottom).offset(10.f);
                    make.height.mas_equalTo(0.5f);
                }];
            }
        } else {
            self.descLabel.text = @"";
            [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tagView.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.descLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
        
        /// 排队人数，好评率
        if (model.status == 2) {
            if (model.waitCount >0) {
                self.queueCountLabel.text = [NSString stringWithFormat:@"排队人数：%ld",(long)model.waitCount];
            } else {
                self.queueCountLabel.text = @"排队人数：0";
            }
        } else {
            self.queueCountLabel.text = @"";
        }
                
        if (!isEmpty(model.commentGrade)) {
            self.favRateLabel.text    = [NSString stringWithFormat:@"好评率：%@",model.commentGrade];
        } else {
            self.favRateLabel.text    = @"";
        }
        
        if (model.status == 2) {
            [self.favRateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.queueCountLabel.mas_right).offset(10.f);
            }];
        } else {
            [self.favRateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.queueCountLabel.mas_right).offset(0.f);
            }];
        }
        
        if (isEmpty(self.queueCountLabel.text) && isEmpty(self.favRateLabel.text)) {
            [self.queueCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        } else {
            [self.queueCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom).offset(10.f);
                make.height.mas_equalTo(17.f);
            }];
        }
        
        /// 可定制材质
        if (model.materials.count >0) {
            NSMutableArray *feesArr = [model.materials jh_map:^id _Nonnull(JHCustomizeChooseMaterialsModel * _Nonnull obj, NSUInteger idx) {
                return obj.name;
            }];
            NSString *stuffStr = [NSString stringWithFormat:@"可定制材质：%@",[feesArr componentsJoinedByString:@" · "]]; ///•
            
            CGSize size = [self calculationTextWidthWith:stuffStr font:[UIFont fontWithName:kFontNormal size:12.f] cgsize:CGSizeMake(ScreenWidth -20.f, CGFLOAT_MAX)];
            if (size.height > 17.f) {
                [self.stuffDetailLabel setVerticalAlignment:VerticalAlignmentTop];
                [_stuffDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.queueCountLabel.mas_bottom).offset(5.f);
                    make.height.mas_equalTo(size.height + 1);
                }];
            } else {
                [self.stuffDetailLabel setVerticalAlignment:VerticalAlignmentMiddle];
                [_stuffDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.queueCountLabel.mas_bottom).offset(5.f);
                    make.height.mas_equalTo(17.f);
                }];
            }
            self.stuffDetailLabel.text = stuffStr;
        } else {
            [self.stuffDetailLabel setVerticalAlignment:VerticalAlignmentMiddle];
            self.stuffDetailLabel.text = nil;
            [self.stuffDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.queueCountLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }

        
        /// 可定制类别
        if (model.fees.count >0) {
            NSMutableArray *feesArr = [model.fees jh_map:^id _Nonnull(JHCustomizeChooseFeesModel * _Nonnull obj, NSUInteger idx) {
                return [NSString stringWithFormat:@"%@ ￥%@-%@",obj.name,obj.minPrice,obj.maxPrice];
            }];
            NSString *moneyStr = [NSString stringWithFormat:@"可定制类别：%@",[feesArr componentsJoinedByString:@" / "]];
            CGSize size = [self calculationTextWidthWith:moneyStr font:[UIFont fontWithName:kFontNormal size:12.f] cgsize:CGSizeMake(ScreenWidth -20.f, CGFLOAT_MAX)];
            
            if (self.needShowAll) {
                self.showAllBtn.hidden = NO;
                [self.moneyLabel setVerticalAlignment:VerticalAlignmentTop];
                [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.stuffDetailLabel.mas_bottom).offset(5.f);
                    make.right.equalTo(self.contentView.mas_right).offset(-10.f);
                    make.height.mas_equalTo(size.height + 17.f +6.f);
                }];
            } else {
                [self.moneyLabel setVerticalAlignment:VerticalAlignmentMiddle];
                if (size.height > 17.f) {
                    self.showAllBtn.hidden = NO;
                    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.stuffDetailLabel.mas_bottom).offset(5.f);
                        make.right.equalTo(self.contentView.mas_right).offset(-33.f);
                        make.height.mas_equalTo(17.f);
                    }];
                } else {
                    self.showAllBtn.hidden = YES;
                    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.stuffDetailLabel.mas_bottom).offset(5.f);
                        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
                        make.height.mas_equalTo(17.f);
                    }];
                }
            }
            self.moneyLabel.text = moneyStr;
        } else {
            self.showAllBtn.hidden = YES;
            self.moneyLabel.text = nil;
            [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.stuffDetailLabel.mas_bottom).offset(0.f);
                make.right.equalTo(self.contentView.mas_right).offset(-10.f);
                make.height.mas_equalTo(0.f);
            }];
        }
        
        /// 代表作
        if (model.opusList.count >0) {
            [self.opusView setViewModel:model.opusList];
            [self.opusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moneyLabel.mas_bottom).offset(10.f);
                make.height.mas_equalTo(17.f);
            }];
            [self.opusView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.opusLabel.mas_bottom).offset(10.f);
                make.height.mas_equalTo(80.f);
            }];
        } else {
            [self.opusView setViewModel:model.opusList];
            [self.opusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moneyLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
            [self.opusView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.opusLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
    }];
}




@end

