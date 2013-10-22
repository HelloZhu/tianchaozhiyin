//
//  MusicDataManager.h
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "config.h"
#import "ChannelsInfo.h"
#import "SongInfo.h"
#import "SongIrc.h"


@interface MusicDataManager : NSObject

@property(nonatomic,strong) NSMutableArray *channelsArray;
@property(nonatomic,strong) ChannelsInfo *currentChannel;
@property(nonatomic,strong) NSMutableArray *currentSongListArray;
@property(nonatomic,strong) SongIrc *currentSongLrc;

- (id)init;
+ (instancetype)shareDataManager;

//解析频道列表数据
-(void)fetchChannelData:(void (^)(void))block;

//返回频道列表数据
- (NSArray *)channelList;

//解析歌曲列表数据
- (void)fetchCurrentSongListData;

- (NSArray *)currentSongList;

- (void)fetchSongLrc:(SongInfo *)currentSong;

- (void)hiddenLrc;


@end
