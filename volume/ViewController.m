//
//  ViewController.m
//  volume
//
//  Created by MrWu on 2017/5/9.
//  Copyright © 2017年 IYOO. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()
@property (nonatomic, assign) CGFloat tempVo;
@property (nonatomic, strong) MPVolumeView *volume;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //
    AVAudioSession *audio = [AVAudioSession sharedInstance];
    [audio setActive:YES error:nil];
    // 自定义提示顶替系统提示
    self.volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, -1000, 10, 10)];
    [self.view addSubview:_volume];
    self.volume.alpha = 0.01;
    UISlider *slider = nil;
    for (UIView *view in _volume.subviews) {
        if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
            slider = (UISlider *)view;
        }
    }
    [slider setValue:0.3];
    self.tempVo = [slider value];
    
    NSLog(@"%f == %@",self.tempVo, slider); 
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.volume setFrame:CGRectMake(-1000, -1000, 10, 10)];
}

- (void)volumeChange:(NSNotification *)notif {
    
//    NSLog(@"%@",notif.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"]);
    
    if ([notif.userInfo[@"AVSystemController_AudioCategoryNotificationParameter"] isEqualToString:@"VoiceCommand"]) {   //其他情况改变音量
        return;
    }
    
    CGFloat offset = [notif.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    if (offset - self.tempVo > 0 || offset == 1) {
        NSLog(@"音量调大");
    }
    
    if (offset - self.tempVo < 0 || offset == 0) {
        NSLog(@"音量调小");
    }
    
    self.tempVo = offset;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
