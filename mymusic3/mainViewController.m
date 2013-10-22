//
//  mainViewController.m
//  mymusic3
//
//  Created by apple on 13-10-4.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "mainViewController.h"
#import "PPRevealSideViewController.h"
#import "FileListViewController.h"
#import "RNFrostedSidebar.h"
#import "AFNetworking.h"
#import "SongListViewController.h"
#import "ZHUSongDownLoader.h"
#import "ZHUMusicPlayer.h"
#import "MYDownLoad.h"


#define kDoubanItemPath @"http://www.douban.com/j/app/radio/channels"

@interface mainViewController ()<RNFrostedSidebarDelegate,MYDownLoadDelgate,ZHUMusicPlayerDelegate>
{
    
   
    FileListViewController *fileList;
    UIBarButtonItem *_rightBarBtn;
    BOOL rightBarBtnflag;
  
    NSArray *_songArray;
    MusicDataManager *_md;
    NSInteger _currentSongIndex;
    ZHUMusicPlayer *_myMusicPlay;
    BOOL flag;
    BOOL isHiddenVolumeBtn;
    NSData *_musicData;
    float _shouldNext;
    NSString *_imageName;
    
    BOOL isPlay;
    
   
   
}
@end

@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //装歌词
        _timeStrArray=[NSMutableArray array];
        
        _hadShowLrcStrArray=[NSMutableArray array];
        
    }
    return self;
}

- (void)navBarImage:(NSString *)imageName
{
    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]];
     [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
   // self.navigationController.navigationBar.barTintColor=[UIColor clearColor];
    //self.navigationController.navigationBar.alpha=0.5;
    
    
    //保存背景状态
    NSUserDefaults *userDefefault=[NSUserDefaults standardUserDefaults];
    [userDefefault setValue:_imageName forKey:@"imageNameKey"];
    [userDefefault synchronize];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11_.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    self.lrcLabel.numberOfLines=0;
    //背景
    self.backgroundImageView.image=[UIImage imageNamed:@"11.jpg"];
    isPlay=YES;
    flag=YES;
    isHiddenVolumeBtn=YES;
    
    _myMusicPlay=[ZHUMusicPlayer shareZhuMusicPlayer];
    _myMusicPlay.delegate=self;
    
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    [self rigtBarButton];
    [self leftBarButton];
    [self.playButtton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.playButtton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    
    
    fileList=[[FileListViewController alloc] initWithNibName:nil bundle:nil];
    
    //随机频道数
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    int i = rand() % 30;
    
    _md=[MusicDataManager shareDataManager];
    [_md  fetchChannelData:^{
        
        NSArray *array= [_md channelList];
        if ([array count]) {
            //第一次进来的频道1
            
            _md.currentChannel=[array objectAtIndex:i];
            
        }
        
    }];
    
   
    [self musicSlider];
    
    //注册通知
    [self regiesterNotfication];
   
    [self nowPlayingImage];
    
    
    //影藏歌词
   // [_md hiddenLrc];
    
    NSURL *url=[NSURL URLWithString:@"https://raw.github.com/HelloZhu/tianchaozhiyin/master/lrc.json"];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
   id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",json);
    
    NSNumber *number=[json objectForKey:@"show"];
    
    BOOL ishidden=[number boolValue];
    NSLog(@"%d",ishidden);
    
    if (ishidden) {
        
        self.lrcLabel.hidden=NO;
    }else{
        
         self.lrcLabel.hidden=YES;
    
    }
    
    
}

- (void)playSongProgress:(double)prog
{
    
    
   // NSLog(@"prog-%f",prog);
    
    self.playProgressView.progress=prog;
    
    SongInfo *song          =[_songArray objectAtIndex:_currentSongIndex];
    
    NSString *progressStr   =[NSString stringWithFormat:@"%.2f",song.length*prog];
    //NSLog(@"%@",progressStr);
    
    //显示当前播放时间
    self.playCurrentTimeLabel.text=[self playCurrentTime:song.length*self.playProgressView.progress];
    
//    if ([_timeStrArray count]) {
//        
//        for (NSString *str in _timeStrArray) {
//            
//            NSString *str2=[str substringWithRange:NSMakeRange(0, 5)];
//            
//            NSString *minustr   =[str substringWithRange:NSMakeRange(0, 2)];
//            NSString *secondStr =[str substringWithRange:NSMakeRange(3, 2)];
//            NSString *ms=        [str substringWithRange:NSMakeRange(6, 2)];
//           // NSLog(@"%@",minustr);
//           // NSLog(@"%@",ms);
//            
//            int mytime=[minustr intValue]*60+[secondStr intValue];
//            
//            
//            NSString *timeStr=[NSString stringWithFormat:@"%d.%@",mytime,ms];
//            NSLog(@"%@",timeStr);
//            if ([timeStr isEqualToString:progressStr]) {
//                
//                NSRange range=[str rangeOfString:@"]"];
//                self.lrcLabel.text=[str substringFromIndex:range.location+1];
//                [_hadShowLrcStrArray addObject:self.lrcLabel.text];
//            }
//        }
//        
//    }
    
    
    [self showLrc:self.playCurrentTimeLabel.text];
    
    //总时长减去当前的进度
    _shouldNext=song.length-song.length*self.playProgressView.progress;
    
}

- (void)showLrc:(NSString *)labelText
{
    //将中间歌词显示
    if ([_timeStrArray count]) {
        
        for (NSString *str in _timeStrArray) {
            
            NSString *str2=[str substringWithRange:NSMakeRange(0, 5)];
            
            if ([str2 isEqualToString:labelText]) {
                
                NSRange range=[str rangeOfString:@"]"];
                self.lrcLabel.text=[str substringFromIndex:range.location+1];
                [_hadShowLrcStrArray addObject:self.lrcLabel.text];
            }
        }
        
    }
    
    
    
}



- (void)nowPlayingImage
{
    UIImage *image1=[UIImage imageNamed:@"ic_player_nowplaying1.png"];
    UIImage *image2=[UIImage imageNamed:@"ic_player_nowplaying2.png"];
    UIImage *image3=[UIImage imageNamed:@"ic_player_nowplaying3.png"];
    UIImage *image4=[UIImage imageNamed:@"ic_player_nowplaying4.png"];
   /// self.nowplayImageView.image=image1;
    self.nowplayImageView.animationImages=@[image1,image2,image3,image4];
    self.nowplayImageView.animationDuration=0.5;
    self.nowplayImageView.animationRepeatCount=0;
    
    [self.nowplayImageView startAnimating];
    
}


- (void)regiesterNotfication
{
    //更换频道通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeChannelNotifi:) name:kChangeChannelNotification object:nil];
    
    //下载歌曲通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishDownloadSong:) name:kSongDownloaderNotifi object:nil];
    
    //下载进度通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DownloadSongProgress:) name:kSongDownloaderProgressNotifi object:nil];
    
    //歌曲播放完通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(songPlayFinish:) name:kSongPlayFinishNotifi object:nil];
    
    //歌曲播放进度通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(songPlayProgress:) name:  kSongPlayProgressNotifi object:nil];
    
    //歌词完成解析通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didsongLrc:) name:  kSongLrcNotifi object:nil];
    
    // 无歌词通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didNoLrc:) name:kNOLrcNotifi object:nil];
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenLrc:) name:@"hiddenLrcNotifi" object:nil];

}

