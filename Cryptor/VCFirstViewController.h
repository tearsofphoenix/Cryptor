//
//  VCFirstViewController.h
//  Cryptor
//
//  Created by Lei on 14-1-23.
//  Copyright (c) 2014年 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCFirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *doButton;

- (IBAction)handleDoButtonTappedEvent:(id)sender;

@end
