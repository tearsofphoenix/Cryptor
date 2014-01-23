//
//  VCMethodViewController.h
//  Cryptor
//
//  Created by Lei on 14-1-23.
//  Copyright (c) 2014年 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>

typedef void (^ VCMethodCallback)(CCAlgorithm algorithm, NSString *title);

@interface VCMethodViewController : UITableViewController

@property (nonatomic, copy) VCMethodCallback callback;

@end
