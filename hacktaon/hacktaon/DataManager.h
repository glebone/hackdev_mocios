//
//  DataManager.h
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDataServiceGooglePhotos;
@class GDataFeedPhotoAlbum;
@class GDataFeedPhotoUser;

@interface DataManager : NSObject
+ (DataManager *)sharedManager;
- (void)setUserName:(NSString *)uName andPassword:(NSString *)pass;
- (void)getAlbumList;
- (void)getPhotosFromAlbumAtIndex:(int)index;
- (NSMutableArray *)photoLinks;
- (void)getThumbnails;

@property(nonatomic, retain) GDataServiceGooglePhotos *service;
@property(nonatomic, retain) GDataFeedPhotoUser *albumsFeed;
@property(nonatomic, retain) GDataFeedPhotoAlbum *photosFeed;


@end
