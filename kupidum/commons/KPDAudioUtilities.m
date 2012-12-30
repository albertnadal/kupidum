//
//  KPDAudioUtilities.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 30/12/12.
//  Copyright (c) 2012 Albert Nadal Garriga. All rights reserved.
//

#import "KPDAudioUtilities.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface KPDAudioUtilities ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation KPDAudioUtilities

@synthesize audioPlayer = audioPlayer_;

+ (KPDAudioUtilities *)sharedInstance
{    
    static dispatch_once_t onceToken;
    static KPDAudioUtilities *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[KPDAudioUtilities alloc] init];
    });
    
    return _instance;
}

- (void)playRingtoneInLoop:(NSURL *)ringtonePath
{
    if (!self.audioPlayer)
    {
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ringtonePath error:&error];
        if (error != nil) self.audioPlayer = nil;
        [AVAudioSession sharedInstance];
    }

    if (self.audioPlayer && ![self.audioPlayer isPlaying])
    {
        self.audioPlayer.volume = 1.0f;
        self.audioPlayer.numberOfLoops = -1;
        //FIXME: watch out side effect voice routed to speaker as well
        
/*        if (!isIncoming)
        {
            UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
        }
        else
        {
            UInt32 sessionCategory = kAudioSessionCategory_SoloAmbientSound;
            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }*/
        
        [self.audioPlayer play];
    }
}

- (void)playRingtone:(NSURL *)ringtonePath
{
    if (!self.audioPlayer)
    {
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ringtonePath error:&error];
        if (error != nil) self.audioPlayer = nil;
        [AVAudioSession sharedInstance];
    }
    
    if (self.audioPlayer && ![self.audioPlayer isPlaying])
    {
        self.audioPlayer.volume = 1.0f;
        self.audioPlayer.numberOfLoops = 0;
        [self.audioPlayer play];
    }
}

- (void)stopRingtone
{
    if (self.audioPlayer && [self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
#if !YARN_HAS_VIDEO
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
#endif
    }
}


@end