- (void)hiddenLrc:(NSNotification *)notification
{
    NSDictionary *dict=[notification userInfo];
    [dict objectForKey:@"show"];
}


- (void)didNoLrc:(NSNotification *)notification
{
    self.lrcLabel.text=@"sorry，暂无歌词！";
}


- (void)didsongLrc:(NSNotification *)notification
{
    
    NSDictionary *dict=[notification userInfo];
   
    
   // NSLog(@"song lrc :%@",[dict objectForKey:@"lrc"]);
    NSString *lrcPath=[dict objectForKey:@"lrc"];
    
    //下载歌词
    [[ZHUSongDownLoader shareSongDownload] downloadSong:lrcPath];
    
    
}


//音量slider
- (void)musicSlider
{
    self.volumeSlider.value=0.5;
    [self.volumeSlider addTarget:self action:@selector(didchangevolume) forControlEvents:UIControlEventValueChanged];
    CGAffineTransform trans=self.volumeSlider.transform;
    self.volumeSlider.transform=CGAffineTransformRotate(trans, -M_PI_2);
}

- (void)didchangevolume
{
    [_myMusicPlay changeVolume:self.volumeSlider.value];
}



//播放进度
- (void)songPlayProgress:(NSNotification*)notification
{
    
    NSDictionary *dict=[notification userInfo];
    NSNumber *number=[dict objectForKey:ksongCurrentTimekey];
   
   
    
    self.playProgressView.progress=[number doubleValue];
    
    SongInfo *song          =[_songArray objectAtIndex:_currentSongIndex];
   
//    NSString *progressStr   =[NSString stringWithFormat:@"%.2f",song.length*self.playProgressView.progress];
    
   // NSLog(@"%@",progressStr);
    
    //显示当前播放时间
    self.playCurrentTimeLabel.text=[self playCurrentTime:song.length*self.playProgressView.progress];
    
    [self showLrc:self.playCurrentTimeLabel.text];
    
    //总时长减去当前的进度
     _shouldNext=song.length-song.length*self.playProgressView.progress;
    
    
}



