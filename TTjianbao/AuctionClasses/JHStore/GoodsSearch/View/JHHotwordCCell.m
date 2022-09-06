//
//  JHHotwordCCell.m
//  TTjianbao
//
//  Created by LiHui on 2020/2/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHotwordCCell.h"
#import "TTjianbaoHeader.h"
#import "JHHotWordModel.h"

@interface JHHotwordCCell ()

///标签
@property (nonatomic, strong) UILabel *tagLabel;
///标题
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation JHHotwordCCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setSearchData:(JHHotWordModel *)searchData {
    if (!searchData) {return;}
    _searchData = searchData;
    _textLabel.text = _searchData.title;

}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [self setupTagLabelUI:indexPath.item];
    _tagLabel.text = @(indexPath.item + 1).stringValue;
}

- (void)initViews {
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.text = @"1";
    _tagLabel.textColor = HEXCOLOR(0x999999);
    _tagLabel.backgroundColor = HEXCOLOR(0xDDDDDD);
    _tagLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.layer.cornerRadius = 2.f;
    _tagLabel.layer.masksToBounds = YES;
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.text = @"--";
    _textLabel.textColor = HEXCOLOR(0x333333);
    _textLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:_tagLabel];
    [self.contentView addSubview:_textLabel];
    
    _tagLabel.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .topEqualToView(self.contentView)
    .widthIs(18)
    .heightEqualToWidth();
    
    _textLabel.sd_layout
    .leftSpaceToView(_tagLabel, 5)
    .topEqualToView(_tagLabel)
    .bottomEqualToView(_tagLabel)
    .rightSpaceToView(self.contentView, 10);
}

///设置标签的背景色 字体颜色
- (void)setupTagLabelUI:(NSInteger)index {
    UIColor *backgroundColor, *textColor;
    switch (index) {
        case 0:
        {
            backgroundColor = HEXCOLOR(0xFEE100);
            textColor = HEXCOLOR(0x333333);
        }
            break;
        case 1:
        {
            backgroundColor = HEXCOLOR(0xFF4200);
            textColor = HEXCOLOR(0xFFFFFF);
        }
            break;
        case 2:
        {
            backgroundColor = HEXCOLOR(0x408FFE);
            textColor = HEXCOLOR(0xFFFFFF);
        }
            break;
        default:
        {
            backgroundColor = HEXCOLOR(0xDDDDDD);
            textColor = HEXCOLOR(0x999999);
        }
            break;
    }
    
    ///设置颜色
    _tagLabel.backgroundColor = backgroundColor;
    _tagLabel.textColor = textColor;
}


@end
