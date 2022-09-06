//
//  CommentTableViewCell.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/10.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "CommentTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"

@interface CommentTableViewCell ()
{
     UIImageView *circle;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel *content;
@property (strong, nonatomic)  UILabel* time;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic)   UIView * likeView;
@property (strong, nonatomic)   UIImageView * crowImageView;
@property (strong, nonatomic)   UIImageView * leveImageView;
@property (strong, nonatomic)   UIImageView * gameImageView;
@property (strong, nonatomic)   UIImageView * roleImageView;

@end

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoView = [[UIView alloc]init];
        _infoView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _headImage = [[UIImageView alloc]init];
        _headImage.image = kDefaultAvatarImage;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 19;
        _headImage.userInteractionEnabled = YES;
        [_infoView addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoView).offset(15);
            make.size.mas_equalTo(CGSizeMake(38, 38));
            make.left.offset(15);
        }];
        
        _name = [[UILabel alloc]init];
        _name.text = @"";
        _name.font = [UIFont systemFontOfSize:13];
        _name.textColor = [CommHelp toUIColorByStr:@"#a7a7a7"];
        _name.numberOfLines = 1;
        _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByWordWrapping;
        [_infoView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage).offset(-8);
            make.left.equalTo(_headImage.mas_right).offset(7);
        }];
        
        _crowImageView =[[UIImageView alloc]init];
        _crowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_infoView addSubview:_crowImageView];
        
        [_crowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_name);
            make.left.equalTo(_name.mas_right).offset(5);
             make.size.mas_equalTo(CGSizeMake(0, 19));
        }];
        
        _leveImageView=[[UIImageView alloc]init];
        _leveImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_leveImageView.backgroundColor=[UIColor redColor];
        [_infoView addSubview:_leveImageView];
        
        [_leveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_crowImageView);
            make.left.equalTo(_crowImageView.mas_right).offset(5);
             make.size.mas_equalTo(CGSizeMake(0, 19));
        }];
        
        _gameImageView=[[UIImageView alloc]init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_infoView addSubview:_gameImageView];
        
        [_gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_leveImageView);
            make.left.equalTo(_leveImageView.mas_right).offset(5);
             make.size.mas_equalTo(CGSizeMake(0, 19));
        }];
        
        _roleImageView=[[UIImageView alloc]init];
        _roleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_infoView addSubview:_roleImageView];
        
        [_roleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_leveImageView);
            make.left.equalTo(_gameImageView.mas_right).offset(5);
             make.size.mas_equalTo(CGSizeMake(0, 19));
        }];
        
        _content=[[UILabel alloc]init];
        _content.text=@"";
        _content.font=[UIFont systemFontOfSize:14];
        _content.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _content.numberOfLines = 0;
//         _content.backgroundColor=[UIColor redColor];
         _content.preferredMaxLayoutWidth = ScreenW-63;
        _content.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        [_infoView addSubview:_content];
        
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_headImage.mas_bottom).offset(0);
            make.left.equalTo(_name);
            make.right.equalTo(_infoView.mas_right).offset(-10);
            
        }];
        
        _time=[[UILabel alloc]init];
        _time.text=@"";
        _time.font=[UIFont systemFontOfSize:11];
