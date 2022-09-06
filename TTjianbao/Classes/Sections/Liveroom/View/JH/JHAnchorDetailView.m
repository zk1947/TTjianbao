//
//  JHAnchorDetailView.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/28.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHAnchorDetailView.h"
#import "NIMAvatarImageView.h"
#import "MJRefresh.h"
#import "UIImageView+JHWebImage.h"

@interface JHAnchorDetailView ()
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *platformBtn;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *cerArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBottomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cerHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaHeight;

@property (weak, nonatomic) IBOutlet UILabel *areaTitleLabel;

@end

@implementation JHAnchorDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.toBottomHeight.constant = UI.bottomSafeAreaHeight+13;
    
}
- (void)setModel:(JHAnchorInfoModel *)model {
    _model = model;
    if (_model) {
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:model.appraiserImg] placeholderImage:kDefaultAvatarImage];
        self.nickLabel.text = model.appraiserName;
        self.desLabel.text = model.appraiserIntroduction;
        
        if (model.tags.count) {
            NSString *string = @"鉴定范围：";
            for (NSDictionary *dic in model.tags) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@" %@",dic[@"tagName"]]];
            }
            self.areaLabel.text = string;
        }else {
            self.areaLabel.text = @"";
        }
        [self.platformBtn setTitle:[NSString stringWithFormat:@" %@", model.appraiserDesc] forState:UIControlStateNormal];
        
        CGFloat max = 0;
        for (NSInteger i = 0; i<self.cerArray.count; i++) {
            UIImageView *img = self.cerArray[i];
            if (i<model.certifications.count) {
                NSDictionary *dic = model.certifications[i];
                //                NSString *name = dic[@"tagName"];
                NSString *icon = dic[@"tagIcon"];
                
                img.hidden = NO;
                img.contentMode = UIViewContentModeScaleAspectFit;
                img.backgroundColor = [UIColor lightGrayColor];
                [img jhSetImageWithURL:[NSURL URLWithString:icon] placeholder:[UIImage imageNamed:@""]];
                
                img.frame = CGRectMake(max, 0, 50, 50);
                max += 60;
                
                
            }else {
                img.hidden = YES;
            }
        }
        
        [self layoutIfNeeded];
        self.contentHeight.constant = self.desLabel.mj_y+self.desLabel.mj_h+20;
    }
}

- (void)setSaleAnchor {
    [self.platformBtn setImage:nil forState:UIControlStateNormal];
    [self.platformBtn setTitle:@"" forState:UIControlStateNormal];
    self.cerHeight.constant = 0;
    self.areaLabel.text = @"";
    self.areaHeight.constant = 0;
}
@end
