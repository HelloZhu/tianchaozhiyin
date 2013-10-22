//
//  config.h
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#ifndef mymusic3_config_h
#define mymusic3_config_h

//频道列表的path
#define kChannelsListPath      @"http://www.douban.com/j/app/radio/channels"

//歌曲列表的Path,需要channel_id;
#define kSongListPath          @"http://www.douban.com/j/app/radio/people?type=n&version=83&app_name=radio_iphone&channel="

//歌词path 例如 ：“http://geci.me/api/lyric/说谎/林宥嘉”
#define kSongLRCPath           @"http://geci.me/api/lyric/"


#define kchannelskey           @"channels"
//channel的名字的key
#define kchannelNamekey        @"name"

//歌曲信息的key
#define kalbumkey              @"album"
#define kpicturekey            @"picture"
#define kartistkey             @"artist"
#define kurlkey                @"url"
#define ktitlekey              @"title"
#define klengthkey             @"length"
#define kpublic_timekey        @"public_time"
#define kalbumtitlekey         @"albumtitle"
#define klikekey               @"like"

//通知
#define kChangeChannelNotification      @"songlistNotifi"
#define kSongDownloaderNotifi           @"songdownloadNotifi"
#define kSongDownloaderProgressNotifi   @"SongDownloaderProgress"

// 歌曲的data的key
#define kSongDatakey                    @"songdata"
//下载进度的key
#define kdownSongProgresskey            @"songProgress"

//歌曲播放完成通知
#define kSongPlayFinishNotifi           @"songplayfinish"
#define kSongPlayProgressNotifi         @"songplayprogressNtifi"

//歌曲当前播放时间
#define ksongCurrentTimekey             @"currenttime"

//歌曲完成解析通知
#define  kSongLrcNotifi                 @"songNotifi"

// 无歌词通知
#define kNOLrcNotifi                    @"noLrcNtifi"


#endif
