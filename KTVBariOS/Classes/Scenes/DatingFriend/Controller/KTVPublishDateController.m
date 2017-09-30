//
//  KTVPublishDateController.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/9/29.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVPublishDateController.h"
#import "KTVCallOtherController.h"
#import "KTVPickerView.h"

@interface KTVPublishDateController ()

@property (weak, nonatomic) IBOutlet UIButton *barNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn; // 费用
@property (weak, nonatomic) IBOutlet UITextView *explainTextView;
@property (weak, nonatomic) IBOutlet UIImageView *firstimageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@end

@implementation KTVPublishDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 0) {
        self.title = @"酒吧";
    } else {
        self.title = @"KTV";
    }
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化Ui

- (void)initUI {
    self.explainTextView.backgroundColor = [UIColor ktvTextFieldBg];
    self.explainTextView.layer.cornerRadius = 5;
}

#pragma mark - 事件

- (IBAction)chooseBarAction:(UIButton *)sender {
    CLog(@"-->> 选择酒吧");
}

- (IBAction)chooseYearAction:(UIButton *)sender {
    CLog(@"-->> 选择年");
    KTVPickerView *pv = [[KTVPickerView alloc] initWithSelectedCallback:^(NSString *selectedTitle) {
        [sender setTitle:selectedTitle forState:UIControlStateNormal];
    }];
    [self.view addSubview:pv];
    pv.dataSource = @[@"2017", @"2018", @"2019", @"2020"];
    [pv mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.equalTo(self.view);}];
}

- (IBAction)chooseMonthAction:(UIButton *)sender {
    CLog(@"-->> 选择月");
    KTVPickerView *pv = [[KTVPickerView alloc] initWithSelectedCallback:^(NSString *selectedTitle) {
        [sender setTitle:selectedTitle forState:UIControlStateNormal];
    }];
    [self.view addSubview:pv];
    pv.dataSource = [KTVUtil monthList];
    [pv mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.equalTo(self.view);}];
}

- (IBAction)chooseDayAction:(UIButton *)sender {
    CLog(@"-->> 选择日");
    NSInteger month = [self.monthBtn.currentTitle integerValue];
    KTVPickerView *pv = [[KTVPickerView alloc] initWithSelectedCallback:^(NSString *selectedTitle) {
        [sender setTitle:selectedTitle forState:UIControlStateNormal];
    }];
    [self.view addSubview:pv];
    pv.dataSource = [KTVUtil dayListByMonth:month];
    [pv mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.equalTo(self.view);}];
}

- (IBAction)chooseGenderAction:(UIButton *)sender {
    CLog(@"-->> 选择性别");
    KTVPickerView *pv = [[KTVPickerView alloc] initWithSelectedCallback:^(NSString *selectedTitle) {
        [sender setTitle:selectedTitle forState:UIControlStateNormal];
    }];
    [self.view addSubview:pv];
    pv.dataSource = @[@"男", @"女"];
    [pv mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.equalTo(self.view);}];
}

- (IBAction)choosePayAction:(UIButton *)sender {
    CLog(@"-->> 选择付款方式");
    KTVPickerView *pv = [[KTVPickerView alloc] initWithSelectedCallback:^(NSString *selectedTitle) {
        [sender setTitle:selectedTitle forState:UIControlStateNormal];
    }];
    [self.view addSubview:pv];
    pv.dataSource = @[@"AA制", @"我一个付", @"我付大部分"];
    [pv mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.equalTo(self.view);}];
}

- (IBAction)chooseAendAction:(UIButton *)sender {
    CLog(@"-->> 我接送");
    [sender setSelected:!sender.isSelected];
    UIImage *image = nil;
    if (sender.isSelected) {
        image = [UIImage imageNamed:@"app_gou_red"];
    } else {
        image = [UIImage imageNamed:@"app_selected_kuang"];
    }
    [sender setImage:image forState:UIControlStateNormal];
}

- (IBAction)publishYueAction:(UIButton *)sender {
    CLog(@"-->> 发布预约");
    [self showYaoYueSuccess:YES];
}

- (void)cancelAction:(UIButton *)btn {
    [btn.superview.superview removeFromSuperview];
}

- (void)callOtherPlayAction:(UIButton *)btn {
    [btn.superview.superview removeFromSuperview];
    CLog(@"-->>> 喊人玩");
    KTVCallOtherController *vc = (KTVCallOtherController *)[UIViewController storyboardName:@"DatingFriend" storyboardId:@"KTVCallOtherController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 展示邀约成功弹出框

- (void)showYaoYueSuccess:(BOOL)isShow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *mask = [[UIView alloc] init];
    [keyWindow addSubview:mask];
    mask.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    [mask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    
    UIView *toastBgView = [[UIView alloc] init];
    [mask addSubview:toastBgView];
    toastBgView.backgroundColor = [UIColor whiteColor];
    toastBgView.layer.cornerRadius = 8;
    [toastBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(mask);
        make.width.equalTo(mask).multipliedBy(0.8);
        make.height.equalTo(toastBgView.mas_width).multipliedBy(0.6);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [toastBgView addSubview:titleLabel];
    titleLabel.textColor = [UIColor ktvBG];
    titleLabel.text = @"发布邀约成功";
    titleLabel.font = [UIFont bold17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toastBgView);
        make.top.equalTo(toastBgView).offset(20);
        make.width.equalTo(toastBgView).multipliedBy(0.9);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toastBgView addSubview:cancelBtn];
    [cancelBtn setTitle:@"知道了" forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = [UIColor ktvPlaceHolder].CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.titleLabel.font = [UIFont bold17];
    [cancelBtn setTitleColor:[UIColor ktvPlaceHolder] forState:UIControlStateNormal];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toastBgView).offset(-15);
        make.width.equalTo(toastBgView).multipliedBy(0.4);
        make.height.equalTo(@40);
        make.left.equalTo(toastBgView).offset(10);
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toastBgView addSubview:confirmBtn];
    [confirmBtn setTitle:@"喊人玩" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 5;
    [confirmBtn setBackgroundColor:[UIColor ktvGold]];
    cancelBtn.titleLabel.font = [UIFont bold17];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toastBgView).offset(-15);
        make.width.equalTo(toastBgView).multipliedBy(0.4);
        make.height.equalTo(@40);
        make.right.equalTo(toastBgView).offset(-10);
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    [toastBgView addSubview:messageLabel];
    messageLabel.textColor = [UIColor ktvBG];
    messageLabel.text = @"您的邀约已经发布，可以喊人来玩了～";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 2;
    messageLabel.font = [UIFont systemFontOfSize:15];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toastBgView);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.width.equalTo(toastBgView).multipliedBy(0.9);
        make.bottom.equalTo(cancelBtn.mas_top).offset(-20);
    }];
    
    // 添加按钮事件
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn addTarget:self action:@selector(callOtherPlayAction:) forControlEvents:UIControlEventTouchUpInside];
}

@end
