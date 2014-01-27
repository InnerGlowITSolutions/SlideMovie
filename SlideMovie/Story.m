//
//  Story.m
//  SlideMovie
//
//  Created by Kams on 1/16/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import "Story.h"
#import "SBJson.h"
#import "Settings.h"
#import "SubCategory.h"
#import "Reachability.h"



@interface Story ()

@end

@implementation Story
typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@synthesize m_SelectedIndexPath_story;
@synthesize storyScollview;
@synthesize StoryView;
@synthesize imageMutableData;
@synthesize storyImgView;
@synthesize story_name;
@synthesize rate;
@synthesize commentText;

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
    [storyScollview setScrollEnabled:YES];
    storyScollview.hidden=YES;
    image_array = [[NSMutableArray alloc] init];
    image_tabledata = [[NSMutableArray alloc] init];
    self.imageMutableData =[NSMutableData data];
    ScrollDirection scrollDirection=ScrollDirectionNone;
    imageIndex = 0;
    i=0;
    x=0;
    playery=30;
    playerWidth=320;
    playerHeight=230;
    
    NSString *urlText = [NSString stringWithFormat:@"http://192.168.123.120/projects/slidemovieapp/images.php?storyname=%@",story_name];
    
    
    NSString* urlTextEscaped = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString: urlTextEscaped]];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Loading", nil) message:NSLocalizedString(@"\n\n", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [myAlertView show];
    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loading.center = CGPointMake(myAlertView.bounds.size.width * 0.5f, myAlertView.bounds.size.height * 0.5f);
    [loading startAnimating];
    [myAlertView addSubview:loading];
    
    commentText = [[UITextView alloc]initWithFrame:CGRectMake(10, 360, 300, 30)];
    [commentText setDelegate:self];
    [commentText setBackgroundColor:[UIColor clearColor]];
    commentText.userInteractionEnabled = YES;
    [commentText setFont:[UIFont fontWithName:@"Arial" size:12]];
    [[commentText layer] setBorderColor:[[UIColor brownColor] CGColor]];
    [[commentText layer] setBorderWidth:1];
    [[commentText layer] setCornerRadius:8];
	[commentText setTextColor:[UIColor whiteColor]];
    [self.view addSubview:commentText];
    
   
    
    NSString *ftrBtnImg = @"send_comment_img.png";
    UIButton *ftrBtnSend = [[UIButton alloc]initWithFrame:CGRectMake(0, 398, 320, 30)];
    [ftrBtnSend setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",ftrBtnImg]] forState:UIControlStateNormal];
    [ftrBtnSend setBackgroundColor:[UIColor grayColor]];
    [ftrBtnSend setTitle:@"SEND COMMENT FOR IMAGE" forState:UIControlStateNormal];
    ftrBtnSend.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [ftrBtnSend  addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ftrBtnSend];
    
    
    rateStarEmpty = @"star_rate_empty.png";
    rateStarFull = @"star_rate_full.png";
    rateUpImg = @"star_rate_empty.png";
    rateDnImg = @"star_rate_full.png";
    
    rateBtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    rateBtnOne.frame = CGRectMake(170, 258, 20, 20);
    [rateBtnOne setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:
	 UIControlStateNormal];
	[rateBtnOne setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState: UIControlStateHighlighted];
	[rateBtnOne addTarget:self action:@selector(rateIt:) forControlEvents:UIControlEventTouchUpInside];
    rateBtnOne.tag = 0;
	[self.view addSubview:rateBtnOne];
    
    rateBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    rateBtnTwo.frame = CGRectMake(200, 258, 20, 20);
    [rateBtnTwo setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:
	 UIControlStateNormal];
    rateBtnTwo.tag = 1;
	[rateBtnTwo setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateDnImg]] forState: UIControlStateHighlighted];
	[rateBtnTwo addTarget:self action:@selector(rateIt:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:rateBtnTwo];
    
    rateBtnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    rateBtnThree.frame = CGRectMake(230, 258, 20, 20);
    [rateBtnThree setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:
	 UIControlStateNormal];
	[rateBtnThree setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState: UIControlStateHighlighted];
	[rateBtnThree addTarget:self action:@selector(rateIt:) forControlEvents:UIControlEventTouchUpInside];
    rateBtnThree.tag = 2;
	[self.view addSubview:rateBtnThree];
    
    rateBtnFour = [UIButton buttonWithType:UIButtonTypeCustom];
    rateBtnFour.frame = CGRectMake(260, 258, 20, 20);
    [rateBtnFour setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:
	 UIControlStateNormal];
	[rateBtnFour setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState: UIControlStateHighlighted];
	[rateBtnFour addTarget:self action:@selector(rateIt:) forControlEvents:UIControlEventTouchUpInside];
    rateBtnFour.tag = 3;
	[self.view addSubview:rateBtnFour];
    
    rateBtnFive = [UIButton buttonWithType:UIButtonTypeCustom];
    rateBtnFive.frame = CGRectMake(290, 258, 20, 20);
    [rateBtnFive setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:
	 UIControlStateNormal];
	[rateBtnFive setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState: UIControlStateHighlighted];
	[rateBtnFive addTarget:self action:@selector(rateIt:) forControlEvents:UIControlEventTouchUpInside];
    rateBtnFive.tag = 4;
	[self.view addSubview:rateBtnFive];

    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
   

    
    Settings_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Settings_btn.frame = CGRectMake(275, 10, 40, 40);
    [Settings_btn setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:
	 UIControlStateNormal];
    [Settings_btn addTarget:self action:@selector(SettingsView:) forControlEvents:UIControlEventTouchUpInside];
    Settings_btn.tag = 0;
	[self.view addSubview:Settings_btn];

    Back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Back_btn.frame = CGRectMake(10, 13, 35, 35);
    [Back_btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:
	 UIControlStateNormal];
	[Back_btn addTarget:self action:@selector(PrevView:) forControlEvents:UIControlEventTouchUpInside];
    Back_btn.tag = 0;
	[self.view addSubview:Back_btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            blockLabel.text = @"Block Says Reachable";
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
    
    
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        failed=NO;
    }
    else
    {
        if(!failed)
        {
            [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
            
            [alert show];
            failed=YES;
        }
        
    }
}


-(void)SettingsView: (id)sender
{
    Settings *obj =[[Settings alloc]initWithNibName:@"Settings" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    obj.viewNum=3;
}

-(void)PrevView: (id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)submit
{
    comments=commentText.text;
    
    NSString *urlText = [NSString stringWithFormat:@"http://192.168.123.120/projects/slidemovieapp/comments.php?story_id=%@&comments=%@&rate=%@",story_id, comments,rate];
    
    NSString* urlTextEscaped = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlTextEscaped];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString: urlTextEscaped]];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    

}



