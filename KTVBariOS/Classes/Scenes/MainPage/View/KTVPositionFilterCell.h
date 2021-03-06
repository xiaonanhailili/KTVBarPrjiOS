//
//  KTVPositionFilterCell.h
//  KTVBariOS
//
//  Created by pingjun lin on 2017/8/13.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVPositionFilterCell : UITableViewCell

@property (nonatomic, copy) void (^positionCallback)(NSInteger index, NSString *text);

- (instancetype)initWithPositionFilterItems:(NSArray *)items reuseIdentifier:(NSString *)reuseIdentifier;

@end
