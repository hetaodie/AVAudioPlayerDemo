//
//  CustomAudioPlayer.h
//  AVAudioPlayerDemo
//
//  Created by weixu on 2017/2/28.
//  Copyright © 2017年 weixu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CustomAudioPlayerDelegate <NSObject>


/**
  当音频文件播放完成时候回调此函数
 */
- (void)audioPlayerPlayFinish;

/**
 当给的音频文件无法播放时，调用此回调
 */
- (void)audioPlayerPlayError;


/**
 返回当前的播放进度

 @param aduration 播放的进度值，范围在0~1.0之间
 */
- (void)audioPlayerPlayDuration:(CGFloat)aduration;


@end

@interface CustomAudioPlayer : NSObject

@property (nonatomic, assign) NSInteger numberOfLoops; ///<重复播放的次数，当设置为小于零时，无限重复
@property (nonatomic, weak) id<CustomAudioPlayerDelegate> delegate;

/**
 使用文件URL初始化播放器，

 @param url 注意这个URL不能是HTTP URL,只能是File URL
 */
- (id)initWithContentsOfURL:(NSURL *)url;

//播放
- (void)play;

// 从指定的时间开始播放
- (void)playAtTime:(NSTimeInterval)time;

//暂停播放
- (void)pause;

//停止播放
- (void)stop;

//改变音量
- (void)volumeChange:(CGFloat)volume;

//改变码率
- (void)rateChange:(CGFloat)rate;

//立体声平衡，如果为-1.0则完全左声道，如果0.0则左右声道平衡，如果为1.0则完全为右声道
- (void)panChange:(CGFloat)pan;

//获得指定声道的分贝峰值，
-  (float)peakPowerForChannel:(NSUInteger)channelNumber;

//获得指定声道的分贝平均值
- (float)averagePowerForChannel:(NSUInteger)channelNumber;
@end
