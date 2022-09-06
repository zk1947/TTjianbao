//
//  ZQSearchNormalCell.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQSearchNormalCell.h"
#import "TTjianbaoHeader.h"
#import "UIColor+ZQSearch.h"

@interface ZQSearchNormalCell()

//@property (weak, nonatomic) UILabel *titleLabel;


@end

@implementation ZQSearchNormalCell

+ (CGFloat)cellHeight {
    return 27;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = [ZQSearchNormalCell cellHeight]/2;
    self.contentView.clipsToBounds = true;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    
}

@end
