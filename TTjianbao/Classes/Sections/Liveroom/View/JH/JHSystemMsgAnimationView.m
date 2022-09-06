//
//  JHSystemMsgAnimationView.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/21.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHSystemMsgAnimationView.h"
#import "NIMAvatarImageView.h"
#import "TTjianbaoHeader.h"

@interface JHSystemMsgAnimationView ()
{
    UILabel *nickNameLabel;
    UILabel *label;
    //    NIMAvatarImageView *avatar;
    UIImageView *icon;
    UIImageView *imageBackView;
    CGFloat iconWidth;
}
@property(nonatomic, strong)NSMutableArray *datalist;
@property(nonatomic)BOOL isShowing;
@end

@implementation JHSystemMsgAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"dfdfdfdfds4545");
        iconWidth = 20;
        self.datalist = [NSMutableArray array];
        imageBackView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *image = [UIImage imageNamed:@"bg_comin_yellow"];
        imageBackView.frame = CGRectMake(0, 0, image.size.width, self.height);
        imageBackView.image = image;
        //        imageBackView.layer.cornerRadius = self.bounds.size.height/2.;
        //        imageBackView.layer.masksToBounds = YES;
        //        imageBackView.backgroundColor = HEXCOLORA(0x000000, 0.5);
        
        [self addSubview:imageBackView];
        
        //        avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(2, 2, 31, 31)];
        //        [self addSubview:avatar];
        
        //        icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+5, 7, iconWidth, iconWidth)];
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, iconWidth, iconWidth)];
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = 10;
        [self addSubview:icon];
        
        
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(38+iconWidth+5, 0, 80, frame.size.height)];
        nickNameLabel.textColor = HEXCOLOR(0xffffff);
        nickNameLabel.shadowColor = HEXCOLOR(0x666666);
        nickNameLabel.shadowOffset = CGSizeMake(1, 1);
        
        nickNameLabel.font = [UIFont italicSystemFontOfSize:14];
        nickNameLabel.text = @"啦啦美妞啊啊啊啊";
        [self addSubview:nickNameLabel];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLabel.frame), 0, 80, frame.size.height)];
        label.textColor = HEXCOLOR(0xffffff);
        label.font = [UIFont italicSystemFontOfSize:14];
        label.text = @" 来啦！";
        
        label.shadowColor = HEXCOLOR(0x666666);
        label.shadowOffset = CGSizeMake(1, 1);
        
        [self addSubview:label];
        
        self.alpha = 0;
        
        
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
        nickNameLabel.text = model.nick;
        label.text = model.content;
        UIImage *image = [UIImage imageNamed:@"bg_comin_yellow"];
        
        if (model.showStyle >= 1) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_comin_%ld",(long)model.showStyle]];
        }
        
        imageBackView.frame = CGRectMake(0, 0, image.size.width, self.height);
        imageBackView.image = image;
        if (model.chartlet && model.chartlet.length>4) {
            iconWidth = 20;
            [icon jhSetImageWithURL:[NSURL URLWithString:model.avatar?:@""] placeholder:kDefaultAvatarImage];
        }else {
            iconWidth = 0;
            icon.image = nil;
        }
        
        CGRect frame = CGRectZero;
        if ([model.content isEqualToString:@"进入直播间"]) {
            
            
            nickNameLabel.text = [NSString stringWithFormat:@"欢迎 %@", model.nick?:@""];
            
        }else {
            nickNameLabel.text = @"";
        }
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont italicSystemFontOfSize:14.]};
        CGSize size = [nickNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,25) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
        nickNameLabel.frame = CGRectMake(10+iconWidth+5, 0, size.width, self.frame.size.height);
        
        size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT,25) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
        
        label.frame = CGRectMake(CGRectGetMaxX(nickNameLabel.frame)+5, 0, size.width, self.frame.size.height);
        frame = CGRectMake(0, self.mj_y, 5+nickNameLabel.mj_w+5+label.mj_w+5+iconWidth+5, self.mj_h);
        
        //
        //        imageBackView.frame = frame;
        //        imageBackView.mj_y = 0;
        NSLog(@"%@", NSStringFromCGRect(self.frame));
        MJWeakSelf
        self.alpha = 1;
        
        frame.origin.x = -frame.size.width;
        self.frame = frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.frame = frame;
        } completion:^(BOOL finished) {
            [weakSelf performSelector:@selector(animalCompletion) withObject:nil afterDelay:3];
        }];
    }else{
        _isShowing = NO;
    }
}

