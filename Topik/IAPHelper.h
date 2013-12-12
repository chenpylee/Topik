//
//  IAPHelper.h
//  Topik
//
//  Created by Lee Haining on 13-12-12.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AppConfig.h"

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
@interface IAPHelper : NSObject
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;
@end
