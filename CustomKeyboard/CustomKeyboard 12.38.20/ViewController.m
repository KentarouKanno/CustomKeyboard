//
//  ViewController.m
//  testSample
//
//  Created by KentarOu on 2014/11/16.
//  Copyright (c) 2014年 KentarOu. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface ViewController ()<UITextFieldDelegate>
{
    UIButton *btn;
    UITextField *selectTextField;
    
    __weak IBOutlet UITextField *textField2;
}
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectTextField = textField2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 0) {
        
         [self removeButton];
    }  else {
        if (selectTextField.tag == 0 && textField.tag == 1) {
            [self makeButton:CGRectZero];
        }
    }
    
     selectTextField = textField;
    
    return YES;
}

- (void)willShowKeyboard:(NSNotification*)notify
{
    // キーボードの表示完了時の場所と大きさを取得します。
    CGRect keyboardFrameEnd = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (selectTextField.tag == 1) {
        [self makeButton:keyboardFrameEnd];
    }
}

- (void)makeButton:(CGRect)keyboardRect
{
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"." forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
        [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(tapSound) forControlEvents:UIControlEventTouchDown];
        btn.backgroundColor = [UIColor clearColor];
        
        if (keyboardRect.size.height != 0) {
            btn.frame = CGRectMake(0,
                                   self.view.frame.size.height - keyboardRect.size.height / 4,
                                   keyboardRect.size.width / 3,
                                   keyboardRect.size.height / 4);
        } else {
            btn.frame = CGRectMake(0,
                                   self.view.frame.size.height - 56,
                                   self.view.frame.size.width / 3,
                                   56);
        }
        
        
        UIWindow *window = [[UIApplication sharedApplication] windows][1];
        [window insertSubview:btn atIndex:0];

    }
}


- (void)willHideKeyboard:(NSNotification*)notify
{
    [self removeButton];
}

- (void)removeButton
{
    [btn removeFromSuperview];
    btn = nil;
}

- (void)push
{
    NSMutableString *tmp = [NSMutableString stringWithString:_numberTextField.text];
    [tmp appendString:@"."];
    _numberTextField.text = tmp;
}

- (void)tapSound
{
    AudioServicesPlaySystemSound(1104);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
