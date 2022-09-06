//
//  JHCommunityInteractiveViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommunityInteractiveViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@interface JHCommunityInteractiveViewCell ()

@property (strong, nonatomic) UIImageView* image;
@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UILabel* desc;
@property (strong, nonatomic) UIButton* careBtn;

@end

@implementation JHCommunityInteractiveViewCell

-(void)dealloc
{
    NSLog(@"JHCommunityInteractiveViewCell~~dealloc");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //方形
        _image=[[UIImageView alloc]init];
        _image.layer.masksToBounds =YES;
        _image.layer.cornerRadius = 8;
        [self.backgroundsView addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backgroundsView);
            make.size.mas_equalTo(CGSizeMake(60,60));
            make.left.top.offset(10);
            make.bottom.equalTo(self.backgroundsView).offset(-10);
        }];
        
        _title=[[UILabel alloc]init];
        _title.font=JHFont(16);
        _title.textColor=HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.backgroundsView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_image).offset(9);
            make.right.equalTo(self.backgroundsView).offset(-10);
            make.left.mas_equalTo(_image.mas_right).offset(10);
            make.height.offset(17);
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.font=JHFont(13);
        _desc.textColor=HEXCOLOR(0x666666);
        _desc.numberOfLines = 1;
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.lineBreakMode = NSLineBreakByTruncatingTail;
//        _desc.preferredMaxLayoutWidth=ScreenW-130;
        [self.backgroundsView addSubview:_desc];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_title.mas_bottom).offset(14);
            make.left.equalTo(_title).offset(-0.5);
            make.right.equalTo(_title);
            make.height.offset(14);
        }];
    }
    return self;
}

- (void)updateData:(JHMsgSubListNormalForumModel*)model
{
    _title.text = model.title;
    _desc.text = model.body;
    if (model.ext.coverImg)
     {
         [self.image jhSetImageWithURL:[NSURL URLWithString:model.ext.coverImg] placeholder:kDefaultCoverImage];
     }
}

-(void)pressHeadImage
{
    if (self.forumHeadImageActive) {
        self.forumHeadImageActive(self.indexPath, nil);
    }
}

@end

@implementation JHCommunityInteractiveButtonViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         //圆角
        self.image.layer.cornerRadius =22.5;
        self.image.userInteractionEnabled=YES;
        [self.image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressHeadImage)]];
        [self.image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundsView).offset(15);
            make.size.mas_equalTo(CGSizeMake(45,45));
            make.left.offset(10);
            make.bottom.equalTo(self.backgroundsView).offset(-15);
        }];
        
        self.careBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        self.careBtn.titleLabel.font= JHFont(12);
        [self.careBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.careBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [self.careBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.careBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
//        [self.careBtn setBackgroundImage:[UIImage imageNamed:@"messagelist_icon_care_nomal"] forState:UIControlStateSelected];
//        [self.careBtn setBackgroundImage:[UIImage imageNamed:@"messagelist_icon_care_select"] forState:UIControlStateNormal];
        self.careBtn.backgroundColor = kGlobalThemeColor;
        self.careBtn.layer.cornerRadius = 15;
        self.careBtn.layer.masksToBounds = YES;
        [self.careBtn addTarget:self action:@selector(pressCareButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundsView addSubview:self.careBtn];
        [self.careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backgroundsView);
            make.size.mas_equalTo(CGSizeMake(54,30));
            make.right.offset(-10);
        }];
        [self.careBtn setHidden:YES];
        
    }
    return self;
}

- (void)updateData:(JHMsgSubListNormalForumModel*)model
{
//    [super updateData:model];
    
    self.title.text = model.fromName;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image).offset(1.5);
        make.left.mas_equalTo(self.image.mas_right).offset(10.5);
    }];
    self.desc.text = model.body;
    [self.desc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom).offset(15);
        make.left.equalTo(self.title);
    }];
    
    if(model.fromIcon)
    {
        [self.image jhSetImageWithURL:[NSURL URLWithString:model.fromIcon] placeholder:kDefaultAvatarImage];
    }
    
    self.careBtn.hidden = NO;
    self.careBtn.selected = NO;
    if ([model.isFollow isEqualToString: kMsgSublistForumFollowYes])
    {
        self.careBtn.selected = YES;
//        self.image.hidden = YES;
    }
    [self followUserButton:self.careBtn.selected];
}

- (void)followUserButton:(BOOL)selected
{
    if(selected)
    {
        [self.careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(66,30));
        }];
        self.careBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
        self.careBtn.layer.borderColor = kGlobalThemeColor.CGColor;
        self.careBtn.layer.borderWidth = 1;
    }
    else
    {
        [self.careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(54,30));
        }];
        self.careBtn.backgroundColor = kGlobalThemeColor;
        self.careBtn.layer.borderWidth = 0;
    }
}

- (void)pressCareButton:(UIButton*)button
{
    button.selected = !(button.selected);
    
//    [self followUserButton:button.selected];
    if (self.forumCareActive) {
        self.forumCareActive(self.indexPath, button);
    }
}

@end