- (void)animalCompletion{
    [UIView animateWithDuration:0.25 animations:^{
        self.mj_x = -self.frame.size.width;
    } completion:^(BOOL finished) {
        
        if (self.datalist .count>0) {
            [self.datalist removeObjectAtIndex:0];
        }
        
        self.alpha = 0;
        [self nextComeinHorizon];
    }];
}


- (void)stopAndRemove {
    
    [self removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animalCompletion) object:nil];
}
-(void)cleanDataArr{
    
    self.datalist = [NSMutableArray array];
    
}
- (void)dealloc
{
    NSLog(@"JHSystemMsgAnimationView_dealloc");
}
@end

@interface JHComeinAnimationView ()
{
    UILabel *nickNameLabel;
    UIImageView *icon;
    UIImageView *fansicon;
    UIImageView *imageBackView;
    UIImageView *headerBack;
    UIImageView *starImage;
    UILabel *label;
    UIImageView *shanImage;



}
@property(nonatomic, strong)NSMutableArray *datalist;
@property(nonatomic)BOOL isShowing;
@end

@implementation JHComeinAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.datalist = [NSMutableArray array];
        imageBackView = [[UIImageView alloc] init];
        [self addSubview:imageBackView];

        
                
        headerBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_vip_tab"]];
        headerBack.contentMode = UIViewContentModeScaleAspectFit;
        [imageBackView addSubview:headerBack];
        
        
        icon = [[UIImageView alloc] init];
        icon.center = headerBack.center;
        [imageBackView addSubview:icon];
        
        fansicon = [[UIImageView alloc] init];
        [imageBackView addSubview:fansicon];
        
        nickNameLabel = [UILabel new];
        nickNameLabel.textColor = UIColor.whiteColor;
//        nickNameLabel.shadowColor = HEXCOLOR(0x666666);
//        nickNameLabel.shadowOffset = CGSizeMake(1, 1);
        
        nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nickNameLabel.text = @"啦啦美妞啊啊啊啊";
        [imageBackView addSubview:nickNameLabel];
        
        label = [UILabel new];
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label.text = @" 进入直播间！";
        
//        label.shadowColor = HEXCOLOR(0x666666);
//        label.shadowOffset = CGSizeMake(1, 1);
        [imageBackView addSubview:label];
        
        shanImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_vip_light"]];
        shanImage.alpha = 0;
//        [imageBackView addSubview:shanImage];
        
        starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_vip_star"]];
        starImage.contentMode = UIViewContentModeScaleAspectFit;
        [imageBackView addSubview:starImage];


        
        [imageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self.mas_trailing);
        }];
        
        [starImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageBackView).offset(0);
            make.leading.equalTo(label.mas_trailing).offset(10);
            make.trailing.equalTo(imageBackView).offset(20);
        }];
        
        [headerBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(imageBackView);
            make.height.equalTo(imageBackView);
            make.width.equalTo(@(62));
        }];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageBackView);
            make.left.mas_equalTo(headerBack.mas_right).offset(7);
            make.width.equalTo(@(47));
            make.height.equalTo(@(19));
        }];
        
        [fansicon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageBackView);
            make.left.mas_equalTo(icon.mas_right).offset(0);
            make.width.equalTo(@(0));
            make.height.equalTo(@(18));
        }];
        
        [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageBackView);
            make.leading.equalTo(fansicon.mas_trailing).offset(5);
            make.width.lessThanOrEqualTo(@(100));
//            make.height.equalTo(@(35));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageBackView);           make.leading.equalTo(nickNameLabel.mas_trailing);
//            make.trailing.equalTo(starImage.mas_leading);
        }];
        
                
        imageBackView.alpha = 0;
        
        [nickNameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityDefaultLow
                                  forAxis:UILayoutConstraintAxisHorizontal];
        
        shanImage.frame = CGRectMake(0, 0, 60, 35);

        
    }
    return self;
}

