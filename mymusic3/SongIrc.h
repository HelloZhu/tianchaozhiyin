//
//  SongIrc.h
//  mymusic3
//
//  Created by apple on 13-10-9.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongIrc : NSObject

@property(nonatomic,copy)NSString *lrc;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (id)songLrcWithDictionary:(NSDictionary *)dict;

@end
