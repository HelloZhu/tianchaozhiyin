//
//  MusicDataManager.m
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "MusicDataManager.h"

@implementation MusicDataManager

- (id)init
{
    if (self=[super init]) {
        
        _channelsArray          =[NSMutableArray array];
        _currentSongListArray   =[NSMutableArray array];
        
    }
    return self;
}

+ (instancetype)shareDataManager
{
    static MusicDataManager *md=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        md=[[MusicDataManager alloc] init];
    });
    
    return md;
}

- (void)fetchChannelData:(void (^)(void))block
{
    NSURL *url=[NSURL URLWithString:kChannelsListPath];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
           if (JSON) {
               
               [_channelsArray removeAllObjects];
            
               NSArray *array=[JSON objectForKey:kchannelskey];
            
               for (NSDictionary *dict in array) {
                
                   [_channelsArray addObject:[ChannelsInfo channelWithDictionary:dict]];
                
               }
             
        }
        
        //回调
        if (block) {
            block();
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
      
        NSLog(@"channel error-%@",error);
    }];
    
    [operation start];
}

- (void)fetchCurrentSongListData
{
    
    NSString *path=[NSString stringWithFormat:@"%@%ld",kSongListPath,_currentChannel.channel_id];
    
    //NSLog(@"%@",path);
    NSURL *url=[NSURL URLWithString:path];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        if (JSON) {
            
            [_currentSongListArray removeAllObjects];
            
            NSArray *array=[JSON objectForKey:@"song"];
            
            for (NSDictionary *dict in array) {
                
                [_currentSongListArray addObject:[[SongInfo alloc] initWithDictionnary:dict]];
            }
            
            
            
        }
        
        //通知界面，频道发生改变
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeChannelNotification object:self userInfo:nil];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"songList error-%@",error);
    }];
    
    [operation start];
    
}


- (void)hiddenLrc
{
    NSURL *url=[NSURL URLWithString:@"https://github.com/HelloZhu/hiddenLrc/raw/master/Lrc.json"];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    NSLog(@"rererere===%@",request);
   
    
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
       
        if (JSON) {
            
            NSLog(@"%@",JSON);
            
            //通知界面，影藏或显示歌词
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenLrcNotifi" object:self userInfo:nil];
        }
        
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
       
        NSLog(@"error--%@",error);
        
        if (JSON) {
            
            NSLog(@"%@",JSON);
            
            //通知界面，影藏或显示歌词
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenLrcNotifi" object:self userInfo:nil];
        }
        
    }];
    
    [operation start];
    
}

- (NSArray *)channelList
{
    
    return _channelsArray;
}

- (void)setCurrentChannel:(ChannelsInfo *)currentChannel
{
    _currentChannel=currentChannel;
    
    
    [self fetchCurrentSongListData];
}

- (NSArray *)currentSongList
{
    
    return  _currentSongListArray;
}

//解析歌词
- (void)fetchSongLrc:(SongInfo *)currentSong
{
    
    NSString *name   =currentSong.title;
    NSString *artist =currentSong.artist;
     NSString *comp=[NSString stringWithFormat:@"%@/%@",name,artist];
    

    
    NSString *str=(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)comp, NULL,  CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    NSString *path=[NSString stringWithFormat:@"%@%@",kSongLRCPath,str];
    
    NSURL *url=[NSURL URLWithString:path];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
   // NSLog(@"%@",request);
    
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON) {
            
            NSArray *array=[JSON objectForKey:@"result"];
            
            if ([array count]) {
                
                NSDictionary *dict=[array objectAtIndex:0];
               // NSLog(@"%@",[dict objectForKey:@"song"]);
                _currentSongLrc=[[SongIrc alloc] initWithDictionary:dict];
     
                [[NSNotificationCenter defaultCenter] postNotificationName:kSongLrcNotifi object:nil userInfo:dict];
            }else{
            
                //无歌词通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kNOLrcNotifi object:nil userInfo:nil];
            }
           
        }else{
        
            //无歌词通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNOLrcNotifi object:nil userInfo:nil];
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    
    [operation start];

}

- (SongIrc *)currentSongLrc
{
    return _currentSongLrc;
}

@end
