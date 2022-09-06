//
//  JHDraftBoxView.m
//  TTjianbao
//
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDraftBoxView.h"
#import "JHDraftBoxIconsTableCell.h"
#import "JHDraftBoxVideoTableCell.h"
#import "JHDraftBoxImageTextTableCell.h"
#import "JHSQPublishViewController.h"
#import "JHRichTextEditViewController.h"


@interface JHDraftBoxView () <UITableViewDelegate, UITableViewDataSource, JHDraftBoxTextTableCellDelegate>
{
    BOOL draftEditing;
}

@property (nonatomic, strong) UIButton* deleteButton;
@property (nonatomic, strong) NSMutableArray* draftArray;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;
@end

@implementation JHDraftBoxView

- (void)dealloc
{
    NSLog(@"~~~dealloc !! ");
    [_deleteButton removeFromSuperview];
}

- (instancetype)initWitEditType:(BOOL)editing
{
    if(self = [super init])
    {
        draftEditing = editing;
        self.backgroundColor = HEXCOLOR(0xF5F6FA);
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
//        self.estimatedRowHeight = 116;
        self.rowHeight = UITableViewAutomaticDimension;
        [self loadDraftData];
    }
    return self;
}

- (UIButton *)deleteButton
{
    if(!_deleteButton)
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake((ScreenWidth - 320)/2.0, ScreenHeight - 38 - 44, 320, 44);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:JHMediumFont(15)];
        [_deleteButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _deleteButton.layer.cornerRadius = 22;
        _deleteButton.layer.masksToBounds = YES;
        [_deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        //渐变色
        CAGradientLayer* gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0, 0); //x和y坐标
        gradient.endPoint = CGPointMake(0, 1);//横向渐变
        gradient.frame = _deleteButton.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)HEXCOLOR(0xFEE100).CGColor, (id)HEXCOLOR(0xFFC242).CGColor,nil];
         [_deleteButton.layer insertSublayer:gradient atIndex:0];
    }
    return _deleteButton;
}

- (void)deleteButtonHidden:(BOOL)hidden
{
    [_deleteButton removeFromSuperview];
    if(!hidden)
    {
        [JHKeyWindow addSubview:self.deleteButton];
    }
}

- (void)loadDraftData
{
    self.draftArray = [NSMutableArray arrayWithArray:[JHDraftBoxModel dataArray]];
    
    if(self.draftArray.count>0){
        [self hiddenEmptyPage:YES];
    }else{
        [self hiddenEmptyPage:NO];
    }
}

- (void)refreshView
{
    [self.heightAtIndexPath removeAllObjects];
    [self loadDraftData];
    [self reloadData];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.draftArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return UITableViewAutomaticDimension;
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height) {
        return height.floatValue;
    } else {
        return UITableViewAutomaticDimension;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
//    if(height) {
//        return height.floatValue;
//    } else {
//        return UITableViewAutomaticDimension;
//    }
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHDraftBoxModel* model =  nil;
    if(indexPath.row < self.draftArray.count)
        model = self.draftArray[indexPath.row];
    
    if(model.style == JHDraftBoxStyleVideo)
    {
        JHDraftBoxVideoTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHDraftBoxVideoTableCell class])];
        if(!cell)
        {
            cell = [[JHDraftBoxVideoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHDraftBoxVideoTableCell class])];
            if(draftEditing)
            {
                cell.delegate =self;
                [cell drawEditSubviews];
            }
        }
        [cell updateData:model];
        
        return cell;
    }
    else if(model.style == JHDraftBoxStyleIcons)
    {
        JHDraftBoxIconsTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHDraftBoxIconsTableCell class])];
        if(!cell)
        {
            cell = [[JHDraftBoxIconsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHDraftBoxIconsTableCell class])];
            if(draftEditing)
            {
                cell.delegate =self;
                [cell drawEditSubviews];
            }
        }
        [cell updateData:model];
        
        return cell;
    }
    else
    {
        JHDraftBoxImageTextTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHDraftBoxImageTextTableCell class])];
        if(!cell)
        {
            cell = [[JHDraftBoxImageTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHDraftBoxImageTextTableCell class])];
            if(draftEditing)
            {
                cell.delegate =self;
                [cell drawEditSubviews];
            }
        }
        [cell updateData:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row < self.draftArray.count)
    {
        JHDraftBoxModel* m = self.draftArray[row];
        if(m.style == JHDraftBoxStyleVideo || m.style == JHDraftBoxStyleIcons)
        {
            JHSQPublishViewController *vc = [JHSQPublishViewController new];
            vc.draftBoxModel = m;
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            [self.draftArray removeObjectAtIndex:row];
            [JHDraftBoxModel saveDataArray:self.draftArray];
            [self reloadData];
        }
        
        if(m.style == JHDraftBoxStyleImageText)
        {
            JHRichTextEditViewController *vc = [JHRichTextEditViewController new];
            vc.draftBoxModel = m;
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            [self.draftArray removeObjectAtIndex:row];
            [JHDraftBoxModel saveDataArray:self.draftArray];
            [self reloadData];
        }
        
    }
}

#pragma mark - event
- (void)pressCellEvent
{
    BOOL show = NO;
    for (JHDraftBoxModel* m in self.draftArray)
    {
        if(m.editSelected)
        {
            show = YES;
            break;
        }
    }
    [self deleteButtonHidden:!show];
}

- (void)pressDeleteButton
{
    {
        NSMutableArray* tmpArr = [NSMutableArray arrayWithArray:self.draftArray];
        for (JHDraftBoxModel* m in tmpArr)
        {
            if(m.editSelected)
            {
                [self.draftArray removeObject:m];
            }
        }
        [JHDraftBoxModel saveDataArray:self.draftArray];
        [self reloadData];
    }
    [self deleteButtonHidden:YES];
    if(self.finishAction)
    {
        self.finishAction(nil);
    }
}
- (NSMutableDictionary *)heightAtIndexPath{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return _heightAtIndexPath;
}
@end
