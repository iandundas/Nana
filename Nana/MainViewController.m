//
//  MainViewController.m
//  Nana
//
//  Created by Ian Dundas on 16/12/2013.
//  Copyright (c) 2013 Ian Dundas. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property(nonatomic, strong) NSLayoutConstraint *bottomLayoutConstraint;
@end

@implementation MainViewController
static float initialPadding = 30;

#pragma mark View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Nana's Email Composer";

    [self.navigationItem setRightBarButtonItem:
            [[UIBarButtonItem alloc] initWithTitle:@"Send!" style:UIBarButtonItemStyleDone target:self action:@selector(showMailPicker:)]
    ];
    [self.navigationItem setLeftBarButtonItem:
            [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(promptClearTextView)]
    ];

    [_textView setText:@""];
    [_textView setFont:[UIFont fontWithName:@"OpenDyslexic-Regular" size:30]];
    [_textView becomeFirstResponder];

    _bottomLayoutConstraint = [NSLayoutConstraint
            constraintWithItem:_textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                        toItem:self.view attribute:NSLayoutAttributeBottom
                    multiplier:1 constant:-initialPadding];

    [self.view addConstraint:_bottomLayoutConstraint];

}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark Clear or Send
- (void)showMailPicker:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet];
    }
}

- (void)promptClearTextView {
    UIAlertView *alertView= [[UIAlertView alloc]
            initWithTitle:@"Clear the screen?"
                  message:@"Do you want to clear the screen and start again?"
                 delegate:self
        cancelButtonTitle:@"no"
        otherButtonTitles:@"clear", nil];

    [alertView show];

}
    
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        _textView.text=@"";
    }
}




#pragma mark Keyboard Hide or Show functionality

- (void)keyboardWillShow:(NSNotification *)notification {
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveTextViewForKeyboard:notification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification *)notification up:(BOOL)up {

    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    CGRect keyboardEndFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    keyboardFrame.size.height -= self.tabBarController.tabBar.frame.size.height;

    CGFloat keyboardHeightIfShowing = (up ? keyboardFrame.size.height : 0);

    if (up)
        _bottomLayoutConstraint.constant -= keyboardHeightIfShowing;
    else
        _bottomLayoutConstraint.constant = -initialPadding;

    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark Send Email
- (void)displayMailComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;

    [picker setSubject:@"Email from Evelyn"];

    // Set up recipients
//    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
//    [picker setToRecipients:toRecipients];

    // Attach an image to the email
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//    [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];

    // Fill out the email body text
    [picker setMessageBody:_textView.text isHTML:NO];

    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Messenger Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    // do nothing.
}


@end
