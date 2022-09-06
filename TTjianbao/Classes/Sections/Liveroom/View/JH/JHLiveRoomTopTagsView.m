//
//  JHLiveRoomTopTagsView.m
//  TTjianbao
//
//  Created by liuhai on 2021/4/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomTopTagsView.h"

#define button_MARGIN 10.0f
#define BOTTOM_MARGIN 8.0f

@interface JHLiveRoomTopTagsView ()

@property (nonatomic, strong) NSMutableArray *textArray;
@end

@implementation JHLiveRoomTopTagsView

- (void)dealloc{
}
- (instancetype)initWithArr:(NSMutableArray*)arr{
    self = [super init];
    if (self) {
        [self display];
    }
    return self;
}

- (void)setTags:(NSMutableArray *)array
{
    self.textArray = [[NSMutableArray alloc] init];
    for (id temp in array) {
        if ([temp isKindOfClass:[UIView class]]) {
            [self.textArray addObject:temp];
        }
    }
    sizeFit = CGSizeZero;
    [self display];
}



- (void)display
{
    self.backgroundColor = [UIColor clearColor];
    [self removeAllSubviews];
    self.height = 0;
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    

    for (int i = 0; i < self.textArray.count; i ++) {

       
        
        UIView *button = (UIView *)self.textArray[i];
        
        if (!gotPreviousFrame) {
            button.frame = CGRectMake(15, 8, button.width, button.height);
            totalHeight += 8 + button.height + BOTTOM_MARGIN;
        } else {

            if (previousFrame.origin.x + previousFrame.size.width + button.width + button_MARGIN > kScreenWidth-30) {
                
                button.frame = CGRectMake(15, previousFrame.origin.y + button.height + BOTTOM_MARGIN, button.width, button.height);
                totalHeight += button.height + BOTTOM_MARGIN;
            } else {
                
                button.frame = CGRectMake(previousFrame.origin.x + previousFrame.size.width + button_MARGIN, previousFrame.origin.y , button.width, button.height);
            }
        }
        previousFrame = button.frame;
        gotPreviousFrame = YES;
        [self addSubview:button];
        
    }
   
    sizeFit = CGSizeMake(kScreenWidth, totalHeight + 5.0f);
    self.height = totalHeight + 5.0f;
    

}
-(void)expandbuttonAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(expandBtnAction)]) {
        [_delegate expandBtnAction];
    }
}
- (CGSize)fittedSize
{
    return sizeFit;
}
- (CGSize)sizeWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
}
- (void)clickCellButton:(UIButton*)sender{
    
}

-(void)lpGR:(UILongPressGestureRecognizer *)lpGR

{

    
    
}
- (void)closeAction:(UIButton *)sender{

}

@end
