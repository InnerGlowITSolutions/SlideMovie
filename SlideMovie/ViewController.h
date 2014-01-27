//
//  ViewController.h
//  SlideMovie
//
//  Created by Rejo Joseph on 10/01/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    
    BOOL reloaded;
    UITableView *CategoryTbl;
    NSMutableData *CategoryMutableData;
    UIView *CategoryView;
    NSMutableArray *Cat_array, *Cat_tabledata;
    UIAlertView *myAlertView;
    UIActivityIndicatorView *loading;
    UIButton *Settings_btn;
    int m_SelectedIndexPath;
    BOOL failed;
    int flag;
    NSMutableArray *searchResult;
    

}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, assign)int m_SelectedIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *CategoryTbl;
@property (nonatomic,retain) NSMutableData *CategoryMutableData;
@property (strong, nonatomic) IBOutlet UIView *CategoryView;

@end
