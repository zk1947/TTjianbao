//
//  CommentTableViewCell.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/10.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHAudienceCommentTableViewCell.h"
#import "LXTagsView.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "UIButton+ImageTitleSpacing.h"
#import "NSString+AttributedString.h"

@interface JHAudienceCommentTableViewCell ()
{
    UIImageView *circle;
    UIView * starView;
    UIView * line;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *goodCommentImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel *desc;
@property (strong, nonatomic)  UILabel* time;
@property (strong, nonatomic)  UILabel* orderCode;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic)   UIView * likeView;
@property (nonatomic ,strong)LXTagsView *tagsView;
@property (nonatomic ,strong)UIScrollView *imagesScrollView;
@property (nonatomic ,strong)UIButton *detailBtn;
@property (nonatomic ,strong)UIButton *likeBtn;
@property (nonatomic ,strong)UIButton *replyBtn;
@property (strong, nonatomic)  UILabel* replyLabel;
@property (strong, nonatomic)  UIView* replyView;
@property (strong, nonatomic)  NSMutableArray <UIButton*>* starArr;
@end

@implementation JHAudienceCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoView = [[UIView alloc]init];
        _infoView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.contentMode=UIViewContentModeScaleAspectFill;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =17;
        _headImage.userInteractionEnabled=YES;
        [_infoView addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoView).offset(15);
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.left.offset(10);
        }];
        
        _goodCommentImage=[[UIImageView alloc]init];
        _goodCommentImage.image=[UIImage imageNamed:@"comment_good_appraise"];
        _goodCommentImage.contentMode=UIViewContentModeScaleAspectFit;
        [_infoView addSubview:_goodCommentImage];
        [_goodCommentImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoView).offset(15);
            //  make.size.mas_equalTo(CGSizeMake(34, 34));
            make.right.offset(-10);
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont systemFontOfSize:13];
        _name.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _name.numberOfLines = 1;
        _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByWordWrapping;
        [_infoView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage).offset(-8);
            make.left.equalTo(_headImage.mas_right).offset(7);
        }];
        
        
        starView=[[UIView alloc]init];
        //  starView.backgroundColor=[UIColor yellowColor];
        [_infoView addSubview:starView];
        
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_name.mas_bottom).offset(5);
            make.left.equalTo(_headImage.mas_right).offset(7);
        }];
        
        self.starArr=[NSMutableArray array];
        UIButton * lastButton ;
        NSInteger count =5;
        for (int i=0; i<count; i++) {
            UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.tag=i;
            [button setImage:[UIImage imageNamed:@"comment_star"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"comment_star_kong"] forState:UIControlStateNormal];
            [starView addSubview:button];
            [self.starArr addObject:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(starView);
                make.size.mas_equalTo(CGSizeMake(10, 10));
                make.bottom.equalTo(starView);
                if (i==0) {
                    make.left.equalTo(starView).offset(0);
                }
                else{
                    make.left.equalTo(lastButton.mas_right).offset(3);
                }
                if (i==count-1) {
                    make.right.equalTo(starView);
                }
            }];
            
            lastButton=button;
        }
        
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
            make.centerY.equalTo(_name).offset(0);
            make.right.equalTo(_infoView.mas_right).offset(-10);
            
        }];
        
        self.tagsView =[[LXTagsView alloc]init];
        //  self.tagsView.backgroundColor=[UIColor yellowColor];
        [_infoView addSubview:self.tagsView];
        
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_infoView);
            make.top.equalTo(_headImage.mas_bottom).offset(8);
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.font=[UIFont systemFontOfSize:14];
        _desc.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _desc.numberOfLines = 0;
        // _desc.backgroundColor=[UIColor redColor];
        _desc.preferredMaxLayoutWidth = ScreenW-20;
        _desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        [_infoView addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.tagsView.mas_bottom).offset(10);
            make.left.equalTo(_headImage);
            make.right.equalTo(_infoView.mas_right).offset(-10);
            
        }];
        
        _imagesScrollView=[[UIScrollView alloc]init];
        _imagesScrollView.showsHorizontalScrollIndicator = NO;
        _imagesScrollView.showsVerticalScrollIndicator = NO;
        // _imagesScrollView.backgroundColor = [UIColor redColor];
        _imagesScrollView.scrollEnabled=YES;
        // _appraisalAnchorView.userInteractionEnabled = NO;
        _imagesScrollView.alwaysBounceHorizontal = YES; // 水平
        _imagesScrollView.alwaysBounceVertical = NO;
        // [self addGestureRecognizer:_appraisalAnchorView.panGestureRecognizer];
        // self.contentScroll.delegate = self;
        [_infoView addSubview:_imagesScrollView];
        [_imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_infoView);
            make.height.offset((ScreenW-25)/4);
            make.top.equalTo(_desc.mas_bottom).offset(10);
            make.right.equalTo(_infoView);
            
        }];
        
        _productImage=[[UIImageView alloc]init];
        _productImage.contentMode=UIViewContentModeScaleAspectFill;
        _productImage.layer.masksToBounds =YES;
        [_infoView addSubview:_productImage];
        
        [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo(_imagesScrollView.mas_bottom).offset(10);
            make.top.equalTo(_desc.mas_bottom).offset((ScreenW-25)/4+10+10);
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.left.offset(10);
            
        }];
        
        _orderCode=[[UILabel alloc]init];
        _orderCode.text=@"";
        _orderCode.font=[UIFont systemFontOfSize:12];
        _orderCode.textColor=[CommHelp toUIColorByStr:@"#666666"];
        _orderCode.numberOfLines = 1;
        _orderCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderCode.lineBreakMode = NSLineBreakByTruncatingTail;
        [_infoView addSubview:_orderCode];
        
        _likeBtn = [[UIButton alloc] init];
        _likeBtn.backgroundColor = [UIColor clearColor];
        _likeBtn.contentMode=UIViewContentModeScaleToFill;
        _likeBtn.tag=2;
        [_likeBtn setTitleColor:[CommHelp toUIColorByStr:@"#666666"]  forState:UIControlStateNormal];
        _likeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [_likeBtn setBackgroundImage:[[UIImage imageNamed:@"commen_detail_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,8, 0,8) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_likeBtn setBackgroundImage:[[UIImage imageNamed:@"commen_zan_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,8, 0,8) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
        [_likeBtn setImage:[UIImage imageNamed:@"comment_zan.png"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"comment_zan_select.png"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat space =5;
        [_likeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                  imageTitleSpace:space];
        [_infoView addSubview:_likeBtn];
        
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_productImage);
            make.width.offset(63);
            make.right.equalTo(_infoView.mas_right).offset(-10);
        }];
        
        _detailBtn = [[UIButton alloc] init];
        _detailBtn.backgroundColor = [UIColor clearColor];
        _detailBtn.contentMode=UIViewContentModeScaleToFill;
        _detailBtn.tag=1;
        [_detailBtn setTitle:@"鉴定详情" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[CommHelp toUIColorByStr:@"#666666"]  forState:UIControlStateNormal];
        _detailBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [_detailBtn setBackgroundImage:[[UIImage imageNamed:@"commen_detail_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,8, 0,8) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_detailBtn setImage:[UIImage imageNamed:@"comment_detail.png"] forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_detailBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                    imageTitleSpace:space];
        [_infoView addSubview:_detailBtn];
        
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_productImage);
            make.width.offset(90);
            make.right.equalTo(_likeBtn.mas_left).offset(-5);
        }];
        
        _replyBtn = [[UIButton alloc] init];
        _replyBtn.tag=3;
        [_replyBtn setBackgroundImage:[UIImage imageNamed:@"icon_shop_comment_select"]forState:UIControlStateNormal];
        [_replyBtn setBackgroundImage:[UIImage imageNamed:@"icon_shop_comment_nomal"]forState:UIControlStateSelected];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitle:@"已回复" forState:UIControlStateSelected];
        [_replyBtn setTitleColor:[CommHelp toUIColorByStr:@"#666666"]  forState:UIControlStateNormal];
        _replyBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [_replyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_infoView addSubview:_replyBtn];
        
        [_replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_productImage);
            //            make.width.offset(60);
            //             make.height.offset(24);
            make.right.equalTo(_infoView.mas_right).offset(-10);
        }];
        
        [_replyBtn setHidden:YES];
        
        [_orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_productImage);
            make.left.equalTo(_productImage.mas_right).offset(5);
            make.right.equalTo(_detailBtn.mas_left).offset(-5);
        }];
        
        line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [_infoView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_infoView).offset(10);
            make.right.equalTo(_infoView).offset(-10);
            make.height.offset(1);
            make.top.equalTo(_productImage.mas_bottom).offset(10);
            
        }];
        
        //        _replyLabel=[[UILabel alloc]init];
        //        _replyLabel.font=[UIFont systemFontOfSize:12];
        //        _replyLabel.textColor=[CommHelp toUIColorByStr:@"#777777"];
        //        _replyLabel.numberOfLines = 0;
        //        _replyLabel.preferredMaxLayoutWidth = ScreenW-20;
        //        _replyLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        //        _replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //        [_infoView addSubview:_replyLabel];
        //
        //        [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.top.equalTo(_productImage.mas_bottom).offset(20);
        //            make.left.equalTo(_infoView).offset(10);
        //            make.right.equalTo(_infoView.mas_right).offset(-10);
        //            make.bottom.equalTo(_infoView).offset(-10);
        //        }];
        
        _replyView=[[UIView alloc]init];
        [_infoView addSubview:_replyView];
        
        [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_productImage.mas_bottom).offset(20);
            make.left.equalTo(_infoView).offset(10);
            make.right.equalTo(_infoView.mas_right).offset(-10);
            make.bottom.equalTo(_infoView).offset(-10);
        }];
        
    }
    return self;
}
-(void)setAudienceCommentMode:(JHAudienceCommentMode *)audienceCommentMode{
    
    _audienceCommentMode=audienceCommentMode;
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_audienceCommentMode.customerImg] placeholder:kDefaultAvatarImage];
    _name.text=_audienceCommentMode.customerName;
    _time.text=_audienceCommentMode.createTime;
    self.replyBtn.selected=_audienceCommentMode.isReply;
    
    [_productImage jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(_audienceCommentMode.orderImg)] placeholder:nil];
    _orderCode.text=[NSString stringWithFormat:@"订单号:%@",_audienceCommentMode.orderCode];
    _desc.text=_audienceCommentMode.commentContent;
    
    [self.tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_audienceCommentMode.haveReport) {
        [_detailBtn setHidden:NO];
    }
    else{
        [_detailBtn setHidden:YES];
    }
    
    if (_audienceCommentMode.pass>self.starArr.count) {
        _audienceCommentMode.pass=self.starArr.count;
    }
    
    for (int i=0; i<self.starArr.count; i++) {
        UIButton * button=self.starArr[i];
        button.selected=NO;
        if (i<_audienceCommentMode.pass) {
            button.selected=YES;
        }
    }
    
    if (_audienceCommentMode.commentTagsList.count>0) {
        NSMutableArray * tagArr=[NSMutableArray array];
        for (CommentTagMode * mode in _audienceCommentMode.commentTagsList) {
            [tagArr addObject:mode.tagName];
        }
        [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImage.mas_bottom).offset(8);
        }];
        
        self.tagsView.dataA = tagArr;
    }
    else{
        [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImage.mas_bottom).offset(0);
        }];
    }
    
    if (_audienceCommentMode.commentImgsList.count>0) {
        
        //        [_imagesScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        //          //  make.height.offset((ScreenW-25)/4);
        //            make.top.equalTo(_desc.mas_bottom).offset(10);
        //        }];
        [_productImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset((ScreenW-25)/4+10+10);
        }];
        [_imagesScrollView setHidden:NO];
        [self initImages:_audienceCommentMode.commentImgsList];
    }
    else{
        [_imagesScrollView setHidden:YES];
        [_productImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(10);
        }];
        //        [_imagesScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        //           // make.height.offset(0);
        //            make.top.equalTo(_desc.mas_bottom).offset(0);
        //        }];
    }
    //    if (_audienceCommentMode.serviceReply) {
    //        NSString * title=[NSString stringWithFormat:@"客服回复:%@",_audienceCommentMode.serviceReply];
    //        [_replyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(_productImage.mas_bottom).offset(20);
    //        }];
    //        [line setHidden:NO];
    //        NSRange range = [title rangeOfString:@"客服回复:"];
    //        _replyLabel.attributedText=[title attributedFont:[UIFont boldSystemFontOfSize:13] color:[CommHelp toUIColorByStr:@"#777777"] range:range];
    //    }
    //    else{
    //
    //        _replyLabel.attributedText=nil;
    //        [_replyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(_productImage.mas_bottom).offset(0);
    //        }];
    //        [line setHidden:YES];
    //    }
    
    [self.replyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_audienceCommentMode.orderServiceComments.count>0 ) {
        
        [line setHidden:NO];
        [_replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productImage.mas_bottom).offset(20);
        }];
        [self initReplays];
    }
    else{
        [_replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productImage.mas_bottom).offset(0);
        }];
        [line setHidden:YES];
    }
    NSString * count=[_audienceCommentMode.laudTimes intValue]==0?@"赞":[CommHelp changeAsset:_audienceCommentMode.laudTimes];
    [_likeBtn setTitle:count forState:UIControlStateNormal];
    
    if (_audienceCommentMode.isLaud) {
        [_likeBtn setSelected:YES];
    }
    else{
        [_likeBtn setSelected:NO];
    }
    
    if (_audienceCommentMode.good) {
        
        [_goodCommentImage setHidden:NO];
    }
    else{
        [_goodCommentImage setHidden:YES];
    }
}

