//
//  KTVUserHeaderCell.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/8/19.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVUserHeaderCell.h"

@interface KTVUserHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end

@implementation KTVUserHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)modifyUserInfoAction:(UIButton *)sender {
    CLog(@"-- 查看修改个人信息");
    if ([self.delegate respondsToSelector:@selector(toseeMineInfo:)]) {
        [self.delegate toseeMineInfo:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)loginStateAction:(UIButton *)sender {
    CLog(@"--->> 登陆");
    
    if ([self.delegate respondsToSelector:@selector(gotoLogin)]) {
        [self.delegate gotoLogin];
    }
}


@end
