//
//  ZHUSongDownLoader.m
//  mymusic3
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "ZHUSongDownLoader.h"
#import "AFNetworking.h"
#import "config.h"

@interface ZHUSongDownLoader ()
{
    AFHTTPRequestOperation *_operation;
}
@end

@implementation ZHUSongDownLoader

+ (instancetype)shareSongDownload
{
    static ZHUSongDownLoader *downloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader=[[ZHUSongDownLoader alloc] init];
    });
    
    return downloader;
}

- (void)downloadSong:(NSString *)lrcPath
{
    
    NSURL *url=[NSURL URLWithString:lrcPath];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=[NSDictionary dictionaryWithObject:operation.responseData forKey:kSongDatakey];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSongDownloaderNotifi object:nil userInfo:dict];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"songdownload error:%@",error);
    }];
    
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSNumber *num=[NSNumber numberWithFloat:1.0*totalBytesRead/totalBytesExpectedToRead];
        NSDictionary *dict=[NSDictionary dictionaryWithObject:num forKey:kdownSongProgresskey];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSongDownloaderProgressNotifi object:nil userInfo: dict];
        
    }];
    
    [_operation start];
    
}

- (void)cancelDownload
{
    if (_operation && [_operation isExecuting]) {
        
        [_operation cancel];
    }
}

@end
