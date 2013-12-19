//
//  MainViewController.h
//  Nana
//
//  Created by Ian Dundas on 16/12/2013.
//  Copyright (c) 2013 Ian Dundas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@end
