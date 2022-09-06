

#import "BaseTabBarController.h"
#import "JHDiscoverChannelModel.h"
#import "FileUtils.h"
#import "JHGrowingIO.h"

@interface BaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSMutableArray *)getLocalChannelData:(NSString *)channelType {
    NSArray *arr;
    NSMutableArray *cateArr=[NSMutableArray array];
    NSData * data=[FileUtils readDataFromFile:channelType];
    if (data) {
        arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    if ([arr isKindOfClass:[NSArray class]]) {
        cateArr =[JHDiscoverChannelModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return cateArr;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    if (selectedIndex == 1) {
        [JHGrowingIO trackEventId:JHEventBusinessliveshow];
    }else if (selectedIndex == 3) {
        [JHGrowingIO trackEventId:JHEventOnlineauthenticate];
    }else if (selectedIndex == 4){
        [JHGrowingIO trackEventId:JHEventPersonalcenter];
    }
}

@end
