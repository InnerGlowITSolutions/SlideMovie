//
//  ViewController.m
//  SlideMovie
//
//  Created by Rejo Joseph on 10/01/14.
//  Copyright (c) 2014 InnerGlow. All rights reserved.
//

#import "ViewController.h"
#import "SubCategory.h"
#import "Settings.h"
#import "SBJson.h"
#import "Reachability.h"

@interface ViewController ()

@end

@implementation UINavigationController (RotationIn_IOS6)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject]  preferredInterfaceOrientationForPresentation];
}

@end

@implementation ViewController
@synthesize CategoryMutableData;
@synthesize CategoryTbl;
@synthesize CategoryView;
@synthesize m_SelectedIndexPath;
@synthesize searchBar;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    


    CategoryTbl.hidden=YES;
    
    Cat_array = [[NSMutableArray alloc] init];
    Cat_tabledata = [[NSMutableArray alloc] init];
    
  
    
    self.CategoryMutableData =[NSMutableData data];

    
    NSString *url = [NSString stringWithFormat:@"http://192.168.123.120/projects/slidemovieapp/"];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    
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
//    [searchBar bringSubviewToFront:imgtop];
   
    
    [self.navigationController setNavigationBarHidden:YES];
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
    new=[Cat_tabledata valueForKey:@"cat_name"];
    searchResult = [[new filteredArrayUsingPredicate:resultPredicte] mutableCopy];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self searchAllList ];
     [CategoryTbl reloadData];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    flag = 0;
    [CategoryTbl reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        failed=NO;
//        notificationLabel.text = @"Notification Says Reachable";
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

//        notificationLabel.text = @"Notification Says Unreachable";
    }
}


-(void)SettingsView: (id)sender
{
   Settings *obj =[[Settings alloc]initWithNibName:@"Settings" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    obj.viewNum=1;
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [CategoryMutableData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [CategoryMutableData appendData:data];
    
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
    
    NSString *responseString=[[NSString alloc]initWithData:CategoryMutableData encoding:NSUTF8StringEncoding];
    self.CategoryMutableData=nil;
    
    Cat_array=[(NSDictionary *)[responseString JSONValue] objectForKey:@"result"];
    [Cat_tabledata addObjectsFromArray:Cat_array];
    CategoryTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 270) style:UITableViewStylePlain];
    CategoryTbl.backgroundColor=[UIColor clearColor];
    [CategoryTbl setDelegate:self];
    [CategoryTbl setDataSource:self];
    [self.view addSubview:CategoryTbl];
    [CategoryTbl reloadData];
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag == 1){
        [self searchAllList ];
        return [searchResult count];
    }else{
     return [Cat_tabledata count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
   
    

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if (flag == 1){
        cell.textLabel.text = [searchResult objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }else if(flag == 0){
        cell.textLabel.text=[[Cat_tabledata objectAtIndex:indexPath.row]objectForKey:@"cat_name"];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
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
        SubCategory *fhview = [[SubCategory alloc] initWithNibName:@"SubCategory" bundle:nil];
        fhview.cat_name = [searchResult objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:fhview animated:YES];

        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else{
        
        SubCategory *detailViewController = [[SubCategory alloc] initWithNibName:@"SubCategory" bundle:nil];
        detailViewController.cat_name=[[Cat_tabledata objectAtIndex:indexPath.row]objectForKey:@"cat_name"];
        //Pass the selected object to the new view controller.
        detailViewController.m_SelectedIndexPath=indexPath.row+1;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
