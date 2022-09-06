//
//  JHSearchRecommendListCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchRecommendListCell.h"
#import "JHSearchRecommendLivingCell.h"
#import "JHSearchRecommendShopCell.h"
#import "JHSearchRecommendHeaderView.h"
#import "JHNewShopDetailViewController.h"

@interface JHSearchRecommendListCell ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableViewleft;
@property (strong, nonatomic) UITableView *tableViewright;
@property (nonatomic, strong) JHSearchRecommendModel * serchRecommendModel; //热门词 列表

@property (strong, nonatomic) JHSearchRecommendHeaderView *leftHeardView;
@property (strong, nonatomic) JHSearchRecommendHeaderView *rightHeardView;
@end

@implementation JHSearchRecommendListCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(JHSearchRecommendModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.serchRecommendModel = model;
        [self creatCellContentView];
    }
    return self;
}
-(void)creatCellContentView{
    UIScrollView * bgscrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:bgscrollView];
    bgscrollView.showsVerticalScrollIndicator = NO;
    bgscrollView.showsHorizontalScrollIndicator = NO;
    [bgscrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bgscrollView.contentSize = CGSizeMake(kScreenWidth*4/3+37, 751);
    
    self.tableViewleft = [[UITableView alloc]initWithFrame:CGRectMake(12, 5, kScreenWidth*2/3, 741) style:UITableViewStylePlain];
    self.tableViewleft.delegate = self;
    self.tableViewleft.dataSource = self;
//    self.tableViewleft.backgroundColor = UIColor.yellowColor;
    self.tableViewleft.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewleft.scrollEnabled = NO;
    self.tableViewleft.tableHeaderView = self.leftHeardView;
    [bgscrollView addSubview:self.tableViewleft];
    self.tableViewleft.tableFooterView = [[UIView alloc] init];
    
    self.tableViewleft.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移量 默认为(0,3)
    self.tableViewleft.layer.shadowOffset = CGSizeMake(0, 0);
    self.tableViewleft.layer.shadowRadius = 4;//阴影半径
    // 阴影透明度
    self.tableViewleft.layer.shadowOpacity = 0.1;
    self.tableViewleft.clipsToBounds = NO;
    
    
    self.tableViewright = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewleft.right + 13, 5, kScreenWidth*2/3, 741) style:UITableViewStylePlain];
    self.tableViewright.delegate = self;
    self.tableViewright.dataSource = self;
    self.tableViewright.scrollEnabled = NO;
    self.tableViewright.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bgscrollView addSubview:self.tableViewright];
    self.tableViewright.tableHeaderView = self.rightHeardView;
    self.tableViewright.tableFooterView = [[UIView alloc] init];
    
    self.tableViewright.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移量 默认为(0,3)
    self.tableViewright.layer.shadowOffset = CGSizeMake(0, 0);
    self.tableViewright.layer.shadowRadius = 4;//阴影半径
    // 阴影透明度
    self.tableViewright.layer.shadowOpacity = 0.1;
    self.tableViewright.clipsToBounds = NO;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark --- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableViewleft) {
        return self.serchRecommendModel.hotLiveResponses.count;
    }else{
        return self.serchRecommendModel.hotShopResponses.count;
    }
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.tableViewleft) {
        JHSearchRecommendLivingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JHSearchRecommendLivingCell"];
        if (!cell) {
            cell = [[JHSearchRecommendLivingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHSearchRecommendLivingCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell resetCellModel:self.serchRecommendModel.hotLiveResponses[indexPath.row] andindex:indexPath.row];
        return cell;
    }else if(tableView == self.tableViewright){
        JHSearchRecommendShopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JHSearchRecommendShopCell"];
        if (!cell) {
            cell = [[JHSearchRecommendShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHSearchRecommendShopCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell resetCellModel:self.serchRecommendModel.hotShopResponses[indexPath.row]  andindex:indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableViewleft) {
        JHSearchRecommendLivingModel *liveModel = self.serchRecommendModel.hotLiveResponses[indexPath.row];
        [JHRootController EnterLiveRoom:liveModel.channelLocalId fromString:@""];
        
        [JHTracking trackEvent:@"channelClick" property:@{@"anchor_nick_name":NONNULL_STR(liveModel.anchorName) ,@"channel_local_id":NONNULL_STR(liveModel.channelLocalId) ,@"page_position":self.fromStr}];
    }else{
        JHSearchRecommendShopdModel *model =  self.serchRecommendModel.hotShopResponses[indexPath.row];
        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc]init];
        vc.shopId = model.shopId;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
        [JHTracking trackEvent:@"clickStoreFeeds" property:@{@"store_seller_id":NONNULL_STR(model.shopId),@"store_name":NONNULL_STR(model.shopName),@"page_position":self.fromStr}];
    }
    

}
- (JHSearchRecommendHeaderView *)leftHeardView{
    if (!_leftHeardView) {
        _leftHeardView = [[JHSearchRecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*2/3, 41) withTitleName:@"热门直播间"];
    }
    return _leftHeardView;
}
- (JHSearchRecommendHeaderView *)rightHeardView{
    if (!_rightHeardView) {
        _rightHeardView = [[JHSearchRecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*2/3, 41) withTitleName:@"热门店铺"];
    }
    return _rightHeardView;
}
@end
