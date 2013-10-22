//
//  ItemCell.m
//  mymusic3
//
//  Created by apple on 13-10-4.
//  Copyright (c) 2013年 HelloZHU. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.channelName=[[UILabel alloc] initWithFrame:CGRectMake(205, 5, 100, 40)];
        self.channelName.numberOfLines=0;
        self.channelName.backgroundColor=[UIColor clearColor];
        self.channelName.textColor=[UIColor whiteColor];
        [self.contentView addSubview:self.channelName];
        self.backgroundColor=[UIColor blackColor];
        
        _playImageView=[[UIImageView alloc]initWithFrame:CGRectMake(300, 24, 16, 16)];
        UIImage *image1=[UIImage imageNamed:@"ic_player_nowplaying1.png"];
        UIImage *image2=[UIImage imageNamed:@"ic_player_nowplaying2.png"];
        UIImage *image3=[UIImage imageNamed:@"ic_player_nowplaying3.png"];
        UIImage *image4=[UIImage imageNamed:@"ic_player_nowplaying4.png"];
        _playImageView.animationImages=@[image1,image2,image3,image4];
        _playImageView.animationDuration=0.5;
        _playImageView.animationRepeatCount=0;
        //_playImageView.hidden=YES;
//        [_playImageView startAnimating];
        
        [self.contentView addSubview:_playImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (_playImageView.tag == 1) {
        [_playImageView startAnimating];
    }
}

@end
