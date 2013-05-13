//
//  MCProjectAppDelegate.h
//  ConcertFinder
//
//  Copyright (c) 2012 Amit Shroff, Rohan Narde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@interface MCProjectAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MapViewController *mapViewController;

@end
