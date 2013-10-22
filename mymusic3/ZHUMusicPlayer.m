//
//  ZHUMusicPlayer.m
//  mymusic3
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "ZHUMusicPlayer.h"
#import "config.h"


@interface ZHUMusicPlayer ()<AVAudioPlayerDelegate>
{

    NSTimer *_timer;
    NSTimeInterval _lastTime;
}
@end

@implementation ZHUMusicPlayer


+ (instancetype)shareZhuMusicPlayer
{
    static ZHUMusicPlayer *myplayer=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        myplayer=[[ZHUMusicPlayer alloc] init];
    });
    
    return myplayer;
}

- (void)playSongWithData:(NSData *)data
{
    
    //xx
    if (self.player && [self.player isPlaying]) {
        [self.player stop];
    }
    self.player=nil;
    self.player=[[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.delegate=self;
    
    _lastTime=self.player.duration;
    
    [self.player prepareToPlay];
    
    [self.player play];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
}

- (void)playSongWithData_continue:(NSData *)data
{
    
    if (self.player && [self.player isPlaying]) {
        [self.player stop];
    }
    

    
    
    self.player=nil;
    self.player=[[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.delegate=self;
    self.player.currentTime=_lastTime;
    [self.player prepareToPlay];
    [self.player play];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
}


- (void)resumedPlay
{
    
    [self.player play];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
}

- (void)pausePlay
{
    [_timer invalidate];
    [self.player pause];
}

- (void)stopPlay
{
    [_timer invalidate];
    [self.player stop];
    
}

- (void)changeVolume:(float)size
{
    _player.volume=size;
}

- (void)playProgress
{
    
    double now=self.player.currentTime/self.player.duration;
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithFloat:now] forKey:ksongCurrentTimekey];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kSongPlayProgressNotifi object:nil userInfo:dict];
    
    if (_delegate && [_delegate respondsToSelector:@selector(playSongProgress:)]) {
        
        [_delegate playSongProgress:now];
    }
    

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%@",flag?@"suceess":@"failed");
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSongPlayFinishNotifi object:nil userInfo:nil];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%@",error);
}

@end
