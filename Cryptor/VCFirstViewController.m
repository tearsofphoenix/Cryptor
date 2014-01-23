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
#import "UIAlertView+BlockSupport.h"
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

@property (weak, nonatomic) IBOutlet UISegmentedControl *optionSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ivLabel;
@property (weak, nonatomic) IBOutlet UITextField *ivTextField;

@property (nonatomic) CCAlgorithm algorithm;
@property (nonatomic) NSInteger size;

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
    [methodViewController setCallback: (^(CCAlgorithm algorithm, NSString *title, NSInteger size)
                                        {
                                            [self setAlgorithm: algorithm];
                                            [self setSize: size];
                                            
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
//    NSError *error = nil;
//    NSLog(@"%@", [[self class] tripleDesEncryptData: [@"123" dataUsingEncoding: NSUTF8StringEncoding]
//                                                key: [@"123456781234567812345678" dataUsingEncoding: NSUTF8StringEncoding]
//                                              error: &error]);
//    NSLog(@"%@", error);
//    
//    return;
    
//    NSLog(@"%@", [self DESEncryptStr: @"okoko"
//                                 key: @"12345678"]);
//    return;
    
    CCOperation operation = kCCEncrypt;
    if ([_segmentControl selectedSegmentIndex] == 1)
    {
        operation = kCCDecrypt;
    }
    
    NSData *keyData = [[_keyField text] dataUsingEncoding: NSUTF8StringEncoding];
    CCOptions options = [_optionSegmentControl selectedSegmentIndex];
    
    //    NSString *iv = [_ivTextField text];
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    NSData *inputText = [[_plainTextView text] dataUsingEncoding: NSUTF8StringEncoding];
    
    NSInteger length = ([inputText length] + _size) & ~(_size -1);
    uint8_t *outData = malloc(sizeof(*outData) * length);
    size_t outSize = 0;
    
    CCCryptorStatus status = CCCrypt(operation, _algorithm,
                                     1,//options,
                                     [keyData bytes], [keyData length],
                                     iv,
                                     [inputText bytes], [inputText length],
                                     outData, length, &outSize);
    //    CCCryptorCreate(option, _algorithm, options,
    //                                             [key UTF8String], [key length],
    //                                             [iv UTF8String], &cryptor);
    NSString * sResult = [[NSString alloc] initWithData: [NSData dataWithBytes: outData
                                                                        length: outSize]
                                               encoding: NSUTF8StringEncoding];
    NSLog(@"%@", sResult);
    
    switch (status)
    {
        case kCCSuccess:
        {
            NSLog(@"in func: %s, ok!", __func__);
            break;
        }
        case kCCParamError:
        {
            [UIAlertView alertWithMessage: @"Invalid parameter!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        case kCCBufferTooSmall:
        {
            [UIAlertView alertWithMessage: @"Buffer is too small!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        case kCCMemoryFailure:
        {
            [UIAlertView alertWithMessage: @"Memory is not enough!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        case kCCAlignmentError:
        {
            [UIAlertView alertWithMessage: @"Data is not aligned!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        case kCCDecodeError:
        {
            [UIAlertView alertWithMessage: @"Input data did not decode or decrypt properly!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        case kCCUnimplemented:
        {
            [UIAlertView alertWithMessage: @"Method not implemented!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        case kCCOverflow:
        {
            [UIAlertView alertWithMessage: @"Memory overflow!"
                        cancelButtonTitle: @"OK"];
            break;
        }
        default:
        {
            break;
        }
    }
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

- (NSString *)DESEncryptStr: (NSString *)sTextIn
                        key: (NSString *)sKey
{
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding|kCCOptionECBMode,
                                       [dKey bytes], [dKey length],
                                       iv,
                                       [dTextIn bytes], [dTextIn length],
                                       (void *)bufferPtr1, bufferPtrSize1, &movedBytes1);
    
    NSString * sResult = [[NSString alloc] initWithData: [NSData dataWithBytes:bufferPtr1
                                                                       length:movedBytes1]
                                               encoding: EnC];
    free(bufferPtr1);
    return sResult;
}


+ (NSData *)tripleDesEncryptData:(NSData *)inputData
                             key:(NSData *)keyData
                           error:(NSError **)error
{
    NSParameterAssert(inputData);
    NSParameterAssert(keyData);
    
    size_t outLength;
    
    NSAssert(keyData.length == kCCKeySize3DES, @"the keyData is an invalid size");
    
    NSMutableData *outputData = [NSMutableData dataWithLength:(inputData.length  +  kCCBlockSize3DES)];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kCCAlgorithm3DES, // Algorithm
                     1, // options
                     keyData.bytes, // key
                     keyData.length, // keylength
                     nil,// iv
                     inputData.bytes, // dataIn
                     inputData.length, // dataInLength,
                     outputData.mutableBytes, // dataOut
                     outputData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result != kCCSuccess)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain:@"com.your_domain.your_project_name.your_class_name."
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    [outputData setLength:outLength];
    return outputData;
}

@end
