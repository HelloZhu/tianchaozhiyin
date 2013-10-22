//
//  SongIrc.m
//  mymusic3
//
//  Created by apple on 13-10-9.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "SongIrc.h"

@implementation SongIrc

- (id)initWithDictionary:(NSDictionary *)dict
{
    
    if (self=[super init]) {
        
      self.lrc=[dict objectForKey:@"lrc"];
        
    }

    return self;
}

+ (id)songLrcWithDictionary:(NSDictionary *)dict
{
    return [[SongIrc alloc] initWithDictionary:dict];
}

@end
