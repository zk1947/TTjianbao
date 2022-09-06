//
//  NTESWaterMarkView.m
//  TTjianbao
//
//  Created by Simon Blue on 2017/5/19.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESWaterMarkView.h"
#import "UIView+NTES.h"



@interface NTESWaterMarkBar : UIView

@property (nonatomic,weak) id<NTESWaterMarkViewDelegate> delegate;

- (void)reset;

@end



@interface NTESWaterMarkView ()

@property (nonatomic, strong) NTESWaterMarkBar *bar;

@end

@implementation NTESWaterMarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bar];
    }
    return self;
}

- (void)setDelegate:(id<NTESWaterMarkViewDelegate>)delegate
{
    _delegate = delegate;
    self.bar.delegate = delegate;
}


- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    self.bar.width = self.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)reset
{
    [self.bar reset];
}

- (NTESWaterMarkBar *)bar
{
    if (!_bar) {
        _bar = [[NSBundle mainBundle] loadNibNamed:@"NTESWaterMarkBar" owner:nil options:nil].firstObject;
    }
    return _bar;
}

@end

@interface NTESWaterMarkBar ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation NTESWaterMarkBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.lastIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.tintColor = HEXCOLOR(0xffffff);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.textColor = HEXCOLOR(0xffffff);

    }

    cell.textLabel.text = [self titleForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 2) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    }
    
    if (indexPath == self.lastIndexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.lastIndexPath = indexPath;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onWaterMarkTypeSelected:)]) {
        [self.delegate onWaterMarkTypeSelected:[self changeByIndexPath:indexPath]];
    }
    
    [self onCancelButtonPressed:nil];
}

- (IBAction)onCancelButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onWaterMarkCancelButtonPressed)]) {
        [self.delegate onWaterMarkCancelButtonPressed];
    }
}

- (void)reset
{
    self.lastIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableview reloadData];
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return @"静态水印";
            break;
            
        case 1:
            return @"动态水印";
            break;
            
        case 2:
            return @"关闭水印";
            break;
            
        default:
            return @"关闭水印";
            break;
    }
}

- (NTESWaterMarkType)changeByIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return NTESWaterMarkTypeNormal;
            break;
            
        case 1:
            return NTESWaterMarkTypeDynamic;
            break;

        case 2:
            return NTESWaterMarkTypeNone;
            break;

        default:
            return NTESWaterMarkTypeNone;
            break;
    }
}

@end
