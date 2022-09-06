//
//  JHSeckillTableViewCell.m
//  TTjianbao
//
//  Created by jiang on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSeckillTableViewCell.h"
#import "JHUIFactory.h"
#import "NSString+AttributedString.h"
@interface JHSeckillTableViewCell ()
{
    JHCustomLine *line;
}
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UILabel *desc;
@property (strong, nonatomic)  UILabel *progressLabel;
@property (strong, nonatomic)  UIProgressView *processView;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *tagLabel;
@property (strong, nonatomic)  UIView *tagView;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UIImageView *statusImageView;
@property (nonatomic, strong)  UIImageView *videoIcon; //是否有视频标识
@property (strong, nonatomic)  UIButton  * button;
@end

@implementation JHSeckillTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _coverImage=[[UIImageView alloc]init];
        _coverImage.image=kDefaultCoverImage;
       // _coverImage.userInteractionEnabled=YES;
        _coverImage.backgroundColor=[UIColor clearColor];
       // _coverImage.layer.cornerRadius = 4;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_coverImage];
        
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.bottom.offset(-10);
            make.left.offset(15);
            make.size.mas_equalTo(CGSizeMake(135, 135));
            
        }];
        
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_has_video"]];
        [_coverImage addSubview:_videoIcon];
        [_videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.right.offset(-5);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"新疆和田玉一级手镯级手镯";
        _title.font=[UIFont fontWithName:kFontMedium size:15];
        _title.textColor=HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage);
            make.left.equalTo(_coverImage.mas_right).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.text=@"新疆和田籽玉，白皮，玉质凝聚光洁缜密，手感油腻，极好的商品";
        _desc.font=[UIFont fontWithName:kFontNormal size:13];
        _desc.textColor=HEXCOLOR(0x666666);
        _desc.numberOfLines = 2;
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(5);
            make.left.equalTo(_coverImage.mas_right).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
        }];
        
        
        _price = [[UILabel alloc]init];
        _price.text = @"";
        _price.font = [UIFont fontWithName:kFontBoldDIN size:20.f];
        _price.textColor = kColorMainRed;
        _price.numberOfLines = 1;
        _price.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        _price.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_title).offset(0);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = kColorMainRed;
        _tagView.layer.cornerRadius = 2;
        [self.contentView addSubview:_tagView];
        
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.centerY.equalTo(_price);
            make.left.equalTo(_price.mas_right).offset(5);
        }];
        
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.text = @"限时购";
        _tagLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _tagLabel.textColor = [CommHelp toUIColorByStr:@"#ffffff"];
        _tagLabel.numberOfLines = 1;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_tagView addSubview:_tagLabel];
        
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tagView);
            make.right.equalTo(_tagView.mas_right).offset(-5);
            make.left.equalTo(_tagView.mas_left).offset(5);
        }];
        
        _button = [[UIButton alloc]init];
        _button.contentMode = UIViewContentModeScaleAspectFit;
        [_button setTitle:@"马上抢" forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont fontWithName:kFontNormal size:12];
        [_button setTitleColor:kColor333 forState:UIControlStateNormal];
        _button.backgroundColor=kColorMain;
        _button.layer.cornerRadius = 15;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        [ _button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(_price);
            make.size.mas_equalTo(CGSizeMake(96, 30));
        }];
        
        _progressLabel = [[UILabel alloc]init];
        _progressLabel.text = @"已抢78%";
        _progressLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _progressLabel.textColor = HEXCOLOR(0x666666);
        _progressLabel.numberOfLines = 1;
        _progressLabel.textAlignment = NSTextAlignmentLeft;
        _progressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_progressLabel];
        
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_price.mas_top).offset(-10);
            make.left.equalTo(_coverImage.mas_right).offset(5);
        }];
        
        _processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _processView.trackTintColor = [UIColor whiteColor];
        _processView.progressTintColor = kColorMainRed;
        _processView.progress = 0.5;
        [self.contentView addSubview:_processView];
        
        _processView.layer.borderColor = kColorMainRed.CGColor;
        _processView.layer.borderWidth = 1;
        _processView.layer.cornerRadius = 2.5;
        _processView.layer.masksToBounds = YES;
        [_processView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_progressLabel);
            make.left.equalTo(_progressLabel.mas_right).offset(5);
            make.height.offset(5);
            make.width.offset(60);
        }];
        
        
        //  goods_collect_list_icon_goods_off_shelf 这个是已下架的图标
        
//        _statusImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_collect_list_icon_goods_sell_out"]];
//        _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.coverImage addSubview:_statusImageView];
//
//        [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.coverImage);
//        }];
        
        line = [JHUIFactory createLine];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-1);
            make.height.equalTo(@1);
            make.left.offset(15);
            make.right.offset(0);
            
        }];
        
        
    }
    return self;
}
-(void)setGoodMode:(JHGoodsInfoMode *)goodMode{
    
    _goodMode = goodMode;
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:_goodMode.coverImage.url] placeholder:[UIImage imageNamed:@"cover_default_list"]];
    
    _videoIcon.hidden = !goodMode.has_video;
    
    _title.text = _goodMode.name;
    _desc.text=_goodMode.desc;
    _progressLabel.text= _goodMode.pro_rate_tip;
    _processView.progress = _goodMode.sold_rate/100;
    
    NSString * string=[@"¥ " stringByAppendingString:_goodMode.market_price?:@""];
    NSRange range = [string rangeOfString:@"¥"];
    _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:kColorMainRed range:range];
    
    if (_goodMode.is_show_pro) {
        [_progressLabel setHidden:NO];
        [_processView setHidden:NO];
    }
    else{
        [_progressLabel setHidden:YES];
        [_processView setHidden:YES];
    }
  
  //  [self.tagView setHidden:YES];
    switch (_goodMode.sk_status) {
        case 1:
            [_button setTitle:@"马上抢" forState:UIControlStateNormal];
            _button.backgroundColor=kColorMain;
            //  [self.tagView setHidden:NO];
           
            break;
        case 2:
            [_button setTitle:@"已结缘" forState:UIControlStateNormal];
              _button.backgroundColor=kColorEEE;
         //   _statusImageView.hidden=NO;
             // [self.tagView setHidden:NO];
            break;
        case 3:
            [_button setTitle:@"提醒我" forState:UIControlStateNormal];
               _button.backgroundColor=kColorMain;
            break;
        case 4:
            [_button setTitle:@"已设提醒" forState:UIControlStateNormal];
              _button.backgroundColor=kColorEEE;
            break;
        case 5:
            [_button setTitle:@"已结束" forState:UIControlStateNormal];
              _button.backgroundColor=kColorEEE;
            break;
            
        default:
            break;
    }
    
        [line setHidden:NO];
     if (self.cellIndex==self.dataCount-1) {
        [line setHidden:YES];
      }
    
}
-(void)setTitleMode:(JHSecKillTitleMode *)titleMode{
    
    _titleMode=titleMode;
    
    [self.tagView setHidden:YES];
    NSTimeInterval nowTime=[[CommHelp getNowTimetampBySyncServeTime] doubleValue]/1000;
    if (nowTime>=_titleMode.online_at&&nowTime<_titleMode.offline_at ) {

         [self.tagView setHidden:NO];
    }
    
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.buttonClick) {
        self.buttonClick(self);
    }
}

@end
