//
//  Story.h
//  SlideMovie
//
//  Created by Kams on 1/16/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Story : UIViewController<UIScrollViewDelegate, UITextViewDelegate, NSURLConnectionDelegate, AVAudioPlayerDelegate>
{
    int *m_SelectedIndexPath_story;
    UIView *StoryView;
    UIImage *image;
    UIVideoEditorController *video;
    UIScrollView *storyScollview;
    UIWebView *webView;
    UIImageView *storyImgView;
    NSMutableData *imageMutableData;
    NSMutableArray  *image_tabledata;
    NSMutableArray *image_array;
    UIAlertView *myAlertView;
    NSString *path;
    NSString *sound;
    UIActivityIndicatorView *loading;
    int imageIndex;
    NSString *story_name;
    int pageOnScrollView;
    
    NSString *story_id;
    NSString *rateUpImg,*rateDnImg;
    UIButton *rateBtnOne,*rateBtnTwo,*rateBtnThree,*rateBtnFour,*rateBtnFive;
    NSString *rateStarFull, *rateStarEmpty;
    
    UITapGestureRecognizer *tapRecognizer;
    UIButton *Settings_btn;
    UIButton *Back_btn;
    BOOL failed;
    
    NSString *comments;
    
    int playerWidth, playerHeight, playery;
    BOOL playmovie;
    
    int i;
    int x;
    AVAudioPlayer *audioPlayer;
    
    int lastContentOffset;
}

-(void)unloadPreviousPage;
-(void)loadNextPage;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property(nonatomic, retain)NSString *rate;
@property(nonatomic, readwrite)NSString *story_name;
@property (strong, nonatomic) IBOutlet UIImageView *storyImgView;
@property (strong, nonatomic) IBOutlet UIView *StoryView;
@property (strong, nonatomic) IBOutlet UIScrollView *storyScollview;
@property(nonatomic, assign)int *m_SelectedIndexPath_story;
@property (nonatomic,retain) NSMutableData *imageMutableData;


@end