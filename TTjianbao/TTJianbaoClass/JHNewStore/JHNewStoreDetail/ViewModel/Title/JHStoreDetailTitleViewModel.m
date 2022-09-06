//
//  JHStoreDetailTitleViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailTitleViewModel.h"



@interface JHStoreDetailTitleViewModel()

@end
@implementation JHStoreDetailTitleViewModel
#pragma mark - Life Cycle Functions
- (instancetype)initWithText : (NSString *) text isOrphan : (BOOL)isOrphan{
    self = [super init];
    if (self) {
        [self setupData];
        [self setTitleWithText:text isOrphan : isOrphan];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = TitleCell;
}
- (void)setTitleWithText : (NSString *) text isOrphan : (BOOL)isOrphan {
    if (text == nil || text.length <= 0) { return; }
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                        NSForegroundColorAttributeName: kColor333, };
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:text];
    title.baselineOffset = @0;
    [title addAttributes:dic range:NSMakeRange(0, title.length)];
    
    if (isOrphan) {
        UIImage *image = [UIImage imageNamed:@"newStore_orphan_icon"];
        NSMutableAttributedString *muatt = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:[UIFont boldSystemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@" "];
        
        [title insertAttributedString:att atIndex:0];
        [title insertAttributedString:muatt atIndex:0];
    }
    
    title.lineSpacing = 4;

    self.titleText = title;
    
    CGFloat width = ScreenW -(LeftSpace * 2);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width, MAXFLOAT) text:title];

    self.height = layout.textBoundingSize.height + TitleTopSpace * 2;
}
#pragma mark - Action functions
#pragma mark - Lazy

@end