//播放的当前时间
- (NSString *)playCurrentTime:(double )time
{
    
    return  [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
    
}


//歌词下载进度
- (void)DownloadSongProgress:(NSNotification *)notification
{
    
    //NSDictionary *dict=[notification userInfo];
   // NSNumber *number=[dict objectForKey:kdownSongProgresskey];
   
   
    
}

//歌词下载完成、显示
- (void)finishDownloadSong:(NSNotification *)notification
{
    NSDictionary *dict=[notification userInfo];
    NSData *data=[dict objectForKey:kSongDatakey];
    NSString *lrc=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    [self handdleLrc:lrc];
}


//歌词处理
- (void)handdleLrc:(NSString *)lrc
{
    
    if ([_timeStrArray count]) {
        
        [_timeStrArray removeAllObjects];
        
    }
    
    if (lrc ==nil || [lrc isEqualToString:@""]) {
        
        return;
        
    }else {
    
        
        
        
        NSArray *array=[lrc componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[\n"]];
        
        for (NSString *str in array) {
            
            if ([str hasPrefix:@"0"] || [str hasPrefix:@"1"]) {
                
                [_timeStrArray addObject:str];
            }
            
        }
       // NSLog(@"timeStrArray--%@",_timeStrArray);
    }
    
}


//切换频道
- (void)changeChannelNotifi:(NSNotification *)notification
{
    if ([_timeStrArray count]) {
        
        [_timeStrArray removeAllObjects];
    }
    [[MYDownLoad shareMydownload] cancelDownload];
     self.lrcLabel.text=@"正在为你努力的寻找歌词...";
     self.playCurrentTimeLabel.text=@"00:00";
    [_myMusicPlay stopPlay];
    
    _songArray=[_md currentSongList];
    
    if ([_songArray count]) {
        
        
        self.curentChannelLabel.text=[_md currentChannel].name;
        
        [self showSongInfo:0];
    }
    
    flag=YES;
}

//显示歌曲信息
- (void)showSongInfo:(NSInteger)index
{
   
    

    
    SongInfo *song=[_songArray objectAtIndex:index];
    
    
    [self.songImageView setImageWithURL:[NSURL URLWithString:song.picture]];
    
    [_md fetchSongLrc:song];
    
    
    self.songTitle.text=song.title;
    self.songArtist.text=song.artist;
        
    //解析歌词
    [_md fetchSongLrc:song];
    
   
    
    //mydownload下载
    [MYDownLoad shareMydownload].delegate=self;
    [[MYDownLoad shareMydownload] download:song.url];
    
   
    
}

//我的下载器
- (void)mydata:(NSData *)resultData
{
     //NSLog(@"正在下载。。。。");
    
    
    _musicData=resultData;
    if (flag) {
        
         [_myMusicPlay playSongWithData:_musicData];
        
        flag=NO;
    }
   
  
    
}

//歌曲播放完成，自动下一首
- (void)songPlayFinish:(NSNotification *)notification
{
    
    [_myMusicPlay playSongWithData_continue:_musicData];
   
    flag=YES;
    
   
    if (_shouldNext<1) {
        
         [self playNextSong];
    }
    
   
    
}




- (void)rigtBarButton
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"burger.png"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, 25, 20);
    [btn addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
   _rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem= _rightBarBtn;
}

- (void)leftBarButton
{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 35, 35)];
    [btn setBackgroundImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=left;
}

- (void)showLeft
{
    
    
    
    

    NSArray *images = @[
                        [UIImage imageNamed:@"11.jpg"],
                        [UIImage imageNamed:@"2.jpg"],
                        [UIImage imageNamed:@"3.jpg"],
                        [UIImage imageNamed:@"4.jpg"],
                        [UIImage imageNamed:@"5.png"],
                        [UIImage imageNamed:@"6.jpg"],
                        [UIImage imageNamed:@"7.jpg"],
                        [UIImage imageNamed:@"8.jpg"],
                        [UIImage imageNamed:@"9.jpg"],
                        [UIImage imageNamed:@"10.jpg"],
                        //[UIImage imageNamed:@"11.jpg"],
                        //[UIImage imageNamed:@"12.jpg"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
//                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
//                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //    callout.showFromRight = YES;
    callout.width=100;
    [callout show];

}

- (void) showRight {
  
    
    
//    if (rightBarBtnflag) {
//        _rightBarBtn.title=@"<<";
//        rightBarBtnflag=NO;
//    }else{
//    
//         _rightBarBtn.title=@"音乐频道";
//        rightBarBtnflag=YES;
//    }
    [self.revealSideViewController pushViewController:fileList onDirection:PPRevealSideDirectionRight withOffset:200 animated:YES];
    
   
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
  //  NSLog(@"Tapped item at index %i",index);
    
    switch (index) {
        case 0:
            [self changeBackgroundImage:[UIImage imageNamed:@"11.jpg"]];
            [self navBarImage:@"11_.jpg"];
            _imageName=@"11_.jpg";
            break;
        case 1:
            [self changeBackgroundImage:[UIImage imageNamed:@"2.jpg"]];
            [self navBarImage:@"2_.jpg"];
            _imageName=@"2_.jpg";
            break;
        case 2:
            [self changeBackgroundImage:[UIImage imageNamed:@"3.jpg"]];
            [self navBarImage:@"3_.jpg"];
            _imageName=@"3_.jpg";
            break;
        case 3:
            [self changeBackgroundImage:[UIImage imageNamed:@"4.jpg"]];
            [self navBarImage:@"4_.jpg"];
            _imageName=@"4_.jpg";
            break;

        case 4:
            [self changeBackgroundImage:[UIImage imageNamed:@"5.png"]];
            [self navBarImage:@"5_.png"];
            _imageName=@"5_.jpg";
            break;
        case 5:
            [self changeBackgroundImage:[UIImage imageNamed:@"6.jpg"]];
            [self navBarImage:@"6_.jpg"];
            _imageName=@"6_.jpg";
            break;
        case 6:
            [self changeBackgroundImage:[UIImage imageNamed:@"7.jpg"]];
            [self navBarImage:@"7_.jpg"];
            _imageName=@"7_.jpg";
            break;
        case 7:
            [self changeBackgroundImage:[UIImage imageNamed:@"8.jpg"]];
            [self navBarImage:@"8_.jpg"];
            _imageName=@"8_.jpg";
            break;
        case 8:
            [self changeBackgroundImage:[UIImage imageNamed:@"9.jpg"]];
            [self navBarImage:@"9_.jpg"];
            _imageName=@"9_.jpg";
            break;
        case 9:
            [self changeBackgroundImage:[UIImage imageNamed:@"10.jpg"]];
            [self navBarImage:@"10_.jpg"];
            _imageName=@"10_.jpg";
            break;
       
        
        default:
            break;
    }
    
    
    [sidebar dismiss];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}


- (void)changeBackgroundImage:(UIImage *)image
{
    
    self.backgroundImageView.image=image;

}


- (IBAction)volumeBtn:(id)sender {
    
    if (isHiddenVolumeBtn) {
        self.volumeSlider.hidden=NO;
        isHiddenVolumeBtn=NO;
    }else{
        self.volumeSlider.hidden=YES;
        isHiddenVolumeBtn=YES;
    }
    
}

- (IBAction)playBtn:(id)sender {
    
  
    if (self.playButtton.selected) {
        
      
        [_myMusicPlay resumedPlay];
        [self.nowplayImageView startAnimating];
        
    }else{
    
        [_myMusicPlay pausePlay];
        [self.nowplayImageView stopAnimating];
    }
   
    self.playButtton.selected= !self.playButtton.selected;
    
    
}

- (IBAction)nextSongBtn:(id)sender {
    
    
    [self playNextSong];
}


- (void)playNextSong
{
    if ([_timeStrArray count]) {
        
        [_timeStrArray removeAllObjects];
    }
    
    self.lrcLabel.text=@"正在为你努力的寻找歌词...";
     self.playCurrentTimeLabel.text=@"00:00";
     self.playProgressView.progress=0.0;
    [[MYDownLoad shareMydownload] cancelDownload];
    [_myMusicPlay stopPlay];
    
    flag=YES;
    
    if (_songArray && [_songArray count]) {
        
        if (_currentSongIndex<[_songArray count]-1) {
            
            _currentSongIndex++;
            [self showSongInfo:_currentSongIndex];
            
        }else{
            
            [MusicDataManager shareDataManager].currentChannel=[MusicDataManager shareDataManager].currentChannel;
        }
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.volumeSlider.hidden=YES;
}

- (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    
    

}

// 摇一摇下一首
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self playNextSong];
}


@end
