//
//  ChannelsInfo.h
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelsInfo : NSObject

@property(nonatomic,copy)    NSString *name;
@property(nonatomic,assign)  NSInteger seq_id;
@property(nonatomic,copy)    NSString *abbr_en;
@property(nonatomic,assign)  NSInteger channel_id;
@property(nonatomic,copy)    NSString *name_en;



- (id)initWithDictionary:(NSDictionary *)dict;
+ (id)channelWithDictionary:(NSDictionary *)dict;


@end