-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [commentText resignFirstResponder];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [imageMutableData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imageMutableData appendData:data];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    if(!failed)
    {
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
    
    [alert show];
        failed=YES;
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)willRotateToOrientation:(UIInterfaceOrientation)newOrientation {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        if (newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight) {
            
            //set your landscap View Frame
            playery=0;
            playerWidth=480;
            playerHeight=320;
            [self supportedInterfaceOrientations];
            
        }
        
        
        
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        if(newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown){
            //set your Potrait View Frame
            playery=30;
            playerWidth=320;
            playerHeight=230;
            [self supportedInterfaceOrientations];
            
        }
    }
    // Handle rotation
}


-(void)viewWillAppear:(BOOL)animated
{
    [self willRotateToOrientation:[[UIDevice currentDevice] orientation]];
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] statusBarOrientation];
    [[UIDevice currentDevice] orientation];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
   ;
}

-(void)deviceRotated:(NSNotification*)notification
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //Do your stuff for landscap
        Settings_btn.hidden=true;
        Back_btn.hidden=true;
        rateBtnOne.hidden=true;
        rateBtnTwo.hidden=true;
        rateBtnThree.hidden=true;
        rateBtnFour.hidden=true;
        rateBtnFive.hidden=true;
           }
    else if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //Do your stuff for potrait
        Settings_btn.hidden=false;
        Back_btn.hidden=false;
        rateBtnOne.hidden=false;
        rateBtnTwo.hidden=false;
        rateBtnThree.hidden=false;
        rateBtnFour.hidden=false;
        rateBtnFive.hidden=false;
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *responseString=[[NSString alloc]initWithData:imageMutableData encoding:NSUTF8StringEncoding];
    self.imageMutableData=nil;
    image_array=[responseString JSONValue];
    [image_tabledata addObjectsFromArray:image_array];
   
    storyScollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,playery,playerWidth,playerHeight)];
    storyScollview.contentSize = CGSizeMake(320*[image_tabledata count], playerHeight);
    storyScollview.userInteractionEnabled=TRUE;
    storyScollview.pagingEnabled = TRUE;
    storyScollview.scrollEnabled = TRUE;
    storyScollview.backgroundColor = [UIColor clearColor];
    storyScollview.showsVerticalScrollIndicator=NO;
    storyScollview.showsHorizontalScrollIndicator=NO;
    storyScollview.delegate=self;
    [self.view addSubview:storyScollview];
    for (int j=0; j<[image_tabledata count]; j++) {
        path=[[image_tabledata objectAtIndex:j] objectForKey:@"image_path"];
        story_id=[[image_tabledata objectAtIndex:j]objectForKey:@"story_id"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
        
        storyImgView=[[UIImageView alloc] initWithImage:image];
        [storyImgView setFrame:CGRectMake(x, playery, playerWidth, playerHeight)];
        [storyScollview addSubview:storyImgView];
        x=j*320;
    }
    path=[[image_tabledata objectAtIndex:0] objectForKey:@"image_path"];
    story_id=[[image_tabledata objectAtIndex:0]objectForKey:@"story_id"];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
    
    storyImgView=[[UIImageView alloc] initWithImage:image];
    [storyImgView setFrame:CGRectMake(0, playery, playerWidth, playerHeight)];
    [storyScollview addSubview:storyImgView];
    sound=[[image_tabledata objectAtIndex:0]objectForKey:@"image_sound"];
    NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sound]];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 1.0f;
    [audioPlayer prepareToPlay];
    audioPlayer.delegate=self;
    if (audioPlayer == nil)
        NSLog(@"%@", [error description]);
    else
        [audioPlayer play];

    
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];

}





- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(i<[image_tabledata count])
    {
    i++;
        x=i*320;
        path=[[image_tabledata objectAtIndex:i] objectForKey:@"image_path"];
        story_id=[[image_tabledata objectAtIndex:i]objectForKey:@"story_id"];
        sound=[[image_tabledata objectAtIndex:i]objectForKey:@"image_sound"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
        storyImgView=[[UIImageView alloc] initWithImage:image];
        [storyImgView setFrame:CGRectMake(x, playery, playerWidth, playerHeight)];
        [storyScollview addSubview:storyImgView];
        NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sound]];
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
        audioPlayer.numberOfLoops = 0;
        audioPlayer.volume = 1.0f;
        [audioPlayer prepareToPlay];
        audioPlayer.delegate=self;
        if (audioPlayer == nil)
            NSLog(@"%@", [error description]);
        else
            [audioPlayer play];

    }
}


-(void)rateIt:(id)sender{
    UIButton *rating = (UIButton *) sender;
    NSArray *btn = [[NSArray alloc] initWithObjects:rateBtnOne,rateBtnTwo,rateBtnThree,rateBtnFour,rateBtnFive, nil];
    int r=0;
    for (int i = 0; i<=4; i ++) {
        if(i <= rating.tag){
            if(i == rating.tag){
                if ([sender isSelected]) {
                    [sender setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:UIControlStateNormal];
                    [sender setSelected:NO];
                    
                }else{
                    r++;
                    [sender setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateDnImg]] forState:UIControlStateSelected];
                    [sender setSelected:YES];
                }
            }else{
                r++;
                [[btn objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateDnImg]] forState:UIControlStateSelected];
                [[btn objectAtIndex:i] setSelected:YES];
            }
        }else{
            [[btn objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rateUpImg]] forState:UIControlStateNormal];
            [[btn objectAtIndex:i] setSelected:NO];
            
        }
    }
    
    self.rate = [NSString stringWithFormat:@"%i",r];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
