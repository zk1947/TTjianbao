//
//  JHRecycleOrderBusinessDesViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessDesViewModel.h"

@implementation JHRecycleOrderBusinessDesViewModel

#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderBusinessCellTypeDes;
}
- (void)setupAttText {
    NSDictionary *titleDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x333333),
                               NSFontAttributeName : [UIFont fontWithName:kFontNormal size:13]};
    NSDictionary *detailDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                                 NSFontAttributeName : [UIFont fontWithName:kFontNormal size:13]};
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
                                          initWithString:@"商家理由说明: "
                                          attributes: titleDict];
    NSAttributedString *detail = [[NSAttributedString alloc]
                                     initWithString:self.desText
                                     attributes:detailDict];
    
    [title appendAttributedString:detail];
    
    self.attDesText = title;
    [self setupAttTextHeight];
}
- (void)setupAttTextHeight {
    CGFloat height = [self getAttTextHeightWithAtt:self.attDesText];
    self.height = height;
    
}
- (CGFloat)getAttTextHeightWithAtt : (NSAttributedString *)text {
    CGFloat width = ScreenW - ContentLeftSpace * 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width, MAXFLOAT) text: text];
    return layout.textBoundingSize.height;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setDesText:(NSString *)desText {
    _desText = desText;
    [self setupAttText];
}
@end
