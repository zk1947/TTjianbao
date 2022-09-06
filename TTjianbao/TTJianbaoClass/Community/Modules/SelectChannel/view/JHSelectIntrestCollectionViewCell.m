//
//  JHSelectIntrestCollectionViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSelectIntrestCollectionViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "JHDiscoverChannelModel.h"
#import "YYKit.h"

@interface JHSelectIntrestCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *intrestDesLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;

@end
@implementation JHSelectIntrestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectBtn.userInteractionEnabled = NO;
}

- (void)setModel:(JHDiscoverChannelModel *)intrestMode {
    //注意：：：带有中文的图片url会下载失败,所以需要编码下
    [self.intrestImage jhSetImageWithURL:[NSURL URLWithString:[intrestMode.image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholder:nil];
    self.intrestDesLab.text = intrestMode.channel_name;
    
    if (intrestMode.is_selected == 0) {
        self.selectBtn.selected = NO;
    }else if (intrestMode.is_selected == 1) {
        self.selectBtn.selected = YES;
    }
    
    NSLog(@"tag_image_url = %@", intrestMode.tag_image_url);
    if ([intrestMode.tag_image_url isNotBlank]) {
        [self.flagImgView jhSetImageWithURL:[NSURL URLWithString:intrestMode.tag_image_url]];
        self.flagImgView.hidden = NO;
        [self bringSubviewToFront:self.flagImgView];
        
    } else {
        self.flagImgView.hidden = YES;
    }
}

- (void)beginAnimation_Logo
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 0.6;
    group.repeatCount = 1;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:0.5 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:0.5 to:1.5 begintime:0.2];
    CABasicAnimation *animation3 = [self scaleAnimationFrom:1.5 to:1 begintime:0.4];
    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2,animation3, nil]];
    [self.selectBtn.layer addAnimation:group forKey:@"scale"];
}

-(CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
{
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"transform.scale"];
    _animation.duration = 0.2;
    _animation.beginTime = beginTime;
    _animation.removedOnCompletion = false;
    [_animation setFromValue:[NSNumber numberWithFloat:from]];
    [_animation setToValue:[NSNumber numberWithFloat:to]];
    return _animation;
    
}
@end