-(void)reloadCell:(JHAudienceCommentMode*)mode{
    NSString * count=[_audienceCommentMode.laudTimes intValue]==0?@"赞":[CommHelp changeAsset:_audienceCommentMode.laudTimes];
    [_likeBtn setTitle:count forState:UIControlStateNormal];
    if (_audienceCommentMode.isLaud) {
        [_likeBtn setSelected:YES];
    }
    else{
        [_likeBtn setSelected:NO];
    }
    
}
-(void)initReplays{
    
    UILabel * lastLabel;
    for (int i=0;i< self.audienceCommentMode.orderServiceComments.count  ;i++) {
        CommentReplyMode * mode  = self.audienceCommentMode.orderServiceComments[i];
        UILabel*   reply=[[UILabel alloc]init];
        reply.font=[UIFont systemFontOfSize:12];
        reply.textColor=[CommHelp toUIColorByStr:@"#777777"];
        reply.numberOfLines = 0;
        reply.preferredMaxLayoutWidth = ScreenW-20;
        reply.textAlignment = UIControlContentHorizontalAlignmentCenter;
        reply.lineBreakMode = NSLineBreakByWordWrapping;
        [_replyView addSubview:reply];
        if (mode.type==0) {
            NSString * title=[NSString stringWithFormat:@"客服回复:%@",mode.comment];
            NSRange range = [title rangeOfString:@"客服回复:"];
            reply.attributedText=[title attributedFont:[UIFont boldSystemFontOfSize:13] color:[CommHelp toUIColorByStr:@"#777777"] range:range];
        }
        else   if (mode.type==1) {
            NSString * title=[NSString stringWithFormat:@"主播回复:%@",mode.comment];
            NSRange range = [title rangeOfString:@"主播回复:"];
            reply.attributedText=[title attributedFont:[UIFont boldSystemFontOfSize:13] color:[CommHelp toUIColorByStr:@"#777777"] range:range];
        }
        
        [reply mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.top.equalTo(_replyView).offset(0);
            }
            else{
                make.top.equalTo(lastLabel.mas_bottom).offset(5);
            }
            make.left.equalTo(_replyView).offset(0);
            make.right.equalTo(_replyView.mas_right).offset(0);
            
            
            if (i==self.audienceCommentMode.orderServiceComments.count-1 ) {
                make.bottom.equalTo(_replyView).offset(0);
            }
        }];
        
        lastLabel=reply;
    }
}
-(void)initImages:(NSArray*)images{
    
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
        // view.backgroundColor=[CommHelp randomColor];
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds =YES;
        [view jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(images[i])] placeholder:nil];
        [_imagesScrollView addSubview:view];
        view.tag=i;
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [view addGestureRecognizer:tapGesture];
        float width=( ScreenW-25)/4;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.height.offset(width);
            make.top.equalTo(_imagesScrollView);
            if (i==0) {
                make.left.equalTo(_imagesScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            if (i==images.count-1) {
                make.right.equalTo(_imagesScrollView.mas_right).offset(-10);
            }
        }];
        lastView=view;
    }
}

-(void)btnClick:(UIButton*)button{
    
    BOOL isLaud=self.audienceCommentMode.isLaud;
    if (self.cellClick) {
        self.cellClick(button,isLaud,_cellIndex);
    }
}
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:self.audienceCommentMode.commentImgsList];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:imageview.tag result:^(NSInteger index) {
        
    }];
    [EnlargedImage sharedInstance].audienceCommentMode=self.audienceCommentMode;
}

-(void)setIsCanReply:(BOOL)isCanReply{
    
    _isCanReply=isCanReply;
    if (_isCanReply) {
        self.replyBtn.hidden=NO;
        self.likeBtn.hidden=YES;
    }
    else{
        self.replyBtn.hidden=YES;
        self.likeBtn.hidden=NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