//        _time.backgroundColor=[UIColor yellowColor];
        _time.textColor=[CommHelp toUIColorByStr:@"#666666"];
        _time.numberOfLines = 1;
        _time.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _time.lineBreakMode = NSLineBreakByWordWrapping;
        [_infoView addSubview:_time];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content.mas_bottom).offset(13);
            make.left.equalTo(_name);
            make.bottom.equalTo(_infoView).offset(-13);
        }];
        
        _likeView=[[UIView alloc]init];
        _likeView.userInteractionEnabled=YES;
        [_likeView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_likeView];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(Like)];
        [_likeView  addGestureRecognizer:tap];
        [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.centerY.equalTo(_name).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        _likeImageView=[[UIImageView alloc] init];
        //_likeImageView.backgroundColor=[UIColor redColor];
        _likeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_likeView addSubview:_likeImageView];
        [_likeImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_likeView).offset(0);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.left.equalTo(_likeView).offset(5);
        }];
        
        circle=[[UIImageView alloc]init];
        circle.image=[UIImage imageNamed:@"appraisal_circle3"];
        [_likeView addSubview:circle];
        [circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_likeImageView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        [circle setHidden:YES];
        
        _likeCountLabel=[[UILabel alloc]init];
        _likeCountLabel.font=[UIFont systemFontOfSize:12];
        _likeCountLabel.backgroundColor=[UIColor clearColor];
        _likeCountLabel.textColor=HEXCOLOR(0x666666);
        _likeCountLabel.numberOfLines = 1;
        _likeCountLabel.text=@"";
        // _likeCountLabel.backgroundColor=[UIColor greenColor];
        _likeCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _likeCountLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [_likeCountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_likeView addSubview:_likeCountLabel];
        
        [_likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_likeImageView.mas_right).offset(5);
            make.centerY.equalTo(_likeView).offset(0);
            make.right.equalTo(_likeView).offset(-5);
        }];
        
    }
    return self;
}
-(void)setAppraisalComment:(ApprailsalCommentMode *)appraisalComment{
   
    _appraisalComment=appraisalComment;
    [circle setHidden:YES];
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.img] placeholder:kDefaultAvatarImage];
    
    [_crowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 19));
        make.left.equalTo(_name.mas_right).offset(0);
    }];
    
    [_leveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 19));
        make.left.equalTo(_crowImageView.mas_right).offset(0);
    }];
    JH_WEAK(self)
    if ([_appraisalComment.userTycoonLevelIcon isNotBlank]) {
        
        [_crowImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.userTycoonLevelIcon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                float width=19*(float)image.size.width/image.size.height;
                [self.crowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, 19));
                    make.left.equalTo(self.name.mas_right).offset(5);
                }];
            }
        }];
    }

    if ([_appraisalComment.title_level_icon length]>0) {
        [_leveImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.title_level_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                float width=19*(float)image.size.width/image.size.height;
                [self.leveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, 19));
                    make.left.equalTo(self.crowImageView.mas_right).offset(5);
               }];
            }
        }];
    }
    [_gameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 19));
        make.left.equalTo(_leveImageView.mas_right).offset(0);
    }];
    if ([_appraisalComment.game_level_icon length]>0) {
        [_gameImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.game_level_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                float width=19*(float)image.size.width/image.size.height;
                [self.gameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, 19));
                    make.left.equalTo(self.leveImageView.mas_right).offset(5);
                }];
            }
        }];
    }
   
    [_roleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 19));
        make.left.equalTo(_gameImageView.mas_right).offset(0);
    }];
    
    if ([_appraisalComment.role_icon length]>0) {
        [_roleImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.role_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                float width=19*(float)image.size.width/image.size.height;
                [self.roleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, 19));
                    make.left.equalTo(self.gameImageView.mas_right).offset(5);
                }];
            }
        }];
    }
    
     _name.text=_appraisalComment.name;
     _content.text=_appraisalComment.remarks;
      [UILabel changeLineSpaceForLabel:_content WithSpace:5.0];
    _time.text=_appraisalComment.createDate;
    _likeCountLabel.text=[appraisalComment.laudTimes integerValue]!=0?[CommHelp changeAsset:appraisalComment.laudTimes]:@"赞";
    if (_appraisalComment.isLaud) {
          _likeImageView.image=[UIImage imageNamed:@"home_zan_select"];
    }
    else{
          _likeImageView.image=[UIImage imageNamed:@"home_zan_nomal"];
    }
    
//    [self beginAnimation];
}

