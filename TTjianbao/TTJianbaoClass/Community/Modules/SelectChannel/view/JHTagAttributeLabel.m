//
//  JHTagAttributeLabel.m
//  TTjianbao
//
//  Created by lihui on 2020/5/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTagAttributeLabel.h"
#import "UIImage+JHColor.h"

@interface JHTagAttributeLabel ()

///显示标签的label
@property (nonatomic, strong) UIButton *tagButton;

@end

@implementation JHTagAttributeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIButton *tagButton = [[UIButton alloc] init];
    [tagButton setTitle:@"" forState:UIControlStateNormal];
    tagButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    tagButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
    [self addSubview:tagButton];
    _tagButton = tagButton;
        
    [_tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.left.top.equalTo(self).offset(2);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(0);
    }];
    
    [_tagButton layoutIfNeeded];
    _tagButton.layer.cornerRadius = 4.f;
    _tagButton.layer.masksToBounds = YES;
}


- (void)setTagTitle:(NSString *)tagTitle {
    NSAttributedString *attrText = nil;
    if (!tagTitle) {
        attrText = [[NSAttributedString alloc] initWithString:self.text];
        self.attributedText = attrText;
        return;
    }
    
    _tagTitle = tagTitle;
    CGRect titleRect = [_tagTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
    UIImage *imgGradient = [UIImage gradientColorImageFromColors:@[HEXCOLOR(0xFF3333), HEXCOLOR(0xFF8A53)] gradientType:JHGradientFromLeftToRight imgSize:CGSizeMake(titleRect.size.width+10, 18) string:_tagTitle radius:4.f];
    [self setText:self.text frontImages:@[imgGradient] imageSpan:2];
}

/**
为UILabel首部设置图片标签

@param text 文本
@param images 标签数组
@param span 标签间距
*/
-(void)setText:(NSString *)text frontImages:(NSArray<UIImage *> *)images imageSpan:(CGFloat)span {
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
    for (UIImage *img in images) {//遍历添加标签
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = img;
        //计算图片大小，与文字同高，按比例设置宽度
        CGFloat imgH = self.font.pointSize;
        CGFloat imgW = (img.size.width / img.size.height) * imgH;
        //计算文字padding-top ，使图片垂直居中
        CGFloat textPaddingTop = (self.font.lineHeight - self.font.pointSize) / 2;
        attach.bounds = CGRectMake(0, -textPaddingTop , imgW, imgH);
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
        [textAttrStr appendAttributedString:imgStr];
        //标签后添加空格
        [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    //设置显示文本
    [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    //设置间距
    if (span != 0) {
        [textAttrStr addAttribute:NSKernAttributeName value:@(span)
                            range:NSMakeRange(0, images.count * 2/*由于图片也会占用一个单位长度,所以带上空格数量，需要 *2 */)];
    }
    self.attributedText = textAttrStr;
    ///因为设置attributedText后 分割方式被修改 需要重新设置
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end

