//
//  XMLParser.m
//  Milestone 5
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import "XMLParser.h"
#import "SearchViewController.h"

@implementation XMLParser

@synthesize artistName;
@synthesize eventDate;
@synthesize eventUrl;
@synthesize venueCity;
@synthesize venueName;
@synthesize venueState;
@synthesize venueZip;
@synthesize delegate;
@synthesize currentItemDict;

// initialize parser
- (XMLParser *) initXMLParserWithUrlConnection:(NSString *)urlAPI{
    
    self = [super init];
    _urlAPI = urlAPI;
    _responseData = [NSMutableData data];
    _itemArray = [[NSMutableArray alloc]init];
    currentItemDict = [[NSMutableDictionary alloc]init];

    return self;
}

// parse xml into itemArray
- (void) loadDataFromAPI{
    
    [spinner startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlAPI] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    //Make connection and retrieve data
    _urlAPIConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!_urlAPIConnection) {
        [self fetchFailed];
    }
}

/**
 
 @param
 @return
 */
- (void)parseAPIData{
    
    NSString *oldStr = [[NSString alloc] initWithData:_responseData encoding:NSWindowsCP1251StringEncoding];
    NSString *newStr = [oldStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1252\"" withString:@""];
    NSData *newData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //Create a new Parser
    NSXMLParser *newParser = [[NSXMLParser alloc] initWithData:newData];
    newParser.delegate = self;
    newParser.shouldResolveExternalEntities = NO;
    newParser.shouldProcessNamespaces = NO;
    newParser.shouldReportNamespacePrefixes = NO;
    _xmlParser = newParser;
       if(![_xmlParser parse]){
        //NSLog(@"Error in parse method call. error = %@ lineNumber = %d ", [_xmlParser parserError], [_xmlParser lineNumber]);
    }
    
}

#pragma mark- NSXMLParserDelegate delegate methods
-(void) parseDidStartDocument:(NSXMLParser *) parser{
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
   
    [delegate didLoadFeed:_itemArray];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSString *errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %d) on line %d", [parseError code], [parser lineNumber]];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _currentElementValue = elementName;
    if ([elementName isEqualToString:@"event"]) {
        // Add items to the dictionary
        self.currentItemDict = [NSMutableDictionary dictionary];
        self.artistName = [NSMutableString string ];
        self.venueName = [NSMutableString string];
        self.venueCity = [NSMutableString string];
        self.venueState = [NSMutableString string];
        self.venueZip = [NSMutableString string];
        self.eventUrl = [NSMutableString string];
        self.eventDate = [NSMutableString string];
        self.ticketUrl = [NSMutableString string];
        
    }
}


-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    if ([self.currentElementValue isEqualToString:@"artist_name"]) {
        [self.artistName appendString:string];
    }
    else if([self.currentElementValue isEqualToString:@"venue_name"]){
        [self.venueName appendString:string];
    }
    else if([self.currentElementValue isEqualToString:@"venue_city"]){
        [self.venueCity appendString:string];
    }
    else if([self.currentElementValue isEqualToString:@"venue_state"]){
        [self.venueState appendString:string];
    }
    else if([self.currentElementValue
            isEqualToString:@"venue_zip"]){
        [self.venueZip appendString:string];
    }
    else if([self.currentElementValue isEqualToString:@"event_url"]){
        [self.eventUrl appendString:string];
    }
    else if([self.currentElementValue
            isEqualToString:@"ticket_url"]){
        [self.ticketUrl appendString:string];
    }
    else if([self.currentElementValue isEqualToString:@"event_date"]){
        [self.eventDate appendString:string];
    }
}


-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"event"]) {
        [currentItemDict setObject:self.artistName forKey:@"artist_name"];
        [currentItemDict setObject:[self flattenHTML:self.venueName ] forKey:@"venue_name"];
        [currentItemDict setObject:[self flattenHTML:self.venueCity ] forKey:@"venue_city"];
        [currentItemDict setObject:[self flattenHTML:self.venueState ] forKey:@"venue_state"];
        [currentItemDict setObject:[self flattenHTML:self.venueZip ] forKey:@"venue_zip"];
        [currentItemDict setObject:[self flattenHTML:self.eventUrl ] forKey:@"event_url"];
        [currentItemDict setObject:[self flattenHTML:self.ticketUrl ] forKey:@"ticket_url"];
        [currentItemDict setObject:[self flattenHTML:self.eventDate ] forKey:@"event_date"];
        
        //Create a dictionary
        NSMutableDictionary *tempDict = [self.currentItemDict copy];
        [_itemArray addObject:tempDict];
    }
}

-(NSString *)flattenHTML:(NSString *)html{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        //find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL];
        //find end of tag
        [theScanner scanUpToString:@">" intoString:&text];
        //replace front tag with nothing
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text ] withString:@""];
    } // while ends
    return html;
}



-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // NSLog(@"didReceiveData - data= %@ ", data);
    [_responseData appendData:data];
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error{
    [spinner stopAnimating];
    [self fetchFailed];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection{
    [self parseAPIData];
}

-(void) fetchFailed{
    [_urlAPIConnection cancel];
    NSString *errorString = [NSString stringWithFormat:@"Unable to connect to %@ ", _urlAPI];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

@end
