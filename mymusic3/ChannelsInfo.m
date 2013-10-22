//
//  ChannelsInfo.m
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "ChannelsInfo.h"
#import "config.h"

@implementation ChannelsInfo



- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self==[super init]) {
        
        self.name=[dict objectForKey:kchannelNamekey];
        self.channel_id=[[dict objectForKey:@"channel_id"] integerValue];
    }
    
    return self;
}

+ (id)channelWithDictionary:(NSDictionary *)dict
{
    return [[ChannelsInfo alloc] initWithDictionary:dict];
}

@end
