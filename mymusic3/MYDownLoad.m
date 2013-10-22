//
//  MYDownLoad.m
//  download
//
//  Created by apple on 13-9-30.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "MYDownLoad.h"




@interface MYDownLoad ()
{
    
    NSURLConnection *_asyConnection;
    NSFileHandle *_fileHandle;
    NSString *_filePath;
   
    long long _allFileSize;
    
    
}
@end



@implementation MYDownLoad


+ (instancetype)shareMydownload
{
    
    static MYDownLoad *myd=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myd=[[MYDownLoad alloc]init];
    });
    
    return myd;
}

- (id)init
{
    self=[super init];
    if (self) {
        
        _reslutData=[NSMutableData data];
        
    }
    return self;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connect failed -%@-- error:%@",[[connection currentRequest] URL],error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    
    
    if ([(NSHTTPURLResponse *)response statusCode]==200) {
    
        _allFileSize=[(NSHTTPURLResponse *)response expectedContentLength];
        
    }else if ([(NSHTTPURLResponse *)response statusCode]==206){
    
       
        //解析响应头
        NSDictionary *dict=[(NSHTTPURLResponse *)response allHeaderFields];
        NSString *contentRange=[dict objectForKey:@"Content-Range"];
        NSArray *array=[contentRange componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
        NSLog(@"array%@",array);
        NSString *range=[array objectAtIndex:1];
        unsigned long long range2=[range longLongValue];
        
       
        
        if (range2 >[_reslutData length]) {
            
           NSLog(@"server error");
            
        }
        
    }

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [_reslutData appendData:data];

    self.downloadProgress=100*[_reslutData length]/_allFileSize;
    
     if (_delegate && [_delegate respondsToSelector:@selector(myinfo:)]) {
        [_delegate myinfo:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(mydata:)]) {
        [_delegate mydata:_reslutData];
    }
    
   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     NSLog(@"下载完成");
}

- (void)download:(NSString *)targetPath
{
    
    //NSLog(@"targetPath-%@",targetPath);
    NSURL *url=[NSURL URLWithString:targetPath];
    
       
    
    //发可变请求
    NSMutableURLRequest *mRequest=[NSMutableURLRequest requestWithURL:url];
    unsigned long long fileSize=[_reslutData length];
    
    if (fileSize!=0) {

        [mRequest setValue:[NSString stringWithFormat:@" bytes=%llu-", fileSize] forHTTPHeaderField:@"Range"];
    }
    
    _asyConnection=[NSURLConnection connectionWithRequest:mRequest delegate:self];
    
    [_asyConnection start];
    
    
}

- (void)cancelDownload
{
    [_asyConnection cancel];
    _asyConnection=nil;
    _reslutData=[NSMutableData data];
}

@end
