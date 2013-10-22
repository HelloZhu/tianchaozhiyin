//
//  SongInfo.h
//  mymusic3
//
//  Created by apple on 13-10-7.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

@interface SongInfo : NSObject

@property(nonatomic,copy)       NSString *album;
@property(nonatomic,copy)       NSString *picture;
@property(nonatomic,copy)       NSString *ssid;
@property(nonatomic,copy)       NSString *artist;
@property(nonatomic,copy)       NSString *url;
@property(nonatomic,copy)       NSString *company;
@property(nonatomic,copy)       NSString *title;
@property(nonatomic,assign)     NSInteger length;
@property(nonatomic,copy)       NSString *public_time;
@property(nonatomic,copy)       NSString *albumtitle;
@property(nonatomic,assign)     NSInteger like;

- (id)initWithDictionnary:(NSDictionary *)dict;
+ (id)songInfoWithDictionary:(NSDictionary *)dict;


@end
