//
//  JHReLaunchCertTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReLaunchCertTableViewCell.h"
#import "TTjianbao.h"
#import "UIView+CornerRadius.h"

#define space 10

@interface JHReLaunchCertTableViewCell ()

@property (nonatomic, strong) YYLabel *label;

@end

@implementation JHReLaunchCertTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self yd_setCornerRadius:4.f corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        
        [self initViews];
    }
    return self;
}

- (void)setMessage:(NSString *)message rangeString:(NSString *)rangeString {
    if (!message){
        return;
    }
    NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSDictionary * attris = @{NSBackgroundColorAttributeName:[UIColor whiteColor],NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:kFontMedium size:13]};
    NSRange range = [message rangeOfString:rangeString];
    [mutableAttriStr setAttributes:attris range:range];
    @weakify(self);
    [mutableAttriStr setTextHighlightRange:range color:[UIColor blackColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if (self.rangeStringAction) {
            self.rangeStringAction();
        }
    }];
    _label.attributedText = mutableAttriStr;
}

- (void)initViews {
    YYLabel *label = [[YYLabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
//    label.attributedText = @"";
    label.userInteractionEnabled = YES;
    label.font = [UIFont fontWithName:kFontNormal size:13];
    label.textColor = HEXCOLOR(0x666666);
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    _label = label;
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(space, space, space, space));
    }];
}



#pragma mark -
#pragma mark -  button action

- (void)reLanchCertButtonAction {
    
    
    
    
    
    
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
