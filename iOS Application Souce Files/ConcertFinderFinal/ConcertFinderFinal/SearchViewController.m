//
//  SearchViewController.m
//  Milestone 5
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import "SearchViewController.h"
#import "XMLParser.h"

@implementation SearchViewController


@synthesize tableData;
@synthesize theSearchBar;
@synthesize theTableView;
@synthesize concertResults;
@synthesize artistToBeSearched;
@synthesize concertIndexNumber;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if(self){
        UITabBarItem *tabBarItem = [self tabBarItem];
        [tabBarItem setTitle:@"Search by Artist"];
        tabBarItem.image = [UIImage imageNamed:@"search.png"];
     }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theSearchBar.delegate = self;
	
    self.tableData =[[NSMutableArray alloc]init];

    [self.theTableView registerNib:[UINib nibWithNibName:@"ConcertCell" bundle:nil]
         forCellReuseIdentifier:@"ConcertCell"];
    
    NSString *defaultURL = @"http://api.jambase.com/search?city=rochester&apikey=qe6kmyzzdeaw4abk434jzyzg";
    
    _parser = [[XMLParser alloc]initXMLParserWithUrlConnection:defaultURL];
    _parser.delegate = self;
    [_parser loadDataFromAPI];
    
    [self.theTableView reloadData];
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
    
	[self resignFirstResponder];
	}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Artist Search";
}

#pragma mark - the search bar delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.theTableView.allowsSelection = NO;
    self.theTableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
}

-(void)didLoadFeed:(NSMutableArray *) concertResultsArray{
    concertResults = concertResultsArray;
    [theSearchBar resignFirstResponder];
    [self.theTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
    artistToBeSearched = searchBar.text;
    
    // JamBase API credentials
    NSString *apiURL = @"http://api.jambase.com/search?band=";
    NSString *apiKey = @"&apikey=qe6kmyzzdeaw4abk434jzyzg";
    NSString *apiArtist = [ artistToBeSearched stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *myURL = [NSString stringWithFormat:@"%@%@%@",apiURL,apiArtist,apiKey];

    _parser = [[XMLParser alloc]initXMLParserWithUrlConnection:myURL];
    _parser.delegate = self;
    [_parser loadDataFromAPI];
    
    [self.theTableView reloadData];
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
}

#pragma mark - the table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [concertResults count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIdentifier = @"ConcertCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.textLabel.text = [[concertResults objectAtIndex:indexPath.row] objectForKey:@"artist_name"];
    cell.detailTextLabel.text = [[concertResults objectAtIndex:indexPath.row] objectForKey:@"venue_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _concertDetail = [[ConcertDetailViewController alloc] initWithNibName:@"ConcertDetailViewController" bundle:nil];
    _concertDetail.selectedConcert = [concertResults objectAtIndex:indexPath.row];
    _concertDetail.searchType = YES;
    
    [self.navigationController pushViewController:_concertDetail animated:YES];
    
}

@end
