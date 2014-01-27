//
//  Settings.m
//  SlideMovie
//
//  Created by Kams on 1/20/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import "Settings.h"
#import "ViewController.h"
#import "SubCategory.h"
#import "Story.h"

@interface Settings ()

@end

@implementation Settings

@synthesize music;
@synthesize screenBlock;
@synthesize viewNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Back_btn.frame = CGRectMake(20, 25, 20, 20);
    [Back_btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:
	 UIControlStateNormal];
	[Back_btn addTarget:self action:@selector(PrevView:) forControlEvents:UIControlEventTouchUpInside];
    Back_btn.tag = 0;
	[self.view addSubview:Back_btn];
    
    [screenBlock addTarget:self action:@selector(Block:) forControlEvents:UIControlEventValueChanged];
    
    [music addTarget:self action:@selector(Play:) forControlEvents:UIControlEventValueChanged];
  
}

- (void)Block:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
    }
}

- (void)Play:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
    }
}

-(void)PrevView: (id)sender
{
    int num=viewNum;
    NSLog(@"%d",num);
    switch (num) {
        case 1:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {

            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
   
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
