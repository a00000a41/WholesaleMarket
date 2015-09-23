//
//  ProductTableViewCell.h
//  WholesaleMarket
//
//  Created by 洪坤展 on 2015/9/23.
//  Copyright © 2015年 Hong Kun Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productAmountLabel;

@end
