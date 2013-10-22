//
//  ZHUMusicPlayer.h
//  mymusic3
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol ZHUMusicPlayerDelegate <NSObject>

- (void)playSongProgress:(double)prog;

@end

@interface ZHUMusicPlayer : NSObject


@property(nonatomic,assign)id<ZHUMusicPlayerDelegate>delegate;
@property(nonatomic,strong)AVAudioPlayer *player;

+ (instancetype)shareZhuMusicPlayer;
- (void)playSongWithData:(NSData *)data;
- (void)resumedPlay;
- (void)pausePlay;
- (void)stopPlay;
- (void)changeVolume:(float)size;

- (void)playSongWithData_continue:(NSData *)data;
@end
