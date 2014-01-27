//
//  Settings.h
//  SlideMovie
//
//  Created by Kams on 1/20/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController
{
     UIButton *Back_btn;
    int *viewNum;
   // int num;
}

@property (strong, nonatomic) IBOutlet UISwitch *music;
@property(nonatomic, assign)int *viewNum;
@property (strong, nonatomic) IBOutlet UISwitch *screenBlock;

@end
