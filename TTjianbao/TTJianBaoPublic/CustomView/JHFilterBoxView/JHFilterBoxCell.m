//
//  JHFilterBoxCell.m
//  test
//
//  Created by YJ on 2020/12/15.
//  Copyright © 2020 YJ. All rights reserved.
//

#import "JHFilterBoxCell.h"
#import "TTJianBaoColor.h"

@interface JHFilterBoxCell()

@property (strong, nonatomic) UILabel *textlabel;

@end

@implementation JHFilterBoxCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat WIDHT =  ([UIScreen mainScreen].bounds.size.width - 100 - 15*2 - 10*2)/3;
        self.textlabel.frame = CGRectMake(0, 0, WIDHT, 28);
    }
    return self;
}

- (void)setModel:(JHFilterBoxModel *)model
{
    self.textlabel.text = model.name;
    if (model.isSelected)
    {
        self.textlabel.textColor = BLACK_COLOR;
        self.textlabel.backgroundColor = SELECTED_COLOR;
    }
    else
    {
        self.textlabel.textColor = GRAY_COLOR;
        self.textlabel.backgroundColor = USELECTED_COLOR;
    }

}

- (UILabel *)textlabel
{
    if (!_textlabel)
    {
        _textlabel = [[UILabel alloc] init];
        _textlabel.layer.cornerRadius = 28/2;
        _textlabel.backgroundColor =  USELECTED_COLOR;
        _textlabel.textAlignment = NSTextAlignmentCenter;
        _textlabel.textColor = GRAY_COLOR;
        _textlabel.clipsToBounds = YES;
        _textlabel.font = [UIFont fontWithName:kFontNormal size:13.0f];
        [self.contentView addSubview:_textlabel];
    }
    return _textlabel;
}
@end
