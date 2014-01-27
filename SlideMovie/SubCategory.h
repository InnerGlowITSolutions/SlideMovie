//
//  SubCategory.h
//  SlideMovie
//
//  Created by Kams on 1/16/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCategory : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    
    UITableView *storyTbl;
    NSMutableData *storyMutableData;
    UIView *storyView;
    NSMutableArray *story_array, *story_tabledata;
    UIAlertView *myAlertView;
    UIActivityIndicatorView *loading;
    NSString *cat_name;
    int *m_SelectedIndexPath;
    UIButton *Settings_btn;
    UIButton *Back_btn;
    BOOL failed;
    int flag;
    NSMutableArray *searchResult;
    
    
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic, readwrite)NSString *cat_name;
@property(nonatomic, assign)int *m_SelectedIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *storyTbl;
@property (nonatomic,retain) NSMutableData *storyMutableData;
@property (strong, nonatomic) IBOutlet UIView *storyView;

@end
