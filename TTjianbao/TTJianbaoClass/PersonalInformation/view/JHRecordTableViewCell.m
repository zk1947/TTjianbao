//
//  JHRecordTableViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHRecordTableViewCell.h"
#import "NIMAvatarImageView.h"
#import "TTjianbaoMarcoUI.h"

@interface JHRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UIButton *goodRateBtn;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *duringLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end


@implementation JHRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JHAppraiseRecordModel *)model {
    _model = model;
    if (model) {
        if (self.type == 1) {
            
            [_avatar nim_setImageWithURL:[NSURL URLWithString:model.viewerIcon?:@""] placeholderImage:kDefaultAvatarImage];
            _nickLabel.text = model.viewerName;
            [_goodRateBtn setTitle:[NSString stringWithFormat:@"满意度%.1f%%",(CGFloat)model.anchorGrade] forState:UIControlStateNormal];
            _postImage.hidden = YES;
            
            
        }else {
            [_avatar nim_setImageWithURL:[NSURL URLWithString:model.anchorIcon?:@""] placeholderImage:kDefaultAvatarImage];
            _nickLabel.text = model.anchorName;
            [_goodRateBtn setTitle:[NSString stringWithFormat:@"满意度%.1f%%",(CGFloat)model.anchorGrade] forState:UIControlStateNormal];
            _postImage.hidden = NO;
            
        } 
        if (model.recordTime.length>18) {
            _dateLabel.text = [model.recordTime substringToIndex:10];
            _timeLabel.text = [model.recordTime substringWithRange:NSMakeRange(11, 8)];
            
        }

        _duringLabel.text = [self getHMSWithSecond:model.appraiseSecond];
        
    }
}

- (NSString *)getHMSWithSecond:(NSInteger)second {
    NSInteger hh = second/60/60;
    NSInteger mm = second/60%60;
    NSInteger ss = second%60;
    
    return hh>0 ?[NSString stringWithFormat:@"%02zd:%02zd:%02zd ",hh,mm,ss]:[NSString stringWithFormat:@"%02zd:%02zd ",mm,ss];
    
}

@end
