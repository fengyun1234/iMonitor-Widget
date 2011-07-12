
@interface UIDevice (buildVersion)
-(id)buildVersion;
@end

#import "header.h"
#define fontSize 14.0
@implementation iMonitorController

CGFloat kScrollObjHeight	= 91.0;
CGFloat kScrollObjWidth	= 320.0;

const NSUInteger kNumImages		= 5;

/*-(int)cpu{
    size_t length;
    int mib[6]; 
    int result;
    
    mib[0] = CTL_HW;
    mib[1] = HW_CPU_FREQ;
    length = sizeof(result);
    sysctl(mib, 2, &result, &length, NULL, 0);
    return result;
}*/


- (void)layoutScrollImages
{
	UIView *view = nil;
	NSArray *subviews;
    subviews = [scroll subviews];
	CGFloat curXLoc = -kScrollObjWidth;
	for (view in subviews)
	{
        CGRect frame = view.frame;
        frame.origin = CGPointMake(curXLoc, 0);
        view.frame = frame;
        curXLoc += (kScrollObjWidth);
	}
	[scroll setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scroll bounds].size.height)];
}
-(void)Flash{
    if (isEnabled) {
    [device1 lockForConfiguration:nil];
    [device1 setTorchMode:AVCaptureTorchModeOff];
    [device1 setFlashMode:AVCaptureFlashModeOff]; 
    [device1 unlockForConfiguration];
    [myButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/lighter_off.png"] forState:UIControlStateNormal];
        isEnabled=NO;

    }else{
        [myButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/lighter_on.png"] forState:UIControlStateNormal];
        [device1 lockForConfiguration:nil];
        [device1 setTorchMode:AVCaptureTorchModeOn];
        [device1 setFlashMode:AVCaptureFlashModeOn]; 
        [device1 unlockForConfiguration];
        isEnabled=YES;
    }
}

-(void)getmemory{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_statistics_data_t vm_stat;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */ 
    mem_active = [NSString stringWithFormat:@"%.1f",vm_stat.active_count * pagesize/1048576.0];
    mem_inactive= [NSString stringWithFormat:@"%.1f",vm_stat.inactive_count * pagesize/1048576.0];
    mem_wired = [NSString stringWithFormat:@"%.1f",vm_stat.wire_count * pagesize/1048576.0];
    mem_free = [NSString stringWithFormat:@"%.1f",vm_stat.free_count * pagesize/1048576.0];
}

/*-(int)processes{

        int mib[5];
        struct kinfo_proc *procs = NULL, *newprocs;
        int i, st, nprocs;
        size_t miblen, size;
        
        // Set up sysctl MIB 
        mib[0] = CTL_KERN;
        mib[1] = KERN_PROC;
        mib[2] = KERN_PROC_ALL;
        mib[3] = 0;
        miblen = 4;
        
        // Get initial sizing 
        st = sysctl(mib, miblen, NULL, &size, NULL, 0);
        
        // Repeat until we get them all ...
        do {
            // Room to grow 
            size += size / 10;
            newprocs = realloc(procs, size);
            if (!newprocs) {
                if (procs) {
                    free(procs);
                }
                perror("Error: realloc failed.");
                return (0);
            }
            procs = newprocs;
            st = sysctl(mib, miblen, procs, &size, NULL, 0);
        } while (st == -1 && errno == ENOMEM);
        
        if (st != 0) {
            perror("Error: sysctl(KERN_PROC) failed.");
            return (0);
        }
        
        // Do we match the kernel?
        assert(size % sizeof(struct kinfo_proc) == 0);
        
        nprocs = size / sizeof(struct kinfo_proc);
        
        if (!nprocs) {
            perror("Error: printProcessInfo.");
            return(0);
        }
        printf("  PID\tName\n");
        printf("-----\t--------------\n");
        for (i = nprocs-1; i >=0;  i--) {
            printf("%5d\t%s\n",(int)procs[i].kp_proc.p_pid, procs[i].kp_proc.p_comm);
        }
        free(procs);
        return (0);

}*/

- (void)dealloc
{
    /*[othersView release];
    [netView release];
    [view1 release];
    [_view release];
    //[device1 release];
    [realIP release];
    [localIP release];
    [deviceName release];
    [deviceModel release];
    [memoryWired release];
    [memoryInactive release];
    [memoryActive release];
    [memoryFree release];*/
    [scroll release];
    [super dealloc];

}

-(void)respring{
    
    system("killall SpringBoard");
}

-(void)refreshWIFI{
   // NSAutoreleasePool *threadPool=[[NSAutoreleasePool alloc]init];

    if([myDevice performWiFiCheck]){
        localIP.text = [NSString stringWithFormat:@"Wi-Fi IP: %@",[myDevice localWiFiIPAddress]];
    }else{
        localIP.text = [NSString stringWithFormat:@"Wi-Fi IP: %@",[locBundle localizedStringForKey:@"not_conn" value:@"not connected" table:nil]];
    }
    if([myDevice performNetCheck]){
        realIP.text = [NSString stringWithFormat:@"%@ IP: %@",[locBundle localizedStringForKey:@"public" value:@"Public" table:nil],[myDevice whatismyipdotcom]];
        
    }else{
        realIP.text = [NSString stringWithFormat:@"%@ IP: %@",[locBundle localizedStringForKey:@"public" value:@"Public" table:nil],[locBundle localizedStringForKey:@"not_conn" value:@"not connected" table:nil]];
    }
    //[threadPool release];
}
-(void)qwe{
    [self performSelectorInBackground:@selector(refreshWIFI)withObject:nil];
}
/*-(void)batRefresh{
  // NSAutoreleasePool *threadPool=[[NSAutoreleasePool alloc]init];
    batLevel.text = [NSString stringWithFormat:@"%@: %i%%",[locBundle localizedStringForKey:@"battery" value:@"Battery" table:nil],[self batteryValue]];

    if (6>=[self batteryValue]) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_2.png"];
    }else if ((6<[self batteryValue])&&(13>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_3.png"];
    }else if ((13<[self batteryValue])&&(20>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_4.png"];
    }else if ((20<[self batteryValue])&&(25>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_5.png"];
    }else if ((25<[self batteryValue])&&(31>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_6.png"];
    }else if ((31<[self batteryValue])&&(37>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_7.png"];
    }else if ((37<[self batteryValue])&&(43>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_8.png"];
    }else if ((43<[self batteryValue])&&(49>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_9.png"];
    }else if ((49<[self batteryValue])&&(55>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_10.png"];
    }else if ((55<[self batteryValue])&&(61>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_11.png"];
    }else if ((61<[self batteryValue])&&(67>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_12.png"];
    }else if ((67<[self batteryValue])&&(73>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_13.png"];
    }else if ((73<[self batteryValue])&&(79>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_14.png"];
    }else if ((79<[self batteryValue])&&(85>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_15.png"];
    }else if ((85<[self batteryValue])&&(91>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_16.png"];
    }else if ((91<[self batteryValue])&&(100>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_17.png"];
    }
    
    if (myDevice.batteryState==UIDeviceBatteryStateCharging) {
        [othersView addSubview:charging];
        //batStatus.text=[NSString stringWithFormat:@"Статус: \nЗаряжается"];
        
    }else{
        [charging removeFromSuperview];
        // batStatus.text=[NSString stringWithFormat:@"Статус: \nРазряжается"];
    }
   // [threadPool release];
}*/
-(void)ert{
    [self performSelectorInBackground:@selector(refresh) withObject:nil];
}
-(NSString*)colorAndCapacity{
    NSString *ret=[[NSString alloc]init];
    if ([[myDevice serialnumber] hasSuffix:@"A4T"]) {
        ret=[NSString stringWithFormat:@"(%@)32GB",[locBundle localizedStringForKey:@"black" value:@"BL" table:nil]];
    }else if ([[myDevice serialnumber] hasSuffix:@"A4S"]) {
        ret=[NSString stringWithFormat:@"(%@)16GB",[locBundle localizedStringForKey:@"black" value:@"BL" table:nil]];
    }else{
        if ([[myDevice serialnumber] hasSuffix:@"T"]) {
            ret=[NSString stringWithFormat:@"(%@)32GB",[locBundle localizedStringForKey:@"white" value:@"WHT" table:nil]];
        }else if ([[myDevice serialnumber] hasSuffix:@"S"]) {
            ret=[NSString stringWithFormat:@"(%@)16GB",[locBundle localizedStringForKey:@"white" value:@"WHT" table:nil]];
        }
    }
    return ret;
    [ret release];
}
-(void)refresh{
   // NSAutoreleasePool *threadPool=[[NSAutoreleasePool alloc]init];

    //[memoryFree retain];
    //[memoryInactive retain];
    //[memoryWired retain];
    //[memoryActive retain];
    //[batLevel retain];

    /*if([myDevice performWiFiCheck]){
        localIP.text = [NSString stringWithFormat:@"Wi-Fi IP: %@",[myDevice localWiFiIPAddress]];
    }else{
        localIP.text = @"";
    }
    if([myDevice performNetCheck]){
        realIP.text = [NSString stringWithFormat:@"Внешний IP: %@",[myDevice whatismyipdotcom]];
        
    }else{
        realIP.text = @"Внешний IP: нет доступа к сети Интернет";
    }*/
    
    batLevel.text = [NSString stringWithFormat:@"%@: %i%%",[locBundle localizedStringForKey:@"battery" value:@"Battery" table:nil],[self batteryValue]];
    
    if (6>=[self batteryValue]) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_2.png"];
    }else if ((6<[self batteryValue])&&(13>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_3.png"];
    }else if ((13<[self batteryValue])&&(19>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_4.png"];
    }else if ((19<[self batteryValue])&&(25>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_5.png"];
    }else if ((25<[self batteryValue])&&(31>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_6.png"];
    }else if ((31<[self batteryValue])&&(37>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_7.png"];
    }else if ((37<[self batteryValue])&&(43>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_8.png"];
    }else if ((43<[self batteryValue])&&(49>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_9.png"];
    }else if ((49<[self batteryValue])&&(55>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_10.png"];
    }else if ((55<[self batteryValue])&&(61>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_11.png"];
    }else if ((61<[self batteryValue])&&(67>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_12.png"];
    }else if ((67<[self batteryValue])&&(73>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_13.png"];
    }else if ((73<[self batteryValue])&&(79>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_14.png"];
    }else if ((79<[self batteryValue])&&(85>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_15.png"];
    }else if ((85<[self batteryValue])&&(91>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_16.png"];
    }else if ((91<[self batteryValue])&&(100>=[self batteryValue])) {
        batteryIm.image=[UIImage imageWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/BatteryBG_17.png"];
    }
    
    if (myDevice.batteryState==UIDeviceBatteryStateCharging) {
        [othersView addSubview:charging];
       // batStatus.text=@"Статус: \nЗаряжается";
        
    }else{
        [charging removeFromSuperview];
        //batStatus.text=@"Статус: \nРазряжается";
    }
    [self getmemory];
    memoryFree.text = [NSString stringWithFormat:@"%@: %@МB",[locBundle localizedStringForKey:@"Free" value:@"Free" table:nil],mem_free];
    memoryActive.text = [NSString stringWithFormat:@"%@: %@МB",[locBundle localizedStringForKey:@"Active" value:@"Active" table:nil],mem_active];
    memoryInactive.text = [NSString stringWithFormat:@"%@: %@МB",[locBundle localizedStringForKey:@"Inactive" value:@"Inactive" table:nil],mem_inactive];
    memoryWired.text = [NSString stringWithFormat:@"%@: %@МB",[locBundle localizedStringForKey:@"Wired" value:@"Wired" table:nil],mem_wired];
    /*if ((myDevice.orientation==UIDeviceOrientationLandscapeRight)||(myDevice.orientation==UIDeviceOrientationLandscapeLeft)) {
        _view.frame=CGRectMake(2, 0, 476.0, 90.0);
        view1.frame=CGRectMake(2, 0, 476.0, 90.0);
        netView.frame=CGRectMake(2, 0, 476.0, 90.0);
        othersView.frame=CGRectMake(2, 0, 476.0, 90.0);
        adsView.frame=CGRectMake(2, 0, 476.0, 90.0);
    }else{
        _view.frame=CGRectMake(2, 0, 316.0, 90.0);
        view1.frame=CGRectMake(2, 0, 316.0, 90.0);
        netView.frame=CGRectMake(2, 0, 316.0, 90.0);
        othersView.frame=CGRectMake(2, 0, 316.0, 90.0);
        adsView.frame=CGRectMake(2, 0, 316.0, 90.0);    
    }*/
    //[mem_active release];
    //[mem_free release];
    //[mem_inactive release];
    //[mem_wired release];
    //[batLevel release];
    //[threadPool release];
}
-(void)info{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iMonitor Widget" message:@"Developer: iT0ny.\nSpecial thanks to ILYA2606.\nMade in Russia(ex-USSR)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];

}
- (id)view
{  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];

    //NSAutoreleasePool *threadPool=[[NSAutoreleasePool alloc]init];

    UIImage *bg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/background.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:90];
    device1 = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (scroll == nil)
    {
    locBundle=[NSBundle bundleWithPath:[NSString stringWithFormat:@"/System/Library/WeeAppPlugins/iMonitor.bundle/%@.lproj",currentLanguage]];
       NSAutoreleasePool *threadPool1=[[NSAutoreleasePool alloc]init];

        //главный!!!
        scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(2, 0, 320, 90)];
        //настраиваем скролл
        [scroll setBackgroundColor:[UIColor clearColor]];
        [scroll setCanCancelContentTouches:NO];
        scroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scroll.clipsToBounds = YES;
        scroll.scrollEnabled = YES;
        scroll.showsHorizontalScrollIndicator=0;
        scroll.pagingEnabled = YES;
//настроили главного!
        
        //девайс
        myDevice=[UIDevice currentDevice]; 
        myDevice.batteryMonitoringEnabled=YES;
        //       
        //Таймер
        timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ert) userInfo:nil repeats:YES];
        //[timer performSelectorInBackground:@selector(fire)withObject:nil];
        thread1=[[NSThread alloc]initWithTarget:timer selector:@selector(fire) object:nil];
        [thread1 start];
        timer1=[[NSTimer alloc]init];
        timer1=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(qwe) userInfo:nil repeats:YES];
        [timer1 performSelectorInBackground:@selector(fire) withObject:nil];
        //
        //кнопка респринг
        respringButton = [UIButton buttonWithType:UIButtonTypeCustom];
        respringButton.frame=CGRectMake(275, -4, 40, 50);
        [respringButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/re.png"] forState:UIControlStateNormal];
        [respringButton addTarget:self action:@selector(respring)forControlEvents:UIControlEventTouchDown];
        //кнопки конец
        UIButton *infoButton=[UIButton buttonWithType:UIButtonTypeInfoLight];
        infoButton.frame=CGRectMake(284, 57, 40.0, 40.0);
        [infoButton addTarget:self action:@selector(info)forControlEvents:UIControlEventTouchDown];
     
        //вид1
        UIImageView *bgView1 = [[UIImageView alloc] initWithImage:bg];
        bgView1.frame = CGRectMake(0, 0, 316.0, 90.0);
        view1 = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316.0, 90.0)];
        [view1 addSubview:bgView1];
        [bgView1 release];
        //
        
        //вид2 
        _view = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316.0, 90.0)];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
        bgView.frame = CGRectMake(0, 0, 316.0, 90.0);
        [_view addSubview:bgView];
        [bgView release];
    
        //
        
        //вид3
        othersView=[[UIView alloc]initWithFrame:CGRectMake(2, 0, 316.0, 90.0)];
        UIImageView *bgView2 = [[UIImageView alloc] initWithImage:bg];
        bgView2.frame = CGRectMake(0, 0, 316.0, 90.0);
        [othersView addSubview:bgView2];
        [bgView2 release];
        myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/lighter_off.png"] forState:UIControlStateNormal];
        myButton.frame = CGRectMake(280, 45, 40.0, 40.0);
        if ([device1 hasTorch] && [device1 hasFlash])
            [myButton setEnabled:YES];
        else
            [myButton setEnabled:NO];
        [myButton addTarget:self action:@selector(Flash)forControlEvents:UIControlEventTouchDown];  
        charging=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/charging.png"]];
        charging.frame=CGRectMake(185.5, 18, 70, 50);
        batteryIm = [[UIImageView alloc] init];
        batteryIm.frame = CGRectMake(110, -7.5, 225, 85.0);

        //
        
        //вид4(сеть)
        netView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316.0, 90.0)];
        UIImageView *netBgView = [[UIImageView alloc] initWithImage:bg];
        netBgView.frame = CGRectMake(0, 0, 316.0, 90.0);
        [netView addSubview:netBgView];
        [netBgView release];
  
                
        //реклама
        
        //рекламная
        adsView=[[UIView alloc]initWithFrame:CGRectMake(2, 0, 316.0, 90.0)];
        UIImageView *bgView3 = [[UIImageView alloc] initWithImage:bg];
        bgView3.frame = CGRectMake(0, 0, 316.0, 90.0);
        UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/iMonitor.bundle/stat.png"]];
        icon.frame=CGRectMake(30, 14.5, 70.0, 70.0);
        [adsView addSubview:bgView3];
        [adsView addSubview:icon];
        
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(90, 14.5, 316.0, 70.0)]; 
        tv.text=[locBundle localizedStringForKey:@"ad" value:@"ad" table:nil];
        tv.backgroundColor = [UIColor clearColor];
        tv.font=[UIFont systemFontOfSize:16];
        tv.textColor = [UIColor whiteColor];
        tv.editable=NO;
        [adsView addSubview:tv];  
        [tv release];
        
        
    //главная страница:
     
    //девайс имя    
    deviceName = [[UILabel alloc] initWithFrame:CGRectMake(2, 7, 200, fontSize)];
    deviceName.backgroundColor = [UIColor clearColor];
    deviceName.textColor = [UIColor whiteColor];
    deviceName.text = [NSString stringWithFormat:@"%@: %@",[locBundle localizedStringForKey:@"name" value:@"Name" table:nil],myDevice.name];
    deviceName.textAlignment = UITextAlignmentLeft;
    deviceName.font=[UIFont systemFontOfSize:fontSize];
        //
     
            //    
        
        
        
    //девайс    
    deviceModel = [[UILabel alloc] initWithFrame:CGRectMake(2, 23, 300, fontSize)];
    deviceModel.backgroundColor = [UIColor clearColor];
    deviceModel.textColor = [UIColor whiteColor];
    deviceModel.text = [NSString stringWithFormat:@"%@: %@%@,iOS %@(%@)",[locBundle localizedStringForKey:@"device" value:@"Device" table:nil],[self deviceCheck],[self colorAndCapacity],myDevice.systemVersion,[myDevice buildVersion]];
    deviceModel.textAlignment = UITextAlignmentLeft;
    deviceModel.font=[UIFont systemFontOfSize:fontSize];
    //
      
    //имей лейбл
    UILabel *imei = [[UILabel alloc] initWithFrame:CGRectMake(2, 58, 200, fontSize)];
    imei.backgroundColor = [UIColor clearColor];
    imei.textColor = [UIColor whiteColor];
    imei.text = [NSString stringWithFormat:@"IMEI: %@",[myDevice imei]];
    imei.textAlignment = UITextAlignmentLeft;
    imei.font=[UIFont systemFontOfSize:fontSize];
        
    //   
        
    //сериал лейбл
    UILabel *serialNumber = [[UILabel alloc] initWithFrame:CGRectMake(2, 40, 200, fontSize)];
    serialNumber.backgroundColor = [UIColor clearColor];
    serialNumber.textColor = [UIColor whiteColor];
        serialNumber.text = [NSString stringWithFormat:@"Serial №: %@",[myDevice serialnumber]];
    serialNumber.textAlignment = UITextAlignmentLeft;
    serialNumber.font=[UIFont systemFontOfSize:fontSize];
        
        //   
        
        
    //удид лейбл
    UILabel *udid = [[UILabel alloc] initWithFrame:CGRectMake(2, 72, 280, fontSize)];
    udid.backgroundColor = [UIColor clearColor];
    udid.textColor = [UIColor whiteColor];
        udid.text = [NSString stringWithFormat:@"UDID: %@",myDevice.uniqueIdentifier];
    udid.textAlignment = UITextAlignmentLeft;
   // udid.font=[UIFont systemFontOfSize:fontSize];
   udid.adjustsFontSizeToFitWidth=YES;    
    //

   ///вторая страница     
       // @"айСтатистика\nВерсия в виде приложения.\nДоступна в Appstore";

    ///память   
    //RAM
    //вся
        UILabel *memoryAll = [[UILabel alloc] initWithFrame:CGRectMake(2, 72, 160, fontSize)];
        memoryAll.backgroundColor = [UIColor clearColor];
        memoryAll.textColor = [UIColor whiteColor];
        memoryAll.text = [NSString stringWithFormat:@"%@: %iМB",[locBundle localizedStringForKey:@"tot" value:@"Total" table:nil],[myDevice totalMemory]/1048576];
        memoryAll.textAlignment = UITextAlignmentLeft;
        memoryAll.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:memoryAll];
        [memoryAll release];
        //свободная    
    memoryFree = [[UILabel alloc] initWithFrame:CGRectMake(2, 57, 160, fontSize)];
    memoryFree.backgroundColor = [UIColor clearColor];
    memoryFree.textColor = [UIColor whiteColor];
   // memoryFree.text = [NSString stringWithFormat:@"Свободно: %.1fМB",mem_free/1048576.0];
    memoryFree.textAlignment = UITextAlignmentLeft;
    memoryFree.font=[UIFont systemFontOfSize:fontSize];
    [_view addSubview:memoryFree];

    //Активная
    memoryActive=[[UILabel alloc] initWithFrame:CGRectMake(2, 13, 160, fontSize)];
    memoryActive.backgroundColor = [UIColor clearColor];
    memoryActive.textColor = [UIColor whiteColor];
   // memoryActive.text = [NSString stringWithFormat:@"Активная: %.1fМB",mem_active/1048576.0];
    memoryActive.textAlignment = UITextAlignmentLeft;
    memoryActive.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:memoryActive];

    //Неактивная
    memoryInactive=[[UILabel alloc] initWithFrame:CGRectMake(2, 25, 160, fontSize)];
    memoryInactive.backgroundColor = [UIColor clearColor];
    memoryInactive.textColor = [UIColor whiteColor];
   // memoryInactive.text = [NSString stringWithFormat:@"Нективная: %.1fМB",mem_inactive/1048576.0];
    memoryInactive.textAlignment = UITextAlignmentLeft;
    memoryInactive.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:memoryInactive];
    
    //Резервная
    memoryWired=[[UILabel alloc] initWithFrame:CGRectMake(2, 41, 160, fontSize)];
    memoryWired.backgroundColor = [UIColor clearColor];
    memoryWired.textColor = [UIColor whiteColor];
    //memoryWired.text = [NSString stringWithFormat:@"Резервная: %.1fМB",mem_wired/1048576.0];
    memoryWired.textAlignment = UITextAlignmentLeft;
    memoryWired.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:memoryWired];

    //Flash  
    
    //вся память
        UILabel *freeFlash = [[UILabel alloc] initWithFrame:CGRectMake(180, 41, 316, fontSize)];
        freeFlash.backgroundColor = [UIColor clearColor];
        freeFlash.textColor = [UIColor whiteColor];
        freeFlash.text = [NSString stringWithFormat:@"%@: %.2fGB",[locBundle localizedStringForKey:@"fre" value:@"Free" table:nil],[[myDevice freeDiskSpace] floatValue]/1073741824.0];
        freeFlash.textAlignment = UITextAlignmentLeft;
        freeFlash.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:freeFlash];
        [freeFlash release];
        //вся память
        UILabel *usedFlash = [[UILabel alloc] initWithFrame:CGRectMake(180, 57, 316, fontSize)];
        usedFlash.backgroundColor = [UIColor clearColor];
        usedFlash.textColor = [UIColor whiteColor];
        usedFlash.text = [NSString stringWithFormat:@"%@: %.2fGB",[locBundle localizedStringForKey:@"used" value:@"Used" table:nil],([[myDevice totalDiskSpace] floatValue]/1073741824.0)-([[myDevice freeDiskSpace] floatValue]/1073741824.0)];
        usedFlash.textAlignment = UITextAlignmentLeft;
        usedFlash.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:usedFlash];
        [usedFlash release];
        //вся память
        UILabel *totalFlash = [[UILabel alloc] initWithFrame:CGRectMake(180, 72, 316, fontSize)];
        totalFlash.backgroundColor = [UIColor clearColor];
        totalFlash.textColor = [UIColor whiteColor];
        totalFlash.text = [NSString stringWithFormat:@"%@: %.2fGB",[locBundle localizedStringForKey:@"tot" value:@"Total" table:nil],[[myDevice totalDiskSpace] floatValue]/1073741824.0];
        totalFlash.textAlignment = UITextAlignmentLeft;
        totalFlash.font=[UIFont systemFontOfSize:fontSize];
        [_view addSubview:totalFlash];
        [totalFlash release];

        ///память конец
    //
     
     //третья страница   
        //////уровень батареи    
        batLevel = [[UILabel alloc] initWithFrame:CGRectMake(2, 35.5, 150, 17)];
        batLevel.backgroundColor = [UIColor clearColor];
        batLevel.textColor = [UIColor whiteColor];
       // batLevel.text = [NSString stringWithFormat:@"Батарея: %i%%",[self batteryValue]];
        batLevel.textAlignment = UITextAlignmentLeft;
        //batLevel.font=[UIFont systemFontOfSize:fontSize];

        /*batStatus = [[UITextView alloc] initWithFrame:CGRectMake(2, 35, 150, 100.0)]; 
        batStatus.backgroundColor = [UIColor clearColor];
        batStatus.textColor = [UIColor whiteColor];
        batStatus.editable=NO;
        //[batStatus setEnabled:NO];
*/
        
    //Cтраница сеть(4)
        //mac-aдрес
        UILabel *macAdress=[[UILabel alloc] initWithFrame:CGRectMake(2, 70, 316, fontSize)];
        macAdress.backgroundColor = [UIColor clearColor];
        macAdress.textColor = [UIColor whiteColor];
        macAdress.text=[NSString stringWithFormat:@"MAC-%@: %@",[locBundle localizedStringForKey:@"addr" value:@"address" table:nil],[myDevice macaddress]];
        macAdress.textAlignment = UITextAlignmentLeft;
        macAdress.font=[UIFont systemFontOfSize:fontSize];    
        
        //реальный айпи
        realIP=[[UILabel alloc] initWithFrame:CGRectMake(2, 55, 316, fontSize)];
        realIP.backgroundColor = [UIColor clearColor];
        realIP.textColor = [UIColor whiteColor];
        realIP.textAlignment = UITextAlignmentLeft;
        realIP.font=[UIFont systemFontOfSize:fontSize];    
        
        //локальный айпи
        localIP=[[UILabel alloc] initWithFrame:CGRectMake(2, 40, 316, fontSize)];
        localIP.backgroundColor = [UIColor clearColor];
        localIP.textColor = [UIColor whiteColor];
        localIP.textAlignment = UITextAlignmentLeft;
        localIP.font=[UIFont systemFontOfSize:fontSize];   
    ///    
        
    
        
        /*UILabel *mainDev = [[UILabel alloc] initWithFrame:CGRectMake(2, 57, 200, 17)];
        mainDev.backgroundColor = [UIColor clearColor];
        mainDev.textColor = [UIColor whiteColor];
        mainDev.text = @"Developer: iT0ny(Russia).\nSpecial thanks to ILYA2606(Russia).";
        mainDev.textAlignment = UITextAlignmentLeft;
        
        UILabel *ilya = [[UILabel alloc] initWithFrame:CGRectMake(2, 25, 200, 17)];
        ilya.backgroundColor = [UIColor clearColor];
        ilya.textColor = [UIColor whiteColor];
        ilya.text = @"Also special thanks to Developer: ILYA2606(Russia)!:)";
        ilya.textAlignment = UITextAlignmentLeft;
        
        UIImageView *infoBg = [[UIImageView alloc] initWithImage:bg];
        infoBg.frame = CGRectMake(0, 0, 316.0, 90.0);
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316.0, 90.0)];
        [infoView addSubview:infoBg];
        [infoBg release];
        [infoView addSubview:mainDev];
        [infoView addSubview:ilya];*/

        //добавляем сабвью в страницы
                

        [bg release];
        [view1 addSubview:udid];
        [view1 addSubview:deviceName];
        [view1 addSubview:deviceModel];
        [view1 addSubview:imei];
        [view1 addSubview:myButton];
        [view1 addSubview:serialNumber];
        [view1 addSubview:respringButton];

        
        [othersView addSubview:batLevel];
        [othersView addSubview:batteryIm];
        [batteryIm release];
        [batLevel release];
        //[myButton release];
        [netView addSubview:realIP];
        [netView addSubview:localIP];
        [netView addSubview:macAdress];
        [netView addSubview:infoButton];
        
        //добавляем скролл в окно
               //добавляем вьюшки
        [scroll addSubview:view1];
        [scroll addSubview:_view];
        [scroll addSubview:othersView];
        [scroll addSubview:netView];
        [scroll addSubview:adsView];
        [adsView release];
        //[othersView release];
        //[netView release];
        //[view1 release];
        //[_view release];
        //располагаем вьюшки по порядку
        [self layoutScrollImages];
        [threadPool1 release];
}
    return scroll;
   //[threadPool release];
}
+ (void)initialize
{
}

