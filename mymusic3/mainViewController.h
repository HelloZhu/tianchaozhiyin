//
//  mainViewController.h
//  mymusic3
//
//  Created by apple on 13-10-4.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicDataManager.h"



@interface mainViewController : UIViewController



//装未播放的歌词
@property(nonatomic,retain) NSMutableArray *timeStrArray;
//已播放的歌词
@property(nonatomic,retain) NSMutableArray *hadShowLrcStrArray;

@property (strong, nonatomic) IBOutlet UILabel *hadShowLabel;
@property (strong, nonatomic) IBOutlet UILabel *willShowlrcLabel;


@property (strong, nonatomic) IBOutlet UILabel *lrcLabel;
@property(nonatomic ,strong)    UIBarButtonItem *rightBarBtn;
@property(nonatomic,assign)     BOOL _rightBarBtnflag;

@property (strong, nonatomic)   IBOutlet UIButton *volumeBtn;
@property (strong, nonatomic)   IBOutlet UIImageView *nowplayImageView;

@property (strong, nonatomic)   IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic)   IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic)   IBOutlet UILabel *songArtist;

@property (strong, nonatomic)   IBOutlet UILabel *songTitle;
@property (nonatomic, strong)   NSMutableIndexSet *optionIndices;


@property (strong, nonatomic)   IBOutlet UIButton *playButtton;
@property (strong, nonatomic)   IBOutlet UIProgressView *playProgressView;
@property (strong, nonatomic)   IBOutlet UILabel *playCurrentTimeLabel;

@property (strong, nonatomic)   IBOutlet UILabel *curentChannelLabel;
@property (strong, nonatomic)   IBOutlet UIImageView *songImageView;



- (IBAction)volumeBtn:(id)sender;
- (IBAction)playBtn:(id)sender;
- (IBAction)nextSongBtn:(id)sender;






@end
