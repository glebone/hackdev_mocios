//
//  AlbumListViewController.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumListViewController.h"
#import "DataManager.h"
#import "Constants.h"

#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"

#import "AlbumListCell.h"

@interface AlbumListViewController ()
{
    NSArray *_albums;
}

@end

@implementation AlbumListViewController
@synthesize albums = _albums;

- (void)dealloc {
    [_tableView release];
    [_albums release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DataManager sharedManager] getAlbumList];
}

- (void)viewDidUnload
{
    [_tableView release];
    _tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_albums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"albumCellIdentifier";
    AlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    GDataEntryPhotoAlbum *album = [_albums objectAtIndex:indexPath.row];
    GDataTextConstruct *titleTextConstruct = [album title];
    GDataMediaDescription *description = [[album mediaGroup] mediaDescription];
    cell.descriptionLabel.text = [description contentStringValue];
    
    NSString *title = [titleTextConstruct stringValue];
    cell.titleLabel.text = title;
    cell.thumbnailImageView.image = [UIImage imageNamed:@"ScrapbookPhotos.jpeg"];
    [cell setNeedsLayout];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[DataManager sharedManager] getPhotosFromAlbumAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (void)albumListFetchOk:(NSNotification *)notification
{
    NSDictionary *d = [notification object];
    if (![d isKindOfClass:[NSDictionary class]]) return;

    [_albums release];
    GDataFeedPhotoUser *album = [d objectForKey:ALBUMS_KEY];
    _albums = [[album entries] copy];
    
    [_tableView reloadData];
}

- (void)requestFailure:(NSNotification *)notification
{
    NSString *d = [notification object];
    if (![d isKindOfClass:[NSString class]]) return;
}

@end
