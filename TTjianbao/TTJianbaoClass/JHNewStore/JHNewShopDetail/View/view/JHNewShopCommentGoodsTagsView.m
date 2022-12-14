//
//  JHNewShopCommentGoodsTagsView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopCommentGoodsTagsView.h"

@interface JHNewShopCommentGoodsTagsView ()

@end

@implementation JHNewShopCommentGoodsTagsView
- (id)init{
    //初始化
    self = [super init];
    if (self) {
        _tagsFrames = [NSMutableArray array];
        _tagsMinPadding = 10;
        _tagsMargin = 10;
        _tagsLineSpacing = 10;
        _tagHeight = 30;
    }
    return self;
}


- (void)initSubviews:(NSArray *)tagsArray{
    [self removeAllSubviews];
    for (NSInteger i = 0; i< tagsArray.count; i++) {
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:tagsArray[i] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        tagsBtn.titleLabel.font = TagsTitleFont;
        tagsBtn.backgroundColor = [UIColor whiteColor];
        tagsBtn.layer.borderWidth = 0.5;
        tagsBtn.layer.borderColor = HEXCOLOR(0xD8D8D8).CGColor;
        tagsBtn.layer.cornerRadius = 1;
        tagsBtn.layer.masksToBounds = YES;
        tagsBtn.frame = CGRectFromString(_tagsFrames[i]);
        [self addSubview:tagsBtn];
    }

}

- (void)setTagsArray:(NSArray *)tagsArray{
    _tagsArray = tagsArray;

    CGFloat btnX = _tagsMargin;
    CGFloat btnW = 0;
    CGFloat nextWidth = 0;  // 下一个标签的宽度
    CGFloat moreWidth = 0;  // 每一行多出来的宽度
    //每一行的最后一个tag的索引的数组和每一行多出来的宽度的数组
    NSMutableArray *lastIndexs = [NSMutableArray array];
    NSMutableArray *moreWidths = [NSMutableArray array];

    for (NSInteger i=0; i<tagsArray.count; i++) {
        btnW = [self sizeWithText:tagsArray[i] font:TagsTitleFont].width + _tagsMinPadding * 2;
        if (i < tagsArray.count-1) {
            nextWidth = [self sizeWithText:tagsArray[i+1] font:TagsTitleFont].width + _tagsMinPadding * 2;
        }
        CGFloat nextBtnX = btnX + btnW + _tagsMargin;
        // 如果下一个按钮，标签最右边则换行
        if ((nextBtnX + nextWidth) > (WIDTH - _tagsMargin)) {
            // 计算超过的宽度
            moreWidth = WIDTH - nextBtnX;
            [lastIndexs addObject:[NSNumber numberWithInteger:i]];
            [moreWidths addObject:[NSNumber numberWithFloat:moreWidth]];
            btnX = _tagsMargin;
        }else{
            btnX += (btnW + _tagsMargin);
        }
        // 如果是最后一个且数组中没有，则把最后一个加入数组
        if (i == tagsArray.count -1) {
            if (![lastIndexs containsObject:[NSNumber numberWithInteger:i]]) {
                [lastIndexs addObject:[NSNumber numberWithInteger:i]];
                [moreWidths addObject:[NSNumber numberWithFloat:0]];
            }
        }
    }

    NSInteger location = 0;  // 截取的位置
    NSInteger length = 0;    // 截取的长度
    CGFloat averageW = 0;    // 多出来的平均的宽度
    CGFloat tagW = 0;
    CGFloat tagH = _tagHeight;

    [_tagsFrames removeAllObjects];
    for (NSInteger i=0; i<lastIndexs.count; i++) {
        NSInteger lastIndex = [lastIndexs[i] integerValue];
        if (i == 0) {
            length = lastIndex + 1;
        }else{
            length = [lastIndexs[i] integerValue]-[lastIndexs[i-1] integerValue];
        }
        // 从数组中截取每一行的数组
        NSArray *newArr = [tagsArray subarrayWithRange:NSMakeRange(location, length)];
        location = lastIndex + 1;
        averageW = [moreWidths[i] floatValue]/newArr.count;
        CGFloat tagX = _tagsMargin;
        CGFloat tagY = _tagsLineSpacing + (_tagsLineSpacing + tagH) * i;

        for (NSInteger j=0; j<newArr.count; j++) {
            tagW = [self sizeWithText:newArr[j] font:TagsTitleFont].width + _tagsMinPadding * 2 + averageW;
            CGRect btnF = CGRectMake(tagX, tagY, tagW, tagH);
            [_tagsFrames addObject:NSStringFromCGRect(btnF)];
            tagX += (tagW+_tagsMargin);
        }
    }

    _tagsViewHeight = (tagH + _tagsLineSpacing) * lastIndexs.count + _tagsLineSpacing;
    
    [self initSubviews:tagsArray];
}

/**
 *  单行文本数据获取宽高
 *
 *  @param text 文本
 *  @param font 字体
 *
 *  @return 宽高
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text sizeWithAttributes:attrs];
}
@end
