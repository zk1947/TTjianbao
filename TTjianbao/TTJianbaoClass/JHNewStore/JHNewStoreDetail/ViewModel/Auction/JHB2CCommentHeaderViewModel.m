//
//  JHB2CCommentHeaderViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CCommentHeaderViewModel.h"

@interface JHB2CCommentHeaderViewModel()

@end

@implementation JHB2CCommentHeaderViewModel

#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellType = CommentHeaderCell;
        //计算高度
        self.height = 110;
        self.tagArr = @[@"有图（999+）", @"做工优秀（20）", @"整体满意（59）", @"态度好（26）",@"有图（999+）", @"做工优秀（20）"];
        self.haoPing = @"100.00%";
        self.countOfComment = @"0";

    }
    return self;
}


- (NSAttributedString *)countAndHaoPingAttStr{
    if (self.haoPing.length && self.countOfComment.length) {
        NSString* baseStr = [NSString stringWithFormat:@"（%@条 | 好评度%@）",self.countOfComment, self.haoPing];
        UIFont *font = [UIFont fontWithName:kFontBoldDIN size:12];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:baseStr
                                                                                attributes:@{NSFontAttributeName : JHFont(12),NSForegroundColorAttributeName :HEXCOLOR(0x222222)}];
        [att setAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName :HEXCOLOR(0xFFA319)} range:[baseStr rangeOfString:self.haoPing]];
        return att.copy;
    }
    return nil;
}


- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
- (RACSubject *)moreBtnAction {
    if (!_moreBtnAction) {
        _moreBtnAction = [RACSubject subject];
    }
    return _moreBtnAction;
}
@end
