//
//  CustomAudioPlayer.m
//  AVAudioPlayerDemo
//
//  Created by weixu on 2017/2/28.
//  Copyright © 2017年 weixu. All rights reserved.
//

#import "CustomAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>



@interface CustomAudioPlayer() <AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation CustomAudioPlayer


- (id)initWithContentsOfURL:(NSURL *)url {
    self = [super init];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                         error:nil];
    [self setUpAudioPlayer];
    return self;
}

- (void)play {
    if (!self.playing) {
        [self.audioPlayer play];
        self.playing = YES;
        
        [self startDisplayLink];
    }
}

- (void)playAtTime:(NSTimeInterval)time {
    [self.audioPlayer playAtTime:time];
}

- (void)pause {
    [self.audioPlayer pause];
}

- (void)stop {
    if (self.playing) {
        [self.audioPlayer stop];
        self.playing = NO;
    }
}

-  (float)peakPowerForChannel:(NSUInteger)channelNumber {
    return 0.f;
}

- (float)averagePowerForChannel:(NSUInteger)channelNumber {
    return 0.f;
}

- (void)volumeChange:(CGFloat)volume {
    self.audioPlayer.volume = volume;
}

- (void)rateChange:(CGFloat)rate {
    self.audioPlayer.rate = rate;
}

- (void)panChange:(CGFloat)pan {
    self.audioPlayer.pan = pan;
}

#pragma mark -
#pragma mark Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(audioPlayerPlayFinish)]) {
        [self.delegate audioPlayerPlayFinish];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

#pragma mark -
#pragma mark private

- (void)setUpAudioPlayer{
    self.audioPlayer.numberOfLoops = self.numberOfLoops;
    self.audioPlayer.enableRate = YES;  // 允许调整速率
    self.audioPlayer.meteringEnabled = YES;
    [self.audioPlayer prepareToPlay];
}

- (void)startDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)handleDisplayLink:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerPlayDuration:)]) {
        CGFloat duration = self.audioPlayer.currentTime/self.audioPlayer.duration;
        [self.delegate audioPlayerPlayDuration:duration];
    }
}
@end
