//
//  KTVMainController.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/7/13.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVMainController.h"
#import "KTVLoginGuideController.h"
#import "KTVBannerCell.h"
#import "KTVBarEnterMenuCell.h"
#import "KTVGuessLikeCell.h"
#import "KTVRecommendCell.h"
#import "KTVBarKtvDetailController.h"
#import "KTVActivityDetailController.h"
#import "KTVAddCommentController.h"

#import "KTVMainService.h"
#import "KTVLoginService.h"

#import "KTVActivity.h"
#import "KTVBanner.h"

#import "KTVPaySuccessController.h"
#import "KTVSelectedBeautyController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "KTVStore.h"

#import "JHPickView.h"
#import "KSPhotoBrowser.h"

@interface KTVMainController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, AMapLocationManagerDelegate, JHPickerDelegate, UISearchBarDelegate, KSPhotoBrowserDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *scanQRbtn;

@property (strong, nonatomic) NSMutableArray<KTVStore *> *storeLikeList;
@property (strong, nonatomic) NSMutableArray<KTVActivity *> *activityList;
@property (strong, nonatomic) NSMutableArray<KTVBanner *> *bannerList;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@implementation KTVMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self initData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor ktvBG];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.searchBar.delegate = self;
    
    // 利用订单查询，获取是否为登陆状态
    //[self loadSearchOrderToJudgeLoginStatus];
    // 获取暖场人
    [self loadStoreLike];
    [self loadNearActivity];
    [self loadMianBanner];
    [self loadAppVersion];
    [self updateBPushChannelId];
    
    [self testCode];
    
    [self initReGecodeLocationCompleteBlock];
    [self configLocationManager];
    
    [self.locationBtn addTarget:self action:@selector(locationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

// 初始化试图
- (void)setupView {
    self.searchBar.backgroundImage = [UIImage new];
}

// 初始化
- (void)initData {
    self.storeLikeList = [NSMutableArray array];
    self.activityList = [NSMutableArray array];
    self.bannerList = [NSMutableArray array];
}

#pragma mark - 网络

/// 查询订单 - 用来判断当前状态是否是登陆状态
/// 查询订单
- (void)loadSearchOrderToJudgeLoginStatus {
    NSString *phone = [KTVCommon userInfo].phone;
    if ([KTVUtil isNullString:phone]) {
        return;
    }
    NSDictionary *params = @{@"username" : phone, @"orderStatus" : @"1"};
    [KTVMainService postSearchOrder:params result:^(NSDictionary *result) {}];
}

/// 猜你喜欢
- (void)loadStoreLike {
    NSString *username = [KTVCommon userInfo].phone;
    safetyString(username);
    NSDictionary *params = @{@"storeType" : @(0),
                             @"username" : username};
    [KTVMainService postStoreLike:params result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCode]) {
            for (NSDictionary *dic in result[@"data"]) {
                KTVStore *store = [KTVStore yy_modelWithDictionary:dic];
                [self.storeLikeList addObject:store];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

// 附近的活动
- (void)loadNearActivity {
    KTVAddress *address = [KTVCommon getUserLocation];
    // 动态获取数据
//    NSDictionary *params = @{@"storeType" : @0,
//                             @"latitude" : @(address.latitude),
//                             @"longitude" : @(address.longitude)};
    // 写死数据
    NSDictionary *params = @{@"storeType" : @0,
                             @"latitude" : @(121.48789949),
                             @"longitude" : @(31.24916171)};
    [KTVMainService postStoreNearActivity:params result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCode]) {
            for (NSDictionary *dic in result[@"data"]) {
                KTVActivity *activity = [KTVActivity yy_modelWithDictionary:dic];
                [self.activityList addObject:activity];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)loadMianBanner {
    [KTVMainService getMainBanner:nil result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCode]) {
            for (NSDictionary *dic in result[@"data"]) {
                KTVBanner *banner = [KTVBanner yy_modelWithDictionary:dic];
                [self.bannerList addObject:banner];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)loadAppVersion {
    NSDictionary *params = @{@"version" : [KTVUtil appVersion]};
    
    [KTVMainService getAppVersion:params result:^(NSDictionary *result) {
        if (![result[@"code"] isEqualToString:ktvCode]) {
            return;
        }
        BOOL needUpdate = [result[@"data"][@"needUpdate"] boolValue];
        if (needUpdate) {
            [KTVToast toast:@"Alert提示框，需要更新"];
        }
    }];
}

- (void)updateBPushChannelId {
    NSString *channelId = [KTVCommon channelId];
    NSString *username = [KTVCommon userInfo].phone;
    // phonetype 3 安卓手机 4 苹果手机
    // channelId  需要前端传过来
    if (username.length && channelId.length) {
        NSDictionary *params = @{@"username" : username, @"channelId" : channelId, @"phoneType" : @4};
        [KTVMainService postUpdateBPushChannel:params result:^(NSDictionary *result) {}];
    }
}

#pragma mark - 事件

- (void)tableHeaderAction:(UIButton *)btn {
    if (btn.tag == 2) {
        CLog(@"--->> 猜你喜欢");
    } else if (btn.tag == 3) {
        CLog(@"--->> 附近活动");
    }
}

- (void)locationBtnAction:(UIButton *)btn {
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    JHPickView *areaPickView = [[JHPickView alloc] initWithFrame:keyWindow.bounds];
    areaPickView.arrayType = AreaArray;
    areaPickView.delegate = self;
    [keyWindow addSubview:areaPickView];
}

#pragma mark - Section Header 封装方法

- (UIView *)tableViewHeader:(NSString *)title tableSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor ktvBG];
    
    UIButton *bgImgView = [[UIButton alloc] init];
    [bgView addSubview:bgImgView];
    [bgImgView setBackgroundImage:[UIImage imageNamed:@"mainpage_all_bg_line"] forState:UIControlStateNormal];
    [bgImgView addTarget:self action:@selector(tableHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
    bgImgView.tag = section;
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    [bgView addSubview:leftLine];
    leftLine.backgroundColor = [UIColor ktvRed];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.height.equalTo(bgView).multipliedBy(0.5f);
        make.width.mas_equalTo(2.0f);
        make.centerY.equalTo(bgView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bgView addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.text = title;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLine.mas_right).offset(7.0f);
        make.centerY.equalTo(bgView);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_arrow_right_hui"]];
    [bgView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.mas_equalTo(titleLabel.mas_right).offset(7.0f);
    }];
    
    return bgView;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return 145.0f;
        }
            break;
        case 1:
        {
            return 70.0f;
        }
            break;
        case 2:
        {
            return 115.0f;
        }
            break;
        case 3:
        {
            return 145.0f;
        }
            break;
        default:
        {
            return 0.0f;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return 40.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return [self tableViewHeader:@"猜你喜欢" tableSection:section];
    } else if (section == 3) {
        return [self tableViewHeader:@"附近活动" tableSection:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        CLog(@"-- 酒吧详情");
        KTVBarKtvDetailController *vc = (KTVBarKtvDetailController *)[UIViewController storyboardName:@"MainPage" storyboardId:@"KTVBarKtvDetailController"];
        KTVStore *store = self.storeLikeList[indexPath.row];
        vc.store = store;;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3) {
        // 附近活动
        KTVActivity *activity = self.activityList[indexPath.row];
        KTVActivityDetailController *vc = (KTVActivityDetailController *)[UIViewController storyboardName:@"MainPage" storyboardId:@"KTVActivityDetailController"];
        vc.activity = activity;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if ([self.bannerList count]) {
                return 1;
            } else {
                return 0;
            }
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return [self.storeLikeList count];
        }
            break;
        case 3:
        {
            return [self.activityList count];
        }
        default:
        {
            return 0;
        }
            break;
    }
}
//KTVBarEnterMenuCell
//KTVGuessLikeCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSMutableArray *imgurlList = [NSMutableArray array];
            for (KTVBanner *banner in self.bannerList) {
                [imgurlList addObject:banner.picture.pictureUrl];
            }
            
            KTVBannerCell *cell = (KTVBannerCell *)[tableView dequeueReusableCellWithIdentifier:KTVStringClass(KTVBannerCell)];
            cell.sdBannerView.delegate = self;
            cell.sdBannerView.imageURLStringsGroup = imgurlList;
            return cell;
        }
            break;
        case 1:
        {
            KTVBarEnterMenuCell *cell = (KTVBarEnterMenuCell *)[tableView dequeueReusableCellWithIdentifier:KTVStringClass(KTVBarEnterMenuCell)];
            return cell;
        }
            break;
        case 2:
        {
            KTVGuessLikeCell *cell = (KTVGuessLikeCell *)[tableView dequeueReusableCellWithIdentifier:KTVStringClass(KTVGuessLikeCell)];
            KTVStore *store = self.storeLikeList[indexPath.row];
            cell.storee = store;
            return cell;
        }
            break;
        case 3:
        {
            KTVRecommendCell *cell = (KTVRecommendCell *)[tableView dequeueReusableCellWithIdentifier:KTVStringClass(KTVRecommendCell)];
            KTVActivity *activity = self.activityList[indexPath.row];
            cell.activity = activity;
            return cell;
        }
        default:
        {
            return [[UITableViewCell alloc] init];
        }
            break;
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    CLog(@"--%@--main page banner click", @(index));
//    KTVLoginGuideController *guideVC = [[KTVLoginGuideController alloc] init];
//    KTVBaseNavigationViewController *nav = [[KTVBaseNavigationViewController alloc] initWithRootViewController:guideVC];
//    [self presentViewController:nav animated:YES completion:nil];
    

    NSMutableArray *urlItems = @[].mutableCopy;
    for (KTVBanner *banner in self.bannerList) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:[UIImageView new] imageUrl:[NSURL URLWithString:banner.picture.pictureUrl]];
        [urlItems addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:urlItems selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

- (void)testCode {
//    KTVPaySuccessController *vc = (KTVPaySuccessController *)[UIViewController storyboardName:@"MainPage" storyboardId:@"KTVPaySuccessController"];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    KTVSelectedBeautyController *vc = (KTVSelectedBeautyController *)[UIViewController storyboardName:@"MainPage" storyboardId:@"KTVSelectedBeautyController"];
//    KTVStore *store = [[KTVStore alloc] init];
//    store.storeId = @"4";
//    vc.store = store;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    KTVAddCommentController *vc = (KTVAddCommentController *)[UIViewController storyboardName:@"MainPage" storyboardId:@"KTVAddCommentController"];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 地理位置相关

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    [self startReGeocode];
}

- (void)startReGeocode {
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)initReGecodeLocationCompleteBlock
{
    __weak KTVMainController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        } else if (error != nil && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation) {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        } else {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //修改label显示内容
        if (regeocode) {
            //            [weakSelf.locationBtn setText:[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            [weakSelf.locationBtn setTitle:[NSString stringWithFormat:@"%@", regeocode.city] forState:UIControlStateNormal];
        } else {
            NSString *latitude = @(location.coordinate.latitude).stringValue;
            NSString *longitude = @(location.coordinate.longitude).stringValue;
            //            [weakSelf.displayLabel setText:[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]];
        }
    };
}

#pragma mark - J

- (void)PickerSelectorIndixString:(NSString *)str {
    NSArray *citys = [str componentsSeparatedByString:@" "];
    NSString *address = citys[citys.count-1];
    self.locationBtn.titleLabel.text = [NSString stringWithFormat:@"%@", address];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    printf("%s", __FUNCTION__);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    NSLog(@"-->> %@", @(index));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

@end
