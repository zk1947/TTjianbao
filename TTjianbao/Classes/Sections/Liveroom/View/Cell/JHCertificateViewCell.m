//
//  JHCertificateViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHCertificateViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHCertificateViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    NSArray *familyFonts = [UIFont familyNames];
    for (NSString * fontStr in familyFonts) {
        NSArray *fonts = [UIFont fontNamesForFamilyName:fontStr];
        for (NSString *fontStr in fonts) {
            NSLog(@"fontStr =  %@" , fontStr);
        }
    }

}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    if (_model) {
        self.nameLabel.attributedText = [self attributedSubString:model[@"authTitle"] allString:[NSString stringWithFormat:@"%@", model[@"authTitle"]]];
        [self.iconImage jhSetImageWithURL:[NSURL URLWithString:model[@"authImg"]] placeholder:kDefaultCoverImage];
        self.desLabel.text = model[@"authDesc"];
    }
}

- (NSMutableAttributedString *)attributedSubString:(NSString *)subString allString:(NSString *)string {
    NSRange range = [string rangeOfString:subString];
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] range:NSMakeRange(0, string.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x00000) range:NSMakeRange(0, string.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:14] range:range];
    
    return attString;
}
@end
