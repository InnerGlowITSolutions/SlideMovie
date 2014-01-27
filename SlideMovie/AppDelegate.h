//
//  AppDelegate.h
//  SlideMovie
//
//  Created by Rejo Joseph on 10/01/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) ViewController *viewController;

@end
