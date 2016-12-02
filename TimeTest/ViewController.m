//
//  ViewController.m
//  TimeTest
//
//  Created by LiDaHai on 16/12/2.
//  Copyright © 2016年 LiDaHai. All rights reserved.
//

#import "ViewController.h"
#import <sys/sysctl.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 监测系统时间是否有变动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemClockDidChange:) name:NSSystemClockDidChangeNotification object:nil];
    
}

- (IBAction)btnTapped:(id)sender
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *bootDate = [fomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self uptime]]];
    NSString *updatedDate = [fomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self uptime]+[NSProcessInfo processInfo].systemUptime]];
    
    self.textView.text = [NSString stringWithFormat:@"%@\n\n------->bootTime:%ld %@\n------->syupTime:%f %@",self.textView.text,[self uptime],bootDate,[NSProcessInfo processInfo].systemUptime,updatedDate];

    NSLog(@"\n------->bootTime:%ld  %@\n------>sysupTime:%f  %@",[self uptime],bootDate,[NSProcessInfo processInfo].systemUptime,updatedDate);
}


// 获取系统开机时的时间戳（此时间戳记录的是在手机开机时的手机设备时间，不一定是准确时间）
- (time_t)uptime
{
    // 参考资料
    // UIApplicationSignificantTimeChangeNotification
    // http://stackoverflow.com/questions/1444456/is-it-possible-to-get-the-atomic-clock-timestamp-from-the-iphone-gps
    // http://stackoverflow.com/questions/9564823/internal-clock-in-iphone-background-mode/9744686#9744686
    // http://stackoverflow.com/questions/12488481/getting-ios-system-uptime-that-doesnt-pause-when-asleep/12490414#12490414
    // http://stackoverflow.com/questions/10331020/get-the-boot-time-in-objective-c/10331716#10331716
    struct timeval boottime;
    size_t size = sizeof(boottime);
    int ret = sysctlbyname("kern.boottime", &boottime, &size, NULL, 0);
    assert(ret == 0);
    return boottime.tv_sec;
    
    // 系统当前已运行的秒数（以手机开机时间为计时起点）
    //return [NSProcessInfo processInfo].systemUptime;
    
}

- (void)systemClockDidChange:(NSNotification *)notification
{
    NSLog(@"----->系统时间有变动");
    self.textView.text = [NSString stringWithFormat:@"%@\n\n------->系统时间有变动",self.textView.text];
}


@end
