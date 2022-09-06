//
//  JHRecycleOrderDetailCheckViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailCheckViewModel.h"

@implementation JHRecycleOrderDetailCheckViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
        [self bindData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions
- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo {
    [self.toolbarViewModel setupButtonListWithInfo:buttonInfo];
}

- (void)bindData {
    @weakify(self)
    [self.toolbarViewModel.clickEvent
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
         [self.clickEvent sendNext:x];
     }];
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderDetailCheckCell;
}

- (void)setupBusinessText {
    if (self.describeText == nil) return;
    NSDictionary *linkDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x408ffe),
                               NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    NSDictionary *titleDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x333333),
                                  NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    NSDictionary *businessDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                                  NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    
    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
                                          initWithString:@"商家说明: "
                                          attributes:titleDict];
    
    NSMutableAttributedString *businessText = [[NSMutableAttributedString alloc]
                                          initWithString:[self.describeText stringByAppendingString:@" "]
                                          attributes:businessDict];
    

    NSMutableAttributedString *linkAtt = [[NSMutableAttributedString alloc]
                                   initWithString:@" 查看商家说明"
                                   attributes: linkDict] ;

    YYAnimatedImageView *imageView1= [[YYAnimatedImageView alloc]
                                      initWithImage:[UIImage imageNamed:@"recycle_orderDetail_business_play_icon"]];
    imageView1.frame = CGRectMake(0, -2, 12, 12);

    YYAnimatedImageView *imageView2= [[YYAnimatedImageView alloc]
                                      initWithImage:[UIImage imageNamed:@"recycle_orderDetail_business_detail_icon"]];
    imageView2.frame = CGRectMake(0, -2, 12, 12);
    // attchmentSize 修改，可以处理内边距
    NSMutableAttributedString *attachText1= [NSMutableAttributedString attachmentStringWithContent:imageView1 contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView1.frame.size alignToFont:linkAtt.font alignment:YYTextVerticalAlignmentCenter];

    NSMutableAttributedString *attachText2= [NSMutableAttributedString attachmentStringWithContent:imageView2 contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView2.frame.size alignToFont:linkAtt.font alignment:YYTextVerticalAlignmentCenter];
    
    
    [linkAtt insertAttributedString:attachText1 atIndex:0];
    [linkAtt appendAttributedString:attachText2];
    
    [title appendAttributedString:businessText];

    CGFloat singlHeight = [self getAttTextHeightWithAtt:linkAtt];
    CGFloat attHeight = [self getAttTextHeightWithAtt:title];
    NSInteger rowNum = attHeight / singlHeight;

    NSMutableAttributedString *copyAtt = [title mutableCopy];
    [copyAtt appendAttributedString:linkAtt];
    CGFloat height = [self getAttTextHeightWithAtt:copyAtt];
    // 折行
    if (attHeight == height || rowNum == RecycleOrderDescribeNumberOfLines) {
        [title appendAttributedString:linkAtt];
    }else {
        NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"\n"];
        [title appendAttributedString: xx];
        [title appendAttributedString:linkAtt];
    }
    self.attDescribeText = title;
    [self setupAttTextHeight];
}
- (void)setupAttTextHeight {
    CGFloat height = [self getAttTextHeightWithAtt:self.attDescribeText];
    self.height = height + RecycleOrderNomalTopSpace + RecycleOrderNomalBottomSpace + RecycleOrderCheckToolbarTopSpace + RecycleOrderArbitrationToolbarHeight;
}
- (CGFloat)getAttTextHeightWithAtt : (NSAttributedString *)text {
    CGFloat width = ScreenW - LeftSpace * 2 - ContentLeftSpace * 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width, MAXFLOAT) text: text];
    return layout.textBoundingSize.height;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setDescribeText:(NSString *)describeText {
    _describeText = describeText;
    [self setupBusinessText];
}
- (JHRecycleOrderToolbarViewModel *)toolbarViewModel {
    if (!_toolbarViewModel) {
        _toolbarViewModel = [[JHRecycleOrderToolbarViewModel alloc] init];
    }
    return _toolbarViewModel;
}
@end