- (void)comeInActionWithModel:(JHSystemMsg *)model {
    [self.superview bringSubviewToFront:self];
    [self.datalist addObject:model];
    
    if (!_isShowing) {
        [self nextComeinHorizon];
    }
    
}

- (void)nextComeinHorizon
{
    
    if (_datalist.count > 0) {
        [starImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageBackView).offset(0);
            make.leading.equalTo(label.mas_trailing).offset(10);
            make.trailing.equalTo(imageBackView).offset(20);
        }];
        [headerBack mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(imageBackView);
            make.height.equalTo(imageBackView);
            make.width.equalTo(@(0));
        }];
        _isShowing = YES;
        JHSystemMsg *model = _datalist[0];
        NSInteger enterType = [model.enter_effect integerValue];
        if (enterType>0) {
            
            imageBackView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_enter_back_%zd",enterType]];
            starImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_enter_trail_%zd",enterType]];
            if (enterType == 5) {
                [starImage mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(imageBackView).offset(-22);
                    make.leading.equalTo(label.mas_trailing).offset(-80);
                    make.trailing.equalTo(imageBackView).offset(-10);
                }];
                [headerBack mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(imageBackView);
                    make.bottom.equalTo(imageBackView).offset(-8);
                    make.size.mas_equalTo(CGSizeMake(67, 84));
                }];
                headerBack.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_enter_lead_%zd",enterType]];
            }else{
                headerBack.image = [UIImage new];
            }
            if (enterType == 6) {
                [fansicon mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(imageBackView);
                    make.left.mas_equalTo(icon.mas_right).offset(6);
                    make.width.equalTo(@(49));
                    make.height.equalTo(@(18));
                }];
                [fansicon jhSetImageWithURL:[NSURL URLWithString:model.levelImg] placeholder:nil];
            }else{
                [fansicon mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(imageBackView);
                    make.left.mas_equalTo(icon.mas_right).offset(0);
                    make.width.equalTo(@(0));
                    make.height.equalTo(@(18));
                }];
            }

        }else {
            if (model.userTycoonLevel) {
                imageBackView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_enter_back_tuhao"]];
                headerBack.image = [UIImage new];
                starImage.image = [UIImage new];

            } else {
                return;
            }
        }
        
        
        nickNameLabel.text = model.nick;
        label.text = @" 进入直播间！";
        [icon jhSetImageWithURL:[NSURL URLWithString:model.chartlet] placeholder:nil];
        imageBackView.alpha = 0;
        [imageBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(ScreenW);
        }];
        
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [imageBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self).offset(20);
            }];
            imageBackView.alpha = 1;
            [self layoutIfNeeded];

        } completion:^(BOOL finished) {
//            [self lightAni:1];
            [UIView animateWithDuration:3 animations:^{
                [imageBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self);
                }];
                [self layoutIfNeeded];

            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    [imageBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self).offset(-ScreenW);
                    }];
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    imageBackView.alpha = 0;
                    [self animalCompletion];
                }];
            }];
        }];
        

    }else{
        _isShowing = NO;
    }
}

- (void)lightAni:(NSInteger)count {
    if (count<=0) {
        return;
    }
    [self layoutSubviews];
    CGRect frame = shanImage.frame;
    frame.origin.x = imageBackView.left;
    shanImage.frame = frame;
    frame.origin.x = label.right;
    shanImage.alpha = 1;

    [UIView animateWithDuration:3 animations:^{
        shanImage.frame = frame;
        shanImage.alpha = 0;

    }completion:^(BOOL finished) {

//        [UIView animateWithDuration:0.2 animations:^{
//            shanImage.alpha = 0;
//        } completion:^(BOOL finished) {
//            [self lightAni:count-1];
//        }];
        
    }];
}

- (void)animalCompletion{
    if (self.datalist .count>0) {
        [self.datalist removeObjectAtIndex:0];
    }
    [self nextComeinHorizon];
}


- (void)stopAndRemove {
    [self removeFromSuperview];
}
-(void)cleanDataArr{
    
    self.datalist = [NSMutableArray array];
    
}
- (void)dealloc
{
    NSLog(@"JHComeinAnimationView_dealloc");
}
@end