-(void)setAppraisalReportComment:(ApprailsalCommentMode *)appraisalReportComment{
    
    _appraisalReportComment=appraisalReportComment;
    [circle setHidden:YES];
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_appraisalReportComment.img] placeholder:kDefaultAvatarImage];

    _name.text=_appraisalReportComment.name;
    _content.text=_appraisalReportComment.remarks;
    [UILabel changeLineSpaceForLabel:_content WithSpace:5.0];
    _time.text=_appraisalReportComment.createDate;
    _likeCountLabel.text=_appraisalReportComment.laudTimes ;
    [_likeCountLabel setHidden:YES];
    [_likeImageView setHidden:YES];
    //    [self beginAnimation];
    [_crowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 19));
        make.left.equalTo(_name.mas_right).offset(0);
    }];
     
    [_leveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 19));
        make.left.equalTo(_crowImageView.mas_right).offset(0);
    }];
    JH_WEAK(self)
    if (![_appraisalComment.userTycoonLevelIcon isNotBlank]) {
        ///测试代码
//        _crowImageView.image = [UIImage imageNamed:@"icon_my_crow"];
//        [_crowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(19, 19));
//            make.left.equalTo(_name.mas_right).offset(5);
//        }];
        [_crowImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.userTycoonLevelIcon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                float width=19*(float)image.size.width/image.size.height;
                [self.crowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, 19));
                    make.left.equalTo(self.name.mas_right).offset(5);
                }];
            }
        }];
    }

     if ([_appraisalComment.title_level_icon length]>0) {
         [_leveImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.title_level_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
             JH_STRONG(self)
             if (image) {
                 float width=19*(float)image.size.width/image.size.height;
                 [self.leveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.size.mas_equalTo(CGSizeMake(width, 19));
                     make.left.equalTo(self.crowImageView.mas_right).offset(5);
                 }];
             }
         }];
     }
     [_gameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(0, 19));
         make.left.equalTo(_leveImageView.mas_right).offset(0);
     }];
     if ([_appraisalComment.game_level_icon length]>0) {
         [_gameImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.game_level_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
             JH_STRONG(self)
             if (image) {
                 float width=19*(float)image.size.width/image.size.height;
                 [self.gameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.size.mas_equalTo(CGSizeMake(width, 19));
                     make.left.equalTo(self.leveImageView.mas_right).offset(5);
                 }];
             }
         }];
     }
    
     [_roleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(0, 19));
         make.left.equalTo(_gameImageView.mas_right).offset(0);
     }];
     if ([_appraisalComment.role_icon length]>0) {
         [_roleImageView jhSetImageWithURL:[NSURL URLWithString:_appraisalComment.role_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
             JH_STRONG(self)
             if (image) {
                 float width=19*(float)image.size.width/image.size.height;
                 [self.roleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.size.mas_equalTo(CGSizeMake(width, 19));
                     make.left.equalTo(self.gameImageView.mas_right).offset(5);
                 }];
             }
         }];
     }
}
- (float)getAutoCellHeight {
    
    [_infoView layoutIfNeeded];
    NSLog(@"ccc%lf",_infoView.frame.size.height);
    return _infoView.frame.size.height;
    
}
-(void)Like{
    
    BOOL isLaud=self.appraisalComment.isLaud;
    if (self.cellClick) {
        self.cellClick(isLaud,_cellIndex);
    }
}
- (void)beginAnimation:(ApprailsalCommentMode*)mode
{
    if (mode.isLaud) {
        self.likeImageView.image=[UIImage imageNamed:@"home_zan_select"];
        [circle setHidden:NO];
        [self beginAnimation_circle];
    }
    else{
        [circle setHidden:YES];
        self.likeImageView.image=[UIImage imageNamed:@"home_zan_nomal"];
    }
   // self.likeCountLabel.text= [CommHelp changeAsset:mode.laudTimes];
    self.likeCountLabel.text=[mode.laudTimes integerValue]!=0?[CommHelp changeAsset:mode.laudTimes]:@"赞";
    [self beginAnimation_Logo];
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
    [self.likeImageView.layer addAnimation:group forKey:@"scale"];
}
- (void)beginAnimation_circle
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 0.6;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.5 begintime:0];
    [group setAnimations:[NSArray arrayWithObjects:animation1,[self alphaAnimation], nil]];
    [circle.layer addAnimation:group forKey:@"scale"];
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
-(CABasicAnimation *)alphaAnimation{
    
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"opacity"];
    _animation.duration = 0.6;
    _animation.beginTime = 0;
    [_animation setFromValue:[NSNumber numberWithFloat:1]];
    [_animation setToValue:[NSNumber numberWithFloat:0]];
    return _animation;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
