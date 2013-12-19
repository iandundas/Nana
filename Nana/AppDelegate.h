//
//  AppDelegate.h
//  Nana
//
//  Created by Ian Dundas on 16/12/2013.
//  Copyright (c) 2013 Ian Dundas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;
@property (nonatomic, strong) MainViewController *mainViewController;
@end
