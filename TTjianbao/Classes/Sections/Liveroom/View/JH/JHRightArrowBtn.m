//
//  JHRightArrowBtn.m
//  TTjianbao
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHRightArrowBtn.h"


@implementation JHRightArrowBtn
{
    UIFont* currentFont;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = HEXCOLORA(0x000000, 0.35);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = JHFont(9);
       // currentFont = self.titleLabel.font;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        
        self.arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live_right_arrow"]];
        self.arrowImage.contentMode = UIViewContentModeCenter;
        [self addSubview:self.arrowImage];

        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-6);
    }];
}

- (void)resetRightArrowStyle:(JHRightArrowStyle)style
{
    if(style == JHRightArrowStyleLight)
    {
        [self setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        self.titleLabel.font = self.isRoughStone?JHFont(9):JHFont(10);
      //  currentFont = self.titleLabel.font;
        [self.arrowImage setImage:[UIImage imageNamed:@"icon_live_right_light_arrow"]];
    }
    else if(style == JHRightArrowStyleMediumFont)
    {
        [self setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        self.titleLabel.font = self.isRoughStone?JHMediumFont(9):JHMediumFont(10);
      //  currentFont = self.titleLabel.font;
        [self.arrowImage setImage:[UIImage imageNamed:@"icon_live_right_light_arrow"]];
    }
    else
    {
        [self setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        self.titleLabel.font = self.isRoughStone?JHFont(9):JHFont(10);
       // currentFont = self.titleLabel.font;
        [self.arrowImage setImage:[UIImage imageNamed:@"icon_live_right_arrow"]];
    }
}

- (void)setRightArrow {
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.imageView.image.size.width, 0, self.imageView.image.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:[NSString stringWithFormat:@"  %@     ",title] forState:state];
    [self setSelfWidth];
}

- (void)setSelfWidth {
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font ? : JHFont(9)};

    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.height) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    
    self.width = size.width;
}

@end
