//
//  JHPresentView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/5.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHPresentView.h"
#import "NIMAvatarImageView.h"
#import "TTjianbaoHeader.h"

@interface JHPresentView ()
{
    UILabel *nickNameLabel;
    UILabel *label;
    NIMAvatarImageView *avatar;
    UIImageView *imageBackView;
    UIImageView *imageView;

}
@property(nonatomic, strong)NSMutableArray *datalist;
@property(nonatomic)BOOL isShowing;
@end

@implementation JHPresentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.datalist = [NSMutableArray array];
        imageBackView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageBackView.contentMode = UIViewContentModeLeft;
//        imageBackView.layer.cornerRadius = 22;
//        imageBackView.layer.masksToBounds = YES;
//        imageBackView.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
        imageBackView.image = [UIImage imageNamed:@"bg_gift_orange"];
        
        
        [self addSubview:imageBackView];
        
        avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(1, 4, 33, 33)];
        [self addSubview:avatar];
        
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(36+5, 2, 80, 18)];
        nickNameLabel.textColor = HEXCOLOR(0xC2FF9A);
        
        nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        nickNameLabel.text = @"啦啦美妞啊啊啊啊";
        [self addSubview:nickNameLabel];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(36+5, 20, 80, 18)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.text = @"送了";
        [self addSubview:label];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41-80, 80, 84)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        
    }
    return self;
}

- (void)comeInActionWithModel:(JHSystemMsg *)model {
    [self.datalist addObject:model];
    
    if (!_isShowing) {
        [self nextComeinHorizon];
    }
    
}




- (void)nextComeinHorizon
{
    if (_datalist.count > 0) {
        _isShowing = YES;
        JHSystemMsg *model = _datalist[0];
        nickNameLabel.text = model.sender[@"nick"];
        label.text = [NSString stringWithFormat:@"送了%@",model.giftInfo[@"giftName"]];
        
        [imageView jhSetImageWithURL:[NSURL URLWithString:model.giftInfo[@"giftImg"]] placeholder:kDefaultAvatarImage];
        
        [avatar nim_setImageWithURL:[NSURL URLWithString:model.sender[@"icon"]] placeholderImage:kDefaultAvatarImage];
        
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]};
        CGSize size = [nickNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,25) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
        
        nickNameLabel.mj_size = CGSizeMake(size.width, nickNameLabel.frame.size.height);

        
        size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT,25) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
        
        label.mj_size = CGSizeMake(size.width, label.frame.size.height);
        
        CGFloat ww = CGRectGetMaxX(label.frame)>CGRectGetMaxX(nickNameLabel.frame)?CGRectGetMaxX(label.frame):CGRectGetMaxX(nickNameLabel.frame);
        CGRect frame = CGRectMake(0, self.mj_y, ww+70, self.mj_h);
        
        imageView.mj_x = ww+10;
        
        imageBackView.frame = frame;

        imageBackView.mj_y = 0;
        NSLog(@"%@", NSStringFromCGRect(self.frame));
        MJWeakSelf
        self.alpha = 1;
        
        frame.origin.x = -frame.size.width;
        self.frame = frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.frame = frame;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.mj_x = -frame.size.width;
                } completion:^(BOOL finished) {
                    [weakSelf.datalist removeObjectAtIndex:0];
                    weakSelf.alpha = 0;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf nextComeinHorizon];
                    });
                }];
                
            });
        }];
    }else{
        _isShowing = NO;
    }
}



@end
