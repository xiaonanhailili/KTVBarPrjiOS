//
//  KTVUserPhontosCell.h
//  KTVBariOS
//
//  Created by pingjun lin on 2017/9/5.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVUserPhontosCell : UITableViewCell

@property (nonatomic, strong) NSArray<KTVPicture *> * pictureList;

@property (nonatomic, copy) void (^userImageTapCallback)(NSInteger index, NSArray<KTVPicture *> *pictureList);

@end
