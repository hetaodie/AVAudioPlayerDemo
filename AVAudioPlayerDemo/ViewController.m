//
//  ViewController.m
//  AVAudioPlayerDemo
//
//  Created by weixu on 2017/2/28.
//  Copyright © 2017年 weixu. All rights reserved.
//

#import "ViewController.h"
#import "CustomAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController () <CustomAudioPlayerDelegate>
@property (nonatomic, strong)CustomAudioPlayer *customAudioPlayer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TFBOYS" withExtension:@"mp3"];
    self.customAudioPlayer = [[CustomAudioPlayer alloc] initWithContentsOfURL:url];
    self.customAudioPlayer.delegate = self;
    
    [self becomeFirstResponder];
    
//    [self.customAudioPlayer play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playBtnPress:(UIButton *)sender {
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{MPMediaItemPropertyTitle:@"音乐测试",MPMediaItemPropertyAlbumTitle:@"魏旭"}];
    
    if (sender.isSelected) {
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        [sender setSelected:NO];

        [self.customAudioPlayer play];
    }
    else{
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setSelected:YES];
        
        [self.customAudioPlayer stop];
    }
}

- (IBAction)volumnChange:(UISlider *)sender {
    [self.customAudioPlayer volumeChange:sender.value];
}


- (IBAction)panChange:(UISegmentedControl *)sender {
    NSInteger selectTag = sender.selectedSegmentIndex;

    [self.customAudioPlayer panChange:selectTag-1];
}

- (void)audioPlayerPlayDuration:(CGFloat)aduration {
    [self.progressView setProgress:aduration animated:YES];
}

- (void)audioPlayerPlayFinish{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"播放完成" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)audioPlayerPlayError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"播放错误，请检查url" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
                case UIEventSubtypeRemoteControlPlay:
                //[self.playCenter midBtnClicked:nil];
                NSLog(@"暂停播放");
                break;
                case UIEventSubtypeRemoteControlPause:
                // [self.playCenter midBtnClicked:nil];
                NSLog(@"继续播放");
                break;
                case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一曲");
                break;
                case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一曲");
                break;
            default:
                break;
        }
    }
}
@end
