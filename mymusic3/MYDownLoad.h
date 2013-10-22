//
//  MYDownLoad.h
//  download
//
//  Created by apple on 13-9-30.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDownLoadNotif @"download"
#define kUserifoKey @"userinfo"
@class MYDownLoad;
@protocol MYDownLoadDelgate <NSObject>

@optional
- (void)myinfo:(MYDownLoad *)mydownload;
- (void)mydata:(NSData *)resultData;


@end

@interface MYDownLoad : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

+ (instancetype)shareMydownload;

@property(nonatomic,assign)float downloadProgress;
@property(nonatomic,assign)id<MYDownLoadDelgate> delegate;
@property(nonatomic,retain) NSMutableData *reslutData;
- (void)download:(NSString *)targetPath;
- (void)cancelDownload;

- (id)init;
@end
