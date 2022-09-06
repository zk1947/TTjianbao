//
//  JHLivePopView.m
//  test
//
//  Created by YJ on 2020/12/16.
//  Copyright © 2020 YJ. All rights reserved.
//

#import "JHLivePopView.h"
#import "TTJianBaoColor.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define POPVIEW_WIDHT  287
#define POPVIEW_HEIGHT 390
#define LEFT_PAD       15

#define TIMER 0.3

@interface JHLivePopView ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *popView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *liveLabel;
@property (strong, nonatomic) UILabel *recordLabel;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation JHLivePopView

- (instancetype)initWithLiveInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        NSString *liveTime = [NSString stringWithFormat:@"%@",info[@"liveTime"]];
        NSString *playbackTime = [NSString stringWithFormat:@"%@",info[@"playbackTime"]];
        NSString *description = [NSString stringWithFormat:@"%@",info[@"description"]];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3];
               
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        self.popView = [[UIView alloc] init];
        self.popView.layer.cornerRadius = 5.0f;
        self.popView.clipsToBounds = YES;
        self.popView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.popView];
        
        UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(POPVIEW_WIDHT - 50, 0, 50, 50)];
        [dismissBtn setImage:[UIImage imageNamed:@"image_close"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:dismissBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, POPVIEW_WIDHT, 22)];
        self.titleLabel.text = @"直播时间";
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.titleLabel.textColor = BLACK_COLOR;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.popView addSubview:self.titleLabel];
        
        self.liveLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PAD + 3, 20 + 22 + 12, POPVIEW_WIDHT - LEFT_PAD*2, 22)];
        //self.liveLabel.text = @"直播时间: 09:00 - 23:00";
        self.liveLabel.text = [NSString stringWithFormat:@"直播时间：%@",liveTime];
        self.liveLabel.textColor = BLACK_COLOR;
        self.liveLabel.font = [UIFont fontWithName:kFontNormal size:14.0f];
        self.liveLabel.textAlignment = NSTextAlignmentLeft;
        [self.popView addSubview:self.liveLabel];
        
        self.recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PAD + 3, self.liveLabel.origin.y + 22, POPVIEW_WIDHT - LEFT_PAD*2, 22)];
        //self.recordLabel.text = @"录播时间: 23:00 - 09:00";
        self.recordLabel.text = [NSString stringWithFormat:@"录播时间：%@",playbackTime];
        self.recordLabel.textColor = BLACK_COLOR;
        self.recordLabel.font = [UIFont fontWithName:kFontNormal size:14.0f];
        self.recordLabel.textAlignment = NSTextAlignmentLeft;
        [self.popView addSubview:self.recordLabel];
        
        //NSString *text = @"大家好，我是经营绿松石的松玉堂，生在绿松石产地竹山县的绿松世家，祖辈是靠家乡绿松石的开采和雕刻为生，绿松石之于我，有一种特殊的情感，可以说，绿松石养活了整个竹山县的人，也养活了我，长大后也就跟随父辈的脚步经营绿松石，并通过互联网的普及结识了来自五湖四海热爱绿松石的盘友！ 相信你一定听说过这样一句话“世界绿松石看中国，中国绿松石看湖北”，全世界70%的绿松石都来自湖北十堰！有机会来十堰的朋友可以加我微信，我会带你到下面几个著名的矿口和市场逛一逛！";
        
        NSString *text = description;
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_PAD, self.recordLabel.origin.y + 22 + 12 , POPVIEW_WIDHT - LEFT_PAD*2, POPVIEW_HEIGHT - 20 - 22 - 10 - 44 - 12 - 20)];
        self.textView.editable = NO;
        self.textView.backgroundColor  = [UIColor whiteColor];
        self.textView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
        self.textView.attributedText = [self setSpaceWithText:text font:[UIFont fontWithName:kFontNormal size:14.0f] color:GRAY_COLOR];
               
        [self.popView addSubview:self.textView];
        
    }
    return self;;
}

-(NSAttributedString *)setSpaceWithText:(NSString*)text font:(UIFont*)font color:(UIColor *)color
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;

    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.4f,NSForegroundColorAttributeName:color};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];

    return attributeStr;
}

- (void)show
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.popView.frame = CGRectMake((SCREEN_WIDTH - POPVIEW_WIDHT)/2, (SCREEN_HEIGHT - POPVIEW_HEIGHT)/2, POPVIEW_WIDHT, POPVIEW_HEIGHT);
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    self.popView.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:TIMER delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.popView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
    {
    
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:TIMER animations:^{
        self.popView.transform = CGAffineTransformScale(self.transform,0.1,0.1);
         self.alpha = 0;
     } completion:^(BOOL finished)
    {
         [self removeFromSuperview];
     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.popView])
    {
        return NO;
    }
    
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
