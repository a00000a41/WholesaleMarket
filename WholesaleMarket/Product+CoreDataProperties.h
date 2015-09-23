//
//  Product+CoreDataProperties.h
//  WholesaleMarket
//
//  Created by 洪坤展 on 2015/9/23.
//  Copyright © 2015年 Hong Kun Zhan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *productname;
@property (nullable, nonatomic, retain) NSNumber *productAmount;
@property (nullable, nonatomic, retain) NSNumber *hasBought;

@end

NS_ASSUME_NONNULL_END
