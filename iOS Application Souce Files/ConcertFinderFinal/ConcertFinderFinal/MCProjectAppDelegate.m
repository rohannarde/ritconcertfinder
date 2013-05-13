//
//  MCProjectAppDelegate.m
//  ConcertFinder
//
//  Copyright (c) 2012 Amit Shroff, Rohan Narde. All rights reserved.
//

#import "MCProjectAppDelegate.h"

#import "MapViewController.h"
#import "SearchViewController.h"
#import "XMLParser.h"
#import "FavouriteConcerts.h"
#import "IpodLibraryViewController.h"
#import "CitySearchViewController.h"


static NSString * const kFavouriteConcert = @"FavouriteConcerts";
@implementation MCProjectAppDelegate
@synthesize mapViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Creating tab view objects for views
    MapViewController *mapView = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    self.mapViewController = mapView;
   
    //Load Data
    NSString *path = [self pathToFavourites];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:path error:&error];
    
    if(dirContents.count > 0){
    NSString *favouritesPath = [path stringByAppendingPathComponent:[dirContents objectAtIndex:0]];
    FavouriteConcerts *favourite = [NSKeyedUnarchiver unarchiveObjectWithFile:favouritesPath];
        for(int i=0;i<favourite.favouriteConcerts.count;i++){
            
            [mapView.favoriteConcerts addObject:[favourite.favouriteConcerts objectAtIndex:i]];
        }
        
    
    }
    // Here we create all the view controller objects and add them to the root tab view.
    SearchViewController *searchView = [[SearchViewController alloc] init];
    
    UINavigationController *mainView = [[UINavigationController alloc] initWithRootViewController:searchView];
    
    
    UINavigationController *tabMapView = [[UINavigationController alloc] initWithRootViewController:mapView];
    
    
    IpodLibraryViewController *ipodViewController = [[IpodLibraryViewController alloc] initWithNibName:(@"IpodLibraryViewController") bundle:nil];
    
    UINavigationController *ipodTabView = [[UINavigationController alloc]initWithRootViewController:ipodViewController];
    
    CitySearchViewController *citySearchViewController = [[CitySearchViewController alloc]init];
    
    UINavigationController *citySearchTabView = [[UINavigationController alloc]initWithRootViewController:citySearchViewController];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:mainView, citySearchTabView, tabMapView, ipodTabView, nil];
    [tabBarController setViewControllers:viewControllers];
    [[self window] setRootViewController:tabBarController];
    
        
    [self.window makeKeyAndVisible];
   
     
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    NSString *path = [self pathToFavourites];
   
     NSString *favouritePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"favourite.plist"]];
    FavouriteConcerts *saveFavourties = [[FavouriteConcerts alloc]init];
    saveFavourties.favouriteConcerts = mapViewController.favoriteConcerts;
    
    [NSKeyedArchiver archiveRootObject:saveFavourties toFile:favouritePath];
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 This aids in saving and loading the list of favorite concerts.
 @param : none
 @return : path to favorite artist in the app sandbox
 */
- (NSString *)pathToFavourites{
    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    //Default path, enter the path for Default Inventory
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:kFavouriteConcert];
	
    
    NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
	{
        
        //Create inventory if not present
		[[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
		
        
		
	}
    return path;
}

@end
