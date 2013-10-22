//
//  FileListViewController.m
//  mymusic3
//
//  Created by apple on 13-10-4.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "FileListViewController.h"
#import "AFNetworking.h"
#import "ItemCell.h"
#import "SongListViewController.h"
#import "MusicDataManager.h"
#import "ChannelsInfo.h"
#import "mainViewController.h"
#import "PPRevealSideViewController.h"

@interface FileListViewController ()
{
    NSArray *_channelListArray;
    mainViewController *_mainCtrl;
}
@end

@implementation FileListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.tableView.separatorColor=[UIColor grayColor];
    
    _channelListArray=[[MusicDataManager shareDataManager] channelList];
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return [_channelListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   
   
    ItemCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell=[[ItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.channelName.font=[UIFont systemFontOfSize:13];
        
    }
    
   
    cell.playImageView.tag=indexPath.row;
    if (indexPath.row == [_channelListArray indexOfObject:[MusicDataManager shareDataManager].currentChannel]) {
        [cell.playImageView startAnimating];
        cell.playImageView.hidden = NO;
    }else {
        [cell.playImageView stopAnimating];
        cell.playImageView.hidden = YES;
    }
    
    ChannelsInfo *channel=[_channelListArray objectAtIndex:indexPath.row];
    cell.channelName.text=channel.name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChannelsInfo *channel=[_channelListArray objectAtIndex:indexPath.row];
    
    
    [MusicDataManager shareDataManager].currentChannel=channel;

    
    PPRevealSideViewController *sideCtrl=(PPRevealSideViewController *)[[UIApplication sharedApplication]keyWindow].rootViewController;
    UINavigationController *nav=(UINavigationController *) sideCtrl.rootViewController;
    _mainCtrl=[nav.viewControllers lastObject];
    [self.revealSideViewController popViewControllerAnimated:YES];
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.backgroundColor=[UIColor grayColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(210, 30, 100, 30)];
    label.text=@"频道列表";
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    
    return view;
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

 


@end
