//
//  ZHUSongDownLoader.h
//  mymusic3
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongInfo.h"

@interface ZHUSongDownLoader : NSObject


+ (instancetype)shareSongDownload;
- (void)downloadSong:(NSString *)lrcPath;
- (void)cancelDownload;
@end
