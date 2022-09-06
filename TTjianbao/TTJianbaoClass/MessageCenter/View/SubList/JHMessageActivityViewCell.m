//
//  HomeTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/9.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHMessageActivityViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "PPStickerDataManager.h"

#define kRateOfImage 130/325.0

@interface JHMessageActivityViewCell ()

@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel *desc;
@end

@implementation JHMessageActivityViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _title=[[UILabel alloc]init];
        _title.font=JHFont(16);
        _title.textColor=HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.backgroundsView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.top.equalTo(self.backgroundsView).offset(8);
            make.left.equalTo(self.backgroundsView).offset(10);
            make.right.equalTo(self.backgroundsView).offset(-10);
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.font=JHFont(13);
        _desc.textColor=HEXCOLOR(0x666666);
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.lineBreakMode = NSLineBreakByTruncatingTail;
//        _desc.preferredMaxLayoutWidth = ScreenW-53*2; //影响自身高度,上下有空隙
//        [_desc setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _desc.numberOfLines = 2;
        [self.backgroundsView addSubview:_desc];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_title.mas_bottom).offset(6.5);
            make.left.equalTo(self.backgroundsView).offset(10);
            make.right.equalTo(self.backgroundsView).offset(-13);
//            make.height.mas_lessThanOrEqualTo(33.5);
        }];
        
        _productImage=[[UIImageView alloc]init];
        _productImage.image=kDefaultCoverImage;
        _productImage.layer.masksToBounds =YES;
        _productImage.layer.cornerRadius = 8;
        [self.backgroundsView addSubview:_productImage];
        [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(10); //优惠活动(11.5)与平台公告(9.5)不一致
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset((ScreenW-25*2)*kRateOfImage);
            make.bottom.equalTo(self.backgroundsView).offset(-10);
        }];
    }
    
    return self;
}

- (void)updateData:(JHMsgSubListAnnounceModel*)model
{
    if (model.title) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.title];
        [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attStr font:JHFont(14)];
        _title.attributedText = attStr;
    }else{
        _title.text = @"";
    }
    
    if (model.body) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.body];
        [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attStr font:self.desc.font];
        _desc.attributedText = attStr;
    }else{
        _desc.text = @"";
    }
    
    if(model.image) //服务端暂定用image,忽略imageUrl
    {
        [self.productImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(10);
            make.height.offset((ScreenW-25*2)*kRateOfImage);
        }];
        [self.productImage jhSetImageWithURL:[NSURL URLWithString:model.image] placeholder:kDefaultCoverImage];
    }
    else //无图cell
    {
        [self.productImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(1.5);
            make.height.offset(0);
        }];
    }
}

@end




