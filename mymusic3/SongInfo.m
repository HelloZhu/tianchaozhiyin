//
//  SongInfo.m
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "SongInfo.h"


@implementation SongInfo

- (id)initWithDictionnary:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.album=[dict objectForKey:kalbumkey];
        self.picture=[dict objectForKey:kpicturekey];
        self.artist=[dict objectForKey:kartistkey];
        self.url=[dict objectForKey:kurlkey];
        self.title=[dict objectForKey:ktitlekey];
        self.albumtitle=[dict objectForKey:kalbumtitlekey];
        self.length=[[dict objectForKey:klengthkey] integerValue];
        
    }
    
    return self;
}

+ (id)songInfoWithDictionary:(NSDictionary *)dict
{
    
    return [[SongInfo alloc]initWithDictionnary:dict];

}

@end
