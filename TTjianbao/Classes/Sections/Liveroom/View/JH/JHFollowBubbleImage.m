//
//  JHFollowBubbleImage.m
//  TTjianbao
//
//  Created by jiangchao on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFollowBubbleImage.h"
#import "NTESLiveroomInfoView.h"


@interface JHFollowBubbleImage ()
@property (nonatomic, strong) NTESLiveroomInfoView * infoView;
@end
@implementation JHFollowBubbleImage
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
    
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)addFollowBubbleByView:(UIView*)view{
    
    self.infoView = (NTESLiveroomInfoView*)view;
    UIImageView * _followBubbleImage = [[UIImageView alloc]init];
    _followBubbleImage.image = [UIImage imageNamed:@"liveroom_liketip_image"];
    [self addSubview:_followBubbleImage];
    [_followBubbleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(0);
        make.left.equalTo(view.mas_right).offset(-50);
    }];
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    //当前坐标
     CGRect rect = [self.infoView.careBtn convertRect:self.infoView.careBtn.bounds toView:self];
      CGPoint p = [tap locationInView:tap.view];
        NSLog(@"aaaaaa==%lf",p.x);
        NSLog(@"ddddd==%lf",p.y);
    
    if (p.x>=rect.origin.x&&
        p.y>=rect.origin.y&&
        p.x<=rect.origin.x+rect.size.width&&
        p.y<=rect.origin.y+rect.size.height
        
        ) {
        if (self.block) {
            self.block();
        }
        [self removeFromSuperview];
        
    }
    else{
        [self removeFromSuperview];
    }
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
