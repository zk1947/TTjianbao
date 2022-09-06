//
//  JHEvaluateCell.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHEvaluateCell.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setModel:(JHEvaluationModel *)model {
    _model = model;
    if (model) {
        [_avatar nim_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kDefaultAvatarImage];
        _nickLabel.text = model.customerName;
        _contentLabel.text = model.commentContent;
        _timeLabel.text = [model.createTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        CGFloat ww = (ScreenW - 94 - 10)/3.;
        NSInteger count = model.commentTagList.count;
        
        _tagHeight.constant = [JHEvaluateCell getTagHeightWithCount:count];
        for (int i = 0; i < self.tagArray.count; i++) {
            UILabel *label = self.tagArray[i];
            if (i<count) {
                NSDictionary *dic = model.commentTagList[i];
                label.text = dic[@"tagName"];
                label.frame = CGRectMake((ww+5)*(i%3), ((int)i/3)*40+10, ww, 35);
                label.hidden = NO;
            }else {
                label.hidden = YES;
            }

        }
        
    }
}

+ (CGFloat)getTagHeightWithCount:(NSInteger)count {
    CGFloat height = 0;
    if (count>3) {
        height = 95;
    }else if (count == 0) {
        height = 10;
    } else {
        height = 55;
    }
    return height;
}


+ (CGFloat)getHeightWithContent:(NSString *)string {
    if (!string || string.length<=0) {
        return 0;
    }
    CGFloat width = ScreenW - 94.;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *stringM = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15], NSParagraphStyleAttributeName:style}];
    
    CGSize size =  [stringM boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(size));
    
    CGFloat height = ceil(size.height) + 1;
    
    return height;
    
}

+ (CGFloat)cellHeightWithModel:(JHEvaluationModel *)model {
    CGFloat hh = [JHEvaluateCell getTagHeightWithCount:model.commentTagList.count];
    hh += [JHEvaluateCell getHeightWithContent:model.commentContent];
    hh += 75;
    return hh;
}

@end
