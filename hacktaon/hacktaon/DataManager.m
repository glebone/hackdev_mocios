//
//  DataManager.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"
//
#import "GDataServiceGooglePhotos.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"


static DataManager *_sharedManager = nil;

@interface DataManager()
{
    GDataServiceGooglePhotos *_service;
    NSArray                  *_albums;
    NSArray                  *_photos;
}

@end


@implementation DataManager
@synthesize service = _service;
@synthesize albums = _albums;
@synthesize photos = _photos;

+ (DataManager *)sharedManager
{
    if (_sharedManager == nil) {
        _sharedManager = [[DataManager alloc] init];
    }
    return _sharedManager;
}
-(id)init
{
    self = [super init];
    if (self) {
        self.service = [[GDataServiceGooglePhotos alloc] init];
    }
    return self;
}
-(void)dealloc
{
    [_service release];
    [_albums release];
    [super dealloc];
}

- (void)setUserName:(NSString *)uName andPassword:(NSString *)pass
{
    [_service setUserCredentialsWithUsername:uName password:pass];
}
- (void)getAlbumList
{
    [self setAlbums:nil];
    
    GDataServiceTicket *ticket;
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:_service.username
                                                             albumID:nil
                                                           albumName:nil
                                                             photoID:nil
                                                                kind:nil
                                                              access:nil];
    ticket = [_service fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(albumListFetchTicket:finishedWithFeed:error:)];
}
- (void)albumListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedPhotoUser *)feed
                       error:(NSError *)error {
    if (error == nil) {  
        NSArray *entries = [feed entries];
        [self setAlbums:entries];
        
        NSLog(@"entries %i", [entries count]);
        if ([entries count] > 0) {
            
            for (int i = 0; i < [entries count]; i++) {
                GDataEntryPhotoAlbum *firstCalendar = [entries objectAtIndex:i];
                GDataTextConstruct *titleTextConstruct = [firstCalendar title];
                NSString *title = [titleTextConstruct stringValue];
                
                NSLog(@"title: %@ photosUsed:%@", title , [[firstCalendar photosUsed] stringValue]);
            }
        } else {
            NSLog(@"No Albums");
        }
    } else {
        NSLog(@"Error: %@", error);
    }
}

- (void)fetchPhotosFromAlbumAtIndex:(int)index {
    
    if (!([_albums count] > 0 && index > -1)) return;
    GDataEntryPhotoAlbum *album = [_albums objectAtIndex:index];
    if (album) {
        NSURL *feedURL = [[album feedLink] URL];
        if (feedURL) {
            [self setPhotos:nil];

            GDataServiceTicket *ticket;
            ticket = [_service fetchFeedWithURL:feedURL
                                      delegate:self
                             didFinishSelector:@selector(photosTicket:finishedWithFeed:error:)];
//            [self setPhotoFetchTicket:ticket];
//            
//            [self updateUI];
        }
    }
}

- (void)photosTicket:(GDataServiceTicket *)ticket
    finishedWithFeed:(GDataFeedPhotoAlbum *)feed
               error:(NSError *)error {
    if (error == nil) {  
        NSArray *entries = [feed entries];
        [self setPhotos:entries];
        
        NSLog(@"LINKS: \n %@", [self photoLinks]);
        
        if ([entries count] > 0) {

        } else {
            NSLog(@"No Photos");
        }
    } else {
        NSLog(@"Error: %@", error);
    }
}

- (NSMutableArray *)photoLinks
{
    NSMutableArray *links = [NSMutableArray array];
    int photosCount = [_photos count];
    for (int i = 0; i < photosCount; i++) {
        GDataEntryPhoto *photo = [_photos objectAtIndex:i];
        GDataEntryContent *c = [photo content];
        [links addObject:c.sourceURL];
    }
    return links;
}
@end
