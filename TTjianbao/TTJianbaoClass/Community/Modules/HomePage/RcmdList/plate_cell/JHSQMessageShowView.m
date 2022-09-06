//
//  JHSQMessageShowView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQMessageShowView.h"
#import "JHMessageSubListController.h"
#import "JHGreetViewController.h"

@interface JHSQMessageShowView ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *label;

@property (nonatomic, assign) NSInteger type;

@end

@implementation JHSQMessageShowView

- (void)dealloc {
    NSLog(@"1");
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
    [self jh_cornerRadius:22.5];
    
    _imageView = [UIImageView jh_imageViewWithImage:@"sq_home_message_praise" addToSuperview:self];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    _label = [UILabel jh_labelWithFont:15 textColor:UIColor.whiteColor addToSuperView:self];
    _label.adjustsFontSizeToFitWidth = YES;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
}

+ (void)showType:(NSInteger)type changeNum:(NSInteger)changeNum addToSuperView:(nonnull UIView *)view {
    if(changeNum <= 0)
    {///减操作不显示
        return;
    }
    static NSInteger praiseNum = 0;
    static NSInteger commentNum = 0;
    static NSInteger atNum = 0;
    NSString *tip = @"";
    NSString *imageName = @"";
    switch (type) {
        case 1: {
            commentNum += changeNum;
            commentNum = (commentNum > 0 ? commentNum : 0);
            tip = [NSString stringWithFormat:@"您有%@条新评论",@(commentNum)];
            imageName = @"sq_home_message_comment";
        }
            break;
            
        case 2: {
            praiseNum += changeNum;
            praiseNum = (praiseNum > 0 ? praiseNum : 0);
            tip = [NSString stringWithFormat:@"您收到了%@个赞",@(praiseNum)];
            imageName = @"sq_home_message_praise";

        }
            break;
            
        case 3: {
            atNum += changeNum;
            atNum = (atNum > 0 ? atNum : 0);
            tip = [NSString stringWithFormat:@"您被@了%@次",@(atNum)];
            imageName = @"sq_home_message_at";
        }
            break;
            
        case 4: {
            atNum += changeNum;
            atNum = (atNum > 0 ? atNum : 0);
            tip = [NSString stringWithFormat:@"您被@了%@次",@(atNum)];
            imageName = @"sq_home_message_at";
        }
            break;
            
        default:{
            praiseNum = 0;
            commentNum = 0;
            atNum = 0;
            return;
        }
            break;
    }
    
    UIView *oldView = [view viewWithTag:22222];
    if(oldView) {
        [oldView removeFromSuperview];
    }
    
    JHSQMessageShowView *messageView = [JHSQMessageShowView new];
    [view addSubview:messageView];
    messageView.imageView.image = JHImageNamed(imageName);
    messageView.label.text = tip;
    messageView.type = type;
    messageView.tag = 22222;
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(UI.statusAndNavBarHeight + 20);
        make.centerX.equalTo(view);
        make.size.mas_equalTo([self viewSize]);
    }];
    @weakify(messageView);
    [messageView jh_addTapGesture:^{
        @strongify(messageView);
        commentNum = 0;
        praiseNum  = 0;
        atNum = 0;
        [messageView clickMethod];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [messageView removeFromSuperview];
    });
}

- (void)clickMethod {
    switch (self.type) {
        case 1: {
            JHMessageSubListController *message = [[JHMessageSubListController alloc] initWithTitle:@"评论" pageType:kMsgSublistTypeComment];
            [[JHRootController currentViewController].navigationController pushViewController:message animated:YES];
            [self removeFromSuperview];
        }
            break;
            
        case 2: {
            JHMessageSubListController *message = [[JHMessageSubListController alloc] initWithTitle:@"点赞" pageType:kMsgSublistTypeLike];
            [[JHRootController currentViewController].navigationController pushViewController:message animated:YES];
            [self removeFromSuperview];
        }
            break;
            
        case 3:{
            JHGreetViewController *vc = [JHGreetViewController new];
            vc.pageIndex = @"1";
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 4:{
            JHGreetViewController *vc = [JHGreetViewController new];
            vc.pageIndex = @"0";
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }

    [JHGrowingIO trackEventId:@"msg_Popup_enter"];
}

+ (CGSize)viewSize
{
    return CGSizeMake(164, 45);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
