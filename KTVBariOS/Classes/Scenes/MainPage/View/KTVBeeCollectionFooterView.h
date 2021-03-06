//
//  KTVBeeCollectionFooterView.h
//  KTVBariOS
//
//  Created by pingjun lin on 2018/1/21.
//  Copyright © 2018年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVBeeCollectionFooterView : UICollectionReusableView

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) void (^findMoreCallback)(NSInteger type);

@end
