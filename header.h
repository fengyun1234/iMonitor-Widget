//
//  Gestures_ViewController.h
//  Gestures+
//
//  Created by Anton Titkov on 24.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <stdio.h>
#import <string.h>
#import <assert.h>
#import <errno.h>
#import <string.h>
#import <syslog.h>
#import <Foundation/Foundation.h>
#import "BBWeeAppController-Protocol.h"
#import "IOKit/ps/IOPowerSources.h"
#import "IOKit/ps/IOPSKeys.h"
#import "UIDevice-Capabilities.h" 
#import "UIDevice-Hardware.h" 
#import "UIDevice-IOKitExtensions.h" 
#import "UIDevice-Reachability.h" 
#import "UIDevice-Orientation.h" 
#import <sys/unistd.h>
#import <sys/utsname.h>
#import <sys/types.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <stdio.h>
#import <stdlib.h>
#import <ifaddrs.h>
#import <string.h>
#import <stdbool.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <arpa/inet.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WeeAppTestController : NSObject <BBWeeAppController>{
    NSThread *thread1;
    NSTimer *timer1;
    NSBundle *locBundle;
    NSTimer *timer;
    BOOL isAired;
    UITextView *batStatus;
    UILabel *realIP;
    UILabel *localIP;
    UIImageView *charging;
    UIImageView *batteryIm;
    UIButton *myButton;
    UIDevice *myDevice;
    UIScrollView *scroll;
    UILabel *deviceModel;
    UILabel *batLevel;
    UILabel *memoryActive;
    UILabel *memoryWired;
    UILabel *memoryInactive;
    UILabel *memoryFree;
    UILabel *deviceName;
    NSString *mem_free;
    AVCaptureDevice * device1;
    NSString * mem_wired;
    NSString * mem_total;
    NSString * mem_active;
    NSString * mem_inactive;
    UIView *_view;
    UIView *view1;
    UIView *netView;
    UIView *othersView;
    UIView *adsView;
    BOOL isEnabled;
     UIButton *respringButton;
}
-(NSString*)deviceCheck;
-(void)getmemory;
-(NSString*)machineName;
+ (void)initialize;
- (id)view;
-(int)batteryValue;
-(void)Flash;
@end
