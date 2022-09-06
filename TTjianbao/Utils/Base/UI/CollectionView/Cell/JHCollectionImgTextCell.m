//
//  JHCollectionImgTextCell.m
//  TTjianbao
//
//  Created by jesee on 18/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionImgTextCell.h"

#define kMarginWidth 5
#define kMarginHeight 3
#define kImageSmallSize 14
#define kImageCloseSize 12
#define kImageTextSpace 2
#define kTextImageSpace 5

@interface JHCollectionImgTextCell ()

@property (nonatomic, assign) CGFloat extOffset;
@property (nonatomic, strong) UILabel* titleLabel;
@end

@implementation JHCollectionImgTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //text
        self.titleLabel = [UILabel new];
        self.titleLabel.font = JHFont(12);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.titleLabel setTextColor:HEXCOLOR(0x408FFE)];
        [self.bgView addSubview:self.titleLabel];
    }
    return self;
}

- (void)drawSubviews
{
    self.extOffset = 0;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.mas_equalTo(24);
    }];
    self.bgView.backgroundColor = HEXCOLOR(0xEEF3FA);
    self.bgView.layer.cornerRadius = 12.0;
    //image
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.imageView setImage:[UIImage imageNamed:@"publish_selected_topic_img"]];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).offset(kMarginWidth);
        make.bottom.equalTo(self.bgView).offset(0 - kMarginWidth);
        make.size.mas_offset(kImageSmallSize);
    }];
    
    //text
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(kMarginHeight);
        make.left.mas_equalTo(self.imageView.mas_right).offset(kImageTextSpace);
        make.bottom.equalTo(self.bgView).offset(0 - kMarginHeight);
        make.right.equalTo(self.bgView).offset(0 - kMarginWidth);
    }];
}

// 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil];

    rect.size.width += kMarginWidth * 2 + kImageTextSpace + kImageSmallSize + self.extOffset;
    rect.size.height += kMarginHeight * 2;
    attributes.frame = rect;

    return attributes;
}

#pragma mark - data
- (void)updateCellImage:(NSString*)image text:(NSString*)text
{
    self.titleLabel.text = text;
}

@end

#pragma mark -xx
#pragma mark -2-ext:image+text+X(e.g. close)
@implementation JHCollectionImgTextCellExt
{
    UIImageView* closeImage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //image
        closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_tips_delete"]];
        [self.bgView addSubview:closeImage];
        @weakify(self);
        [closeImage jh_addTapGesture:^{
            @strongify(self);
            if(self.deleteBlock)
            {
                self.deleteBlock();
            }
        }];
    }
    return self;
}

- (void)drawSubviews
{
    [super drawSubviews];
    self.extOffset = kTextImageSpace + kImageCloseSize; //间距和close image大小
    //text
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(kMarginHeight);
        make.left.mas_equalTo(self.imageView.mas_right).offset(kImageTextSpace);
        make.bottom.equalTo(self.bgView).offset(0 - kMarginHeight);
    }];
    
    //image
    [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(3);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(kTextImageSpace);
        make.right.equalTo(self.bgView).offset(0 - kMarginWidth);
        make.size.mas_offset(kImageCloseSize);
    }];
}

// 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    return attributes;
}

#pragma mark - data
- (void)updateCellImage:(NSString*)image text:(NSString*)text
{
    [super updateCellImage: image text:text];
}

@end
