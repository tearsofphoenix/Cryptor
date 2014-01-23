//
//  VCFirstViewController.m
//  Cryptor
//
//  Created by Lei on 14-1-23.
//  Copyright (c) 2014年 Lei. All rights reserved.
//

#import "VCFirstViewController.h"
#import "UIView+FirstResponder.h"
#import "VCMethodViewController.h"
#import "UIView+FirstResponder.h"
#import "VCStyle.h"
#import <CommonCrypto/CommonCrypto.h>

@interface VCFirstViewController ()
{

}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *methodButton;
@property (weak, nonatomic) IBOutlet UITextField *keyField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UITextView *plainTextView;

@property (nonatomic) CCAlgorithm algorithm;

@end

@implementation VCFirstViewController

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName: nibNameOrNil
                                bundle: nibBundleOrNil]))
    {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_scrollView setContentSize: CGSizeMake(320, 560)];
    
//    [_cryptoButton setBackgroundColor: [VCStyle blueColor]];
//    [_cryptoButton setTitleColor: [UIColor whiteColor]
//                        forState: UIControlStateNormal];
    
    [_doButton setBackgroundColor: [VCStyle blueColor]];
    [_doButton setTitleColor: [UIColor whiteColor]
                    forState: UIControlStateNormal];
    
    [_methodButton setBackgroundColor: [VCStyle blueColor]];
    [_methodButton setTitleColor: [UIColor whiteColor]
                        forState: UIControlStateNormal];
    
    [_resultTextView setTextColor: [VCStyle neonGreen]];
    [_plainTextView setTextColor: [VCStyle neonGreen]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(_handleScrollViewTappedEvent:)];
    [_scrollView addGestureRecognizer: tapGestureRecognizer];
    
    [_methodButton addTarget: self
                      action: @selector(_handleMethodButtonTappedEvent:)
            forControlEvents: UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(_notificationForKeyboardShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(_notificationForKeyboardHide:)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
}

- (void)_handleMethodButtonTappedEvent: (id)sender
{
    VCMethodViewController *methodViewController = [[VCMethodViewController alloc] init];
    [methodViewController setCallback: (^(CCAlgorithm algorithm, NSString *title)
                                        {
                                            [self setAlgorithm: algorithm];
                                            [_methodButton setTitle: title
                                                           forState: UIControlStateNormal];
                                            [self dismissViewControllerAnimated: YES
                                                                     completion: nil];
                                        })];
    [self presentViewController: methodViewController
                       animated: YES
                     completion: nil];
}

- (IBAction)handleDoButtonTappedEvent: (id)sender
{
    CCOperation option = kCCEncrypt;
    if ([_segmentControl selectedSegmentIndex] == 1)
    {
        option = kCCDecrypt;
    }
    
    NSString *key = [_keyField text];
    
//    CCCryptorRef cryptor = CCCryptorCreate(option, _algorithm, CCOptions options, key, <#size_t keyLength#>, <#const void *iv#>, CCCryptorRef *cryptorRef)
}

- (void)_handleScrollViewTappedEvent: (id)sender
{
    [[[self view] firstResponder] resignFirstResponder];
}

- (void)_notificationForKeyboardShow: (NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    frame = [[[self view] window] convertRect: frame
                                       toView: [self view]];
    
    UIView *firstResponder = [[self view] firstResponder];
    CGRect rect = [firstResponder frame];
    
    CGFloat offset = rect.origin.y + rect.size.height - frame.origin.y;
    if (offset > 0)
    {
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration: duration
                         animations: (^
                                      {
                                          [_scrollView setContentOffset: CGPointMake(0, offset + 30)
                                                               animated: NO];
                                      })];
    }
}

- (void)_notificationForKeyboardHide: (NSNotification *)notification
{
    NSTimeInterval duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration: duration
                     animations: (^
                                  {
                                      [_scrollView setContentOffset: CGPointZero
                                                           animated: NO];
                                  })];
}

@end
