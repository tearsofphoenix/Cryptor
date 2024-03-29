//
//  VCMethodViewController.m
//  Cryptor
//
//  Created by Lei on 14-1-23.
//  Copyright (c) 2014年 Lei. All rights reserved.
//

#import "VCMethodViewController.h"
#import "VCStyle.h"

@interface VCMethodViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_methods;
}
@end

@implementation VCMethodViewController

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self)
    {
        
//        kCCKeySizeAES192
        
//        kCCKeySizeMinCAST
//        kCCKeySizeMinRC4
//        kCCKeySizeMinRC2
//        kCCKeySizeMinBlowfish
        
        _methods = [[NSMutableArray alloc] init];
        [_methods setArray: (@[
                               @[@(kCCAlgorithmAES128), @"AES128", @(kCCKeySizeAES128)],
                               @[@(kCCAlgorithmAES), @"AES", @(kCCKeySizeAES256)],
                               @[@(kCCAlgorithmDES), @"DES", @(kCCKeySizeDES)],
                               @[@(kCCAlgorithm3DES), @"3DES", @(kCCKeySize3DES)],
                               @[@(kCCAlgorithmCAST), @"CAST", @(kCCKeySizeMaxCAST)],
                               @[@(kCCAlgorithmRC4), @"RC4", @(kCCKeySizeMaxRC4)],
                               @[@(kCCAlgorithmRC2), @"RC2", @(kCCKeySizeMaxRC2)],
                               @[@(kCCAlgorithmBlowfish), @"Blowfish", @(kCCKeySizeMaxBlowfish)],
                               ])];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UITableView *tableView = [self tableView];
    
    [tableView setDataSource: self];
    [tableView setDelegate: self];
    
//    CGRect rect = [tableView frame];
//    rect.origin.y = 20;
//    rect.size.height -= 20;
//    
//    [tableView setFrame: rect];
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_methods count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSArray *info = _methods[[indexPath row]];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [[cell textLabel] setText: info[1]];
    
    return cell;
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (_callback)
    {
        NSArray *info = _methods[[indexPath row]];
        _callback([info[0] integerValue], info[1], [info[2] integerValue]);
        
        [self setCallback: nil];
    }
}

@end
