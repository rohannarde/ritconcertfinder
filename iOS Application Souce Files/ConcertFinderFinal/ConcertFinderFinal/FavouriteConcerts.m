//
//  FavouriteConcerts.m
//  ConcertFinder
//
//  Created by avanti sardesai on 11/13/12.
//  Copyright (c) 2012 Amit Shroff, Rohan Narde. All rights reserved.
//

#import "FavouriteConcerts.h"

static NSString * const kFavouriteConcert = @"FavouriteConcerts";
static NSString * const kDirectoryName = @"Favourites";

@implementation FavouriteConcerts
@synthesize favouriteConcerts;

- (id) init{
    
    self = [super init];
    
    if(self){
        
        favouriteConcerts = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        
        favouriteConcerts = [aDecoder decodeObjectForKey:kFavouriteConcert];
        
    }
    return self;
    
}

- (void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:favouriteConcerts forKey:kFavouriteConcert];
    
}

@end
