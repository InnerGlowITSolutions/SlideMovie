//
//  SubCategory.m
//  SlideMovie
//
//  Created by Kams on 1/16/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import "SubCategory.h"
#import "SBJson.h"
#import "Settings.h"
#import "Story.h"
#import "ViewController.h"
#import "Reachability.h"

@interface SubCategory ()

@end

@implementation SubCategory

@synthesize storyMutableData;
@synthesize storyTbl;
@synthesize storyView;
@synthesize m_SelectedIndexPath;
@synthesize cat_name;
@synthesize searchBar;

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
	
    storyTbl.hidden=YES;
    story_array = [[NSMutableArray alloc] init];
    story_tabledata = [[NSMutableArray alloc] init];
    
    
    
    self.storyMutableData =[NSMutableData data];
    
    
    NSString *urlText = [NSString stringWithFormat:@"http://192.168.123.120/projects/slidemovieapp/stories.php?cat_name=%@",cat_name];
    NSString* urlTextEscaped = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlTextEscaped];

    

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString: urlTextEscaped]];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    
    
    
    myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Loading", nil) message:NSLocalizedString(@"\n\n", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [myAlertView show];
    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loading.center = CGPointMake(myAlertView.bounds.size.width * 0.5f, myAlertView.bounds.size.height * 0.5f);
    [loading startAnimating];
    [myAlertView addSubview:loading];
    
    Settings_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Settings_btn.frame = CGRectMake(275, 38, 40, 40);
    [Settings_btn setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:
	 UIControlStateNormal];
    [Settings_btn addTarget:self action:@selector(SettingsView:) forControlEvents:UIControlEventTouchUpInside];
    Settings_btn.tag = 0;
	[self.view addSubview:Settings_btn];
    
    Back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Back_btn.frame = CGRectMake(10, 40, 35, 35);
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


- (BOOL)shouldAutorotate
{
    //returns true if want to allow orientation change
    return FALSE;
    
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskAll;
    
    
}

-(void)searchAllList{
    
    flag = 1;
    searchResult = nil;
    NSPredicate *resultPredicte = [NSPredicate predicateWithFormat:@"SELF contains [search] %@",searchBar.text];
    NSMutableArray *new=[[NSMutableArray alloc]init];
    new=[story_tabledata valueForKey:@"story_name"];
    searchResult = [[new filteredArrayUsingPredicate:resultPredicte] mutableCopy];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self searchAllList ];
    [storyTbl reloadData];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    flag = 0;
    [storyTbl reloadData];
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
    obj.viewNum=2;
}

-(void)PrevView: (id)sender
{
    ViewController *obj =[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    //[self.navigationController popToViewController:obj animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [storyMutableData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [storyMutableData appendData:data];
    
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



-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    
    NSString *responseString=[[NSString alloc]initWithData:storyMutableData encoding:NSUTF8StringEncoding];
    self.storyMutableData=nil;
    story_array=[(NSDictionary *)[responseString JSONValue] objectForKey:@"stories"];
    [story_tabledata addObjectsFromArray:story_array];
    storyTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 270) style:UITableViewStylePlain];
    storyTbl.backgroundColor=[UIColor clearColor];
    [storyTbl setDelegate:self];
    [storyTbl setDataSource:self];
    [self.view addSubview:storyTbl];
    [storyTbl reloadData];
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (flag == 1){
        [self searchAllList ];
        return [searchResult count];
    }else{
    return [story_tabledata count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (flag == 1){
        cell.textLabel.text = [searchResult objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }else if(flag == 0){
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text=[[story_tabledata objectAtIndex:indexPath.row]objectForKey:@"story_name"];
    Story *name;
    name.story_name=cell.textLabel.text;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setFrame:CGRectMake(100,0,55,55)];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSString *object= nil;
    
    NSIndexPath *indexPathID = nil;
    if (self.searchDisplayController.isActive) {
        
        indexPath = [[self.searchDisplayController searchResultsTableView ]indexPathForSelectedRow];
        indexPathID = [[self.searchDisplayController searchResultsTableView ]indexPathForSelectedRow];
        object = searchResult [indexPath.row];
        Story *fhview = [[Story alloc] initWithNibName:@"Story" bundle:nil];
        fhview.story_name = [searchResult objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:fhview animated:YES];
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else{

    Story *detailViewController = [[Story alloc] initWithNibName:@"Story" bundle:nil];
    detailViewController.story_name=[[story_tabledata objectAtIndex:indexPath.row]objectForKey:@"story_name"];

    //Pass the selected object to the new view controller.
    detailViewController.m_SelectedIndexPath_story=indexPath.row+1;
    [self.navigationController pushViewController:detailViewController  animated:YES];        
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