- (float)viewHeight
{
    return 90.0f;
}

/*Девайсы:
 iPhone1,1 == iPhone
 iPhone1,2 == iPhone 3G
 iPhone2,1 == iPhone 3GS
 iPhone3,1 == iPhone 4
 iPhone3,3 == iPhone 4 CDMA
 iPod1,1 == iPod Touch
 iPod2,1 == iPod Touch 1G
 iPod3,1 == iPod Touch 3G
 iPod4,1 == iPod Touch 4G
 iPad1,1 == iPad
 iPad2,1 == iPad 2 Wi-Fi
 iPad2,2 == iPad 2 Wi-Fi+3G
 iPad2,3 == iPad 2 CDMA
 */
//определение девайса
-(NSString*)machineName{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}
-(NSString*)deviceCheck{
    NSString *device;
    if([[self machineName] isEqualToString:@"iPhone3,1"])
    {
        device=@"iPhone 4";
    }else if([[self machineName] isEqualToString:@"iPhone3,3"])
    {
        device=@"iPhone 4 CDMA";
    } else if([[self machineName] isEqualToString:@"iPhone1,1"]){
        device=@"iPhone";
    } else if([[self machineName] isEqualToString:@"iPhone1,2"]){
        device=@"iPhone 3G";
    }else if([[self machineName] isEqualToString:@"iPhone2,1"]){
        device=@"iPhone 3GS";
    }else if([[self machineName] isEqualToString:@"iPod1,1"]){
        device=@"iPod Touch";
    }else if([[self machineName] isEqualToString:@"iPod2,1"]){
        device=@"iPod Touch 2G";
    }else if([[self machineName] isEqualToString:@"iPod3,1"]){
        device=@"iPod Touch 3G";
    } else if([[self machineName] isEqualToString:@"iPod4,1"]){
        device=@"iPod Touch 4G";
    } else if([[self machineName] isEqualToString:@"iPad1,1"]){
        device=@"iPad 1G";
    } else if([[self machineName] isEqualToString:@"iPad2,1"]){
        device=@"iPad 2 Wi-Fi";
    } else if([[self machineName] isEqualToString:@"iPad2,2"]){
        device=@"iPad 2 Wi-Fi+3G";
    } else if([[self machineName] isEqualToString:@"iPad2,3"]){
        device=@"iPad 2 CDMA";
    } else {
        device=@"Unknown iDevice";
    }
    return device;
}
//конец определения


#pragma mark - View lifecycle
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//Получеам точное значение батареи 

-(int)batteryValue{
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
	CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
	int curCapacity = 0;
	int maxCapacity = 0;
	CFDictionaryRef pSource = NULL;
	const void *psValue;
	int numOfSources = CFArrayGetCount(sources);
    for (int i = 0 ; i < numOfSources ; i++)
	{
        
	pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
	psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
	
	psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
	CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
	
	psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
	CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
	}
	 return (int)((double)curCapacity/(double)maxCapacity * 100);
}

@end