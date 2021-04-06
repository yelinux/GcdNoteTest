//
//  ViewController.m
//  GcdNoteTest
//
//  Created by chenyehong on 2021/3/26.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (assign, nonatomic) double randomNum;

@end

@implementation ViewController

-(double)randomNum{
    return (arc4random() % 10) / 10.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//同步任务+串行队列
- (IBAction)click0:(id)sender {
    NSLog(@"click - currentThread-1:%@", [NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_SERIAL);
    
    for(NSInteger i = 0 ; i < 10 ; i++){
        dispatch_sync(queue, ^{
            [NSThread sleepForTimeInterval:self.randomNum];
            NSLog(@"b - currentThread-%ld:%@", i,  [NSThread currentThread]);
        });
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%ld:%@", i, [NSThread currentThread]);
    }
    
//    2021-04-06 09:00:58.269337+0800 GcdNoteTest[30952:4935063] click - currentThread-1:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:00:59.069918+0800 GcdNoteTest[30952:4935063] b - currentThread-0:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:00:59.170726+0800 GcdNoteTest[30952:4935063] for - currentThread-0:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:00:59.672412+0800 GcdNoteTest[30952:4935063] b - currentThread-1:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:00:59.974290+0800 GcdNoteTest[30952:4935063] for - currentThread-1:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:00.875693+0800 GcdNoteTest[30952:4935063] b - currentThread-2:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:01.476865+0800 GcdNoteTest[30952:4935063] for - currentThread-2:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:02.178486+0800 GcdNoteTest[30952:4935063] b - currentThread-3:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:02.179157+0800 GcdNoteTest[30952:4935063] for - currentThread-3:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:02.279825+0800 GcdNoteTest[30952:4935063] b - currentThread-4:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:02.581765+0800 GcdNoteTest[30952:4935063] for - currentThread-4:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:03.083601+0800 GcdNoteTest[30952:4935063] b - currentThread-5:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:03.084178+0800 GcdNoteTest[30952:4935063] for - currentThread-5:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:03.084729+0800 GcdNoteTest[30952:4935063] b - currentThread-6:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:03.685384+0800 GcdNoteTest[30952:4935063] for - currentThread-6:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:03.685983+0800 GcdNoteTest[30952:4935063] b - currentThread-7:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:04.287483+0800 GcdNoteTest[30952:4935063] for - currentThread-7:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:04.788371+0800 GcdNoteTest[30952:4935063] b - currentThread-8:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:05.189141+0800 GcdNoteTest[30952:4935063] for - currentThread-8:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:06.090878+0800 GcdNoteTest[30952:4935063] b - currentThread-9:<NSThread: 0x6000004f0540>{number = 1, name = main}
//    2021-04-06 09:01:06.391605+0800 GcdNoteTest[30952:4935063] for - currentThread-9:<NSThread: 0x6000004f0540>{number = 1, name = main}


    //从上面代码运行的结果可以看出，并没有开启新的线程，任务是按顺序执行的。
}

//同步任务+并发队列
- (IBAction)click1:(id)sender {
    NSLog(@"click - currentThread-1:%@", [NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_CONCURRENT);
    
    for(NSInteger i = 0 ; i < 10 ; i++){
        dispatch_sync(queue, ^{
            [NSThread sleepForTimeInterval:self.randomNum];
            NSLog(@"b - currentThread-%ld:%@", i,  [NSThread currentThread]);
        });
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%ld:%@", i, [NSThread currentThread]);
    }
    
//    2021-04-06 09:02:14.910238+0800 GcdNoteTest[30979:4936249] click - currentThread-1:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:15.811987+0800 GcdNoteTest[30979:4936249] b - currentThread-0:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:16.314203+0800 GcdNoteTest[30979:4936249] for - currentThread-0:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:16.314867+0800 GcdNoteTest[30979:4936249] b - currentThread-1:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:16.816356+0800 GcdNoteTest[30979:4936249] for - currentThread-1:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:17.717957+0800 GcdNoteTest[30979:4936249] b - currentThread-2:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:18.418730+0800 GcdNoteTest[30979:4936249] for - currentThread-2:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:18.720620+0800 GcdNoteTest[30979:4936249] b - currentThread-3:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:19.422807+0800 GcdNoteTest[30979:4936249] for - currentThread-3:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:20.224695+0800 GcdNoteTest[30979:4936249] b - currentThread-4:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:21.125595+0800 GcdNoteTest[30979:4936249] for - currentThread-4:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:21.227652+0800 GcdNoteTest[30979:4936249] b - currentThread-5:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:21.329498+0800 GcdNoteTest[30979:4936249] for - currentThread-5:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:21.731374+0800 GcdNoteTest[30979:4936249] b - currentThread-6:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:22.232531+0800 GcdNoteTest[30979:4936249] for - currentThread-6:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:22.834414+0800 GcdNoteTest[30979:4936249] b - currentThread-7:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:22.835002+0800 GcdNoteTest[30979:4936249] for - currentThread-7:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:22.835425+0800 GcdNoteTest[30979:4936249] b - currentThread-8:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:23.335856+0800 GcdNoteTest[30979:4936249] for - currentThread-8:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:24.036415+0800 GcdNoteTest[30979:4936249] b - currentThread-9:<NSThread: 0x600000a8c880>{number = 1, name = main}
//    2021-04-06 09:02:24.437038+0800 GcdNoteTest[30979:4936249] for - currentThread-9:<NSThread: 0x600000a8c880>{number = 1, name = main}


//    从上面代码运行的结果可以看出，同步任务不会开启新的线程，虽然任务在并发队列中，但是系统只默认开启了一个主线程，没有开启子线程，所以任务串行执行。
}

//异步任务+串行队列
- (IBAction)click2:(id)sender {
    NSLog(@"click - currentThread-1:%@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_SERIAL);
    for(NSInteger i = 0 ; i < 10 ; i++){
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:self.randomNum];
            NSLog(@"b - currentThread-%ld:%@", i,  [NSThread currentThread]);
        });
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%ld:%@", i, [NSThread currentThread]);
    }
    
//    2021-03-26 13:39:18.869336+0800 GcdNoteTest[71485:2314466] click - currentThread-1:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.869683+0800 GcdNoteTest[71485:2314466] for - currentThread-0:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.869717+0800 GcdNoteTest[71485:2314538] b - currentThread-0:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.869956+0800 GcdNoteTest[71485:2314466] for - currentThread-1:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.869978+0800 GcdNoteTest[71485:2314538] b - currentThread-1:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.870218+0800 GcdNoteTest[71485:2314538] b - currentThread-2:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.870228+0800 GcdNoteTest[71485:2314466] for - currentThread-2:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.870596+0800 GcdNoteTest[71485:2314466] for - currentThread-3:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.870614+0800 GcdNoteTest[71485:2314538] b - currentThread-3:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.870993+0800 GcdNoteTest[71485:2314466] for - currentThread-4:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.871315+0800 GcdNoteTest[71485:2314466] for - currentThread-5:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.871642+0800 GcdNoteTest[71485:2314466] for - currentThread-6:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.872073+0800 GcdNoteTest[71485:2314466] for - currentThread-7:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.872419+0800 GcdNoteTest[71485:2314466] for - currentThread-8:<NSThread: 0x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.872707+0800 GcdNoteTest[71485:2314466] for - currentThread-9:<NSThread: 02021-03-26 13:39:18.872995+0800 GcdNoteTest[71485:2314538] b - currentThread-4:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    x6000026543c0>{number = 1, name = main}
//    2021-03-26 13:39:18.914183+0800 GcdNoteTest[71485:2314538] b - currentThread-5:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.914346+0800 GcdNoteTest[71485:2314538] b - currentThread-6:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.914502+0800 GcdNoteTest[71485:2314538] b - currentThread-7:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.914637+0800 GcdNoteTest[71485:2314538] b - currentThread-8:<NSThread: 0x600002641240>{number = 6, name = (null)}
//    2021-03-26 13:39:18.914831+0800 GcdNoteTest[71485:2314538] b - currentThread-9:<NSThread: 0x600002641240>{number = 6, name = (null)}
///加延时后
//    2021-04-06 09:03:48.118416+0800 GcdNoteTest[31001:4937181] click - currentThread-1:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:48.322347+0800 GcdNoteTest[31001:4937359] b - currentThread-0:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:48.820065+0800 GcdNoteTest[31001:4937181] for - currentThread-0:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:48.925241+0800 GcdNoteTest[31001:4937359] b - currentThread-1:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:49.322233+0800 GcdNoteTest[31001:4937181] for - currentThread-1:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:49.723917+0800 GcdNoteTest[31001:4937181] for - currentThread-2:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:49.724213+0800 GcdNoteTest[31001:4937181] for - currentThread-3:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:49.725905+0800 GcdNoteTest[31001:4937359] b - currentThread-2:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:49.830705+0800 GcdNoteTest[31001:4937359] b - currentThread-3:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:50.625415+0800 GcdNoteTest[31001:4937181] for - currentThread-4:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:50.634808+0800 GcdNoteTest[31001:4937359] b - currentThread-4:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:50.736016+0800 GcdNoteTest[31001:4937359] b - currentThread-5:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:51.526320+0800 GcdNoteTest[31001:4937181] for - currentThread-5:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:52.128211+0800 GcdNoteTest[31001:4937181] for - currentThread-6:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:52.429793+0800 GcdNoteTest[31001:4937359] b - currentThread-6:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:52.729025+0800 GcdNoteTest[31001:4937181] for - currentThread-7:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:53.130292+0800 GcdNoteTest[31001:4937181] for - currentThread-8:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:53.130820+0800 GcdNoteTest[31001:4937181] for - currentThread-9:<NSThread: 0x600003204180>{number = 1, name = main}
//    2021-04-06 09:03:53.133484+0800 GcdNoteTest[31001:4937359] b - currentThread-7:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:53.737266+0800 GcdNoteTest[31001:4937359] b - currentThread-8:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}
//    2021-04-06 09:03:53.838456+0800 GcdNoteTest[31001:4937359] b - currentThread-9:<NSThread: 0x60000324b9c0>{number = 4, name = (null)}


//    从上面代码运行的结果可以看出，开启了一个新的线程，说明异步任务具备开启新的线程的能力，但是由于任务是在串行队列中执行的，所以任务是顺序执行的。
}

//异步任务+并发队列
- (IBAction)click3:(id)sender {
    NSLog(@"click - currentThread-1:%@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_CONCURRENT);
    for(NSInteger i = 0 ; i < 10 ; i++){
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:self.randomNum];
            NSLog(@"b - currentThread-%ld:%@", i,  [NSThread currentThread]);
        });
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%ld:%@", i, [NSThread currentThread]);
    }
//    2021-03-26 13:35:58.981875+0800 GcdNoteTest[71429:2311516] click - currentThread-1:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.982327+0800 GcdNoteTest[71429:2311516] for - currentThread-0:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.982372+0800 GcdNoteTest[71429:2311684] b - currentThread-0:<NSThread: 0x600003b55d40>{number = 6, name = (null)}
//    2021-03-26 13:35:58.982707+0800 GcdNoteTest[71429:2311516] for - currentThread-1:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.982767+0800 GcdNoteTest[71429:2311690] b - currentThread-1:<NSThread: 0x600003b2a340>{number = 5, name = (null)}
//    2021-03-26 13:35:58.983056+0800 GcdNoteTest[71429:2311516] for - currentThread-2:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.983080+0800 GcdNoteTest[71429:2311684] b - currentThread-2:<NSThread: 0x600003b55d40>{number = 6, name = (null)}
//    2021-03-26 13:35:58.983333+0800 GcdNoteTest[71429:2311516] for - currentThread-3:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.983346+0800 GcdNoteTest[71429:2311690] b - currentThread-3:<NSThread: 0x600003b2a340>{number = 5, name = (null)}
//    2021-03-26 13:35:58.983907+0800 GcdNoteTest[71429:2311516] for - currentThread-4:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.983936+0800 GcdNoteTest[71429:2311684] b - currentThread-4:<NSThread: 0x600003b55d40>{number = 6, name = (null)}
//    2021-03-26 13:35:58.984413+0800 GcdNoteTest[71429:2311516] for - currentThread-5:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:58.984537+0800 GcdNoteTest[71429:2311692] b - currentThread-5:<NSThread: 0x600003b32c80>{number = 7, name = (null)}
//    2021-03-26 13:35:59.023990+0800 GcdNoteTest[71429:2311516] for - currentThread-6:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:59.023990+0800 GcdNoteTest[71429:2311692] b - currentThread-6:<NSThread: 0x600003b32c80>{number = 7, name = (null)}
//    2021-03-26 13:35:59.024149+0800 GcdNoteTest[71429:2311516] for - currentThread-7:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:59.024264+0800 GcdNoteTest[71429:2311516] for - currentThread-8:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:59.024154+0800 GcdNoteTest[71429:2311692] b - currentThread-7:<NSThread: 0x600003b32c80>{number = 7, name = (null)}
//    2021-03-26 13:35:59.024334+0800 GcdNoteTest[71429:2311690] b - currentThread-8:<NSThread: 0x600003b2a340>{number = 5, name = (null)}
//    2021-03-26 13:35:59.024398+0800 GcdNoteTest[71429:2311516] for - currentThread-9:<NSThread: 0x600003b0c080>{number = 1, name = main}
//    2021-03-26 13:35:59.024406+0800 GcdNoteTest[71429:2311692] b - currentThread-9:<NSThread: 0x600003b32c80>{number = 7, name = (null)}
///加延时后
//    2021-04-06 09:05:53.198242+0800 GcdNoteTest[31051:4939259] click - currentThread-1:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:53.803021+0800 GcdNoteTest[31051:4939437] b - currentThread-0:<NSThread: 0x6000003795c0>{number = 6, name = (null)}
//    2021-04-06 09:05:54.099709+0800 GcdNoteTest[31051:4939259] for - currentThread-0:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:54.500839+0800 GcdNoteTest[31051:4939259] for - currentThread-1:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:54.701888+0800 GcdNoteTest[31051:4939259] for - currentThread-2:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:54.702633+0800 GcdNoteTest[31051:4939437] b - currentThread-1:<NSThread: 0x6000003795c0>{number = 6, name = (null)}
//    2021-04-06 09:05:54.807768+0800 GcdNoteTest[31051:4939439] b - currentThread-3:<NSThread: 0x600000330d00>{number = 4, name = (null)}
//    2021-04-06 09:05:55.103191+0800 GcdNoteTest[31051:4939259] for - currentThread-3:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:55.104148+0800 GcdNoteTest[31051:4939439] b - currentThread-4:<NSThread: 0x600000330d00>{number = 4, name = (null)}
//    2021-04-06 09:05:55.301515+0800 GcdNoteTest[31051:4939438] b - currentThread-2:<NSThread: 0x600000368500>{number = 7, name = (null)}
//    2021-04-06 09:05:55.504460+0800 GcdNoteTest[31051:4939259] for - currentThread-4:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:55.910114+0800 GcdNoteTest[31051:4939438] b - currentThread-5:<NSThread: 0x600000368500>{number = 7, name = (null)}
//    2021-04-06 09:05:56.106327+0800 GcdNoteTest[31051:4939259] for - currentThread-5:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:56.707169+0800 GcdNoteTest[31051:4939259] for - currentThread-6:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:56.710954+0800 GcdNoteTest[31051:4939438] b - currentThread-6:<NSThread: 0x600000368500>{number = 7, name = (null)}
//    2021-04-06 09:05:56.909871+0800 GcdNoteTest[31051:4939439] b - currentThread-7:<NSThread: 0x600000330d00>{number = 4, name = (null)}
//    2021-04-06 09:05:57.208736+0800 GcdNoteTest[31051:4939259] for - currentThread-7:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:57.209563+0800 GcdNoteTest[31051:4939439] b - currentThread-8:<NSThread: 0x600000330d00>{number = 4, name = (null)}
//    2021-04-06 09:05:57.310501+0800 GcdNoteTest[31051:4939259] for - currentThread-8:<NSThread: 0x600000330180>{number = 1, name = main}
//    2021-04-06 09:05:57.514190+0800 GcdNoteTest[31051:4939439] b - currentThread-9:<NSThread: 0x600000330d00>{number = 4, name = (null)}
//    2021-04-06 09:05:58.011687+0800 GcdNoteTest[31051:4939259] for - currentThread-9:<NSThread: 0x600000330180>{number = 1, name = main}

}

//主队列+同步任务(崩溃)
- (IBAction)click4:(id)sender {
    NSLog(@"click - currentThread-1:%@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_main_queue();
    for(NSInteger i = 0 ; i < 10 ; i++){
        dispatch_sync(queue, ^{
            NSLog(@"b - currentThread-%ld:%@", i,  [NSThread currentThread]);
        });
        NSLog(@"for - currentThread-%ld:%@", i, [NSThread currentThread]);
    }
    
//    2021-03-26 13:45:45.742049+0800 GcdNoteTest[71591:2320516] click - currentThread-1:<NSThread: 0x600002edc800>{number = 1, name = main}
//    (lldb)
    
//  同步执行会等待当前队列中的任务执行完毕，才会接着执行。那么当我们把 任务 1 追加到主队列中，任务 1 就在等待主线程处理完 click4 任务。而click4 任务需要等待任务 1 执行完毕，这样就形成了相互等待的情况，产生了死锁。
}

//主队列+异步任务
- (IBAction)click5:(id)sender {
    NSLog(@"click - currentThread-1:%@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_main_queue();
    for(NSInteger i = 0 ; i < 10 ; i++){
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:self.randomNum];
            NSLog(@"b - currentThread-%ld:%@", i,  [NSThread currentThread]);
        });
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%ld:%@", i, [NSThread currentThread]);
    }
    
//    2021-03-26 13:48:30.659182+0800 GcdNoteTest[71658:2323524] click - currentThread-1:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.659601+0800 GcdNoteTest[71658:2323524] for - currentThread-0:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.659922+0800 GcdNoteTest[71658:2323524] for - currentThread-1:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.660225+0800 GcdNoteTest[71658:2323524] for - currentThread-2:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.660571+0800 GcdNoteTest[71658:2323524] for - currentThread-3:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.660958+0800 GcdNoteTest[71658:2323524] for - currentThread-4:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.661332+0800 GcdNoteTest[71658:2323524] for - currentThread-5:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.661659+0800 GcdNoteTest[71658:2323524] for - currentThread-6:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.661966+0800 GcdNoteTest[71658:2323524] for - currentThread-7:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.662230+0800 GcdNoteTest[71658:2323524] for - currentThread-8:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.662450+0800 GcdNoteTest[71658:2323524] for - currentThread-9:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708077+0800 GcdNoteTest[71658:2323524] b - currentThread-0:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708247+0800 GcdNoteTest[71658:2323524] b - currentThread-1:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708376+0800 GcdNoteTest[71658:2323524] b - currentThread-2:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708513+0800 GcdNoteTest[71658:2323524] b - currentThread-3:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708635+0800 GcdNoteTest[71658:2323524] b - currentThread-4:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708820+0800 GcdNoteTest[71658:2323524] b - currentThread-5:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.708943+0800 GcdNoteTest[71658:2323524] b - currentThread-6:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.709159+0800 GcdNoteTest[71658:2323524] b - currentThread-7:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.709337+0800 GcdNoteTest[71658:2323524] b - currentThread-8:<NSThread: 0x600001c80780>{number = 1, name = main}
//    2021-03-26 13:48:30.709497+0800 GcdNoteTest[71658:2323524] b - currentThread-9:<NSThread: 0x600001c80780>{number = 1, name = main}
    
    ///加延时后
//    2021-04-06 09:07:19.116725+0800 GcdNoteTest[31077:4940646] click - currentThread-1:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:19.518487+0800 GcdNoteTest[31077:4940646] for - currentThread-0:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:20.119664+0800 GcdNoteTest[31077:4940646] for - currentThread-1:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:21.020551+0800 GcdNoteTest[31077:4940646] for - currentThread-2:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:21.722499+0800 GcdNoteTest[31077:4940646] for - currentThread-3:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:21.723215+0800 GcdNoteTest[31077:4940646] for - currentThread-4:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:22.623914+0800 GcdNoteTest[31077:4940646] for - currentThread-5:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:23.125311+0800 GcdNoteTest[31077:4940646] for - currentThread-6:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:23.227140+0800 GcdNoteTest[31077:4940646] for - currentThread-7:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:23.928697+0800 GcdNoteTest[31077:4940646] for - currentThread-8:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:24.030674+0800 GcdNoteTest[31077:4940646] for - currentThread-9:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:24.134874+0800 GcdNoteTest[31077:4940646] b - currentThread-0:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:24.135455+0800 GcdNoteTest[31077:4940646] b - currentThread-1:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:24.336059+0800 GcdNoteTest[31077:4940646] b - currentThread-2:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:24.936734+0800 GcdNoteTest[31077:4940646] b - currentThread-3:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:25.038628+0800 GcdNoteTest[31077:4940646] b - currentThread-4:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:25.940979+0800 GcdNoteTest[31077:4940646] b - currentThread-5:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:26.142882+0800 GcdNoteTest[31077:4940646] b - currentThread-6:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:26.543957+0800 GcdNoteTest[31077:4940646] b - currentThread-7:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:27.345459+0800 GcdNoteTest[31077:4940646] b - currentThread-8:<NSThread: 0x600003180040>{number = 1, name = main}
//    2021-04-06 09:07:27.647069+0800 GcdNoteTest[31077:4940646] b - currentThread-9:<NSThread: 0x600003180040>{number = 1, name = main}

    
//    从上面代码的运行结果可以看出，虽然是异步任务，但是并没有开启新的线程，任然是在主线程中执行，并且任务是顺序执行的。

}

//『异步执行+串行队列』嵌套『同一个串行队列』造成死锁的情况请看如下代码：
- (IBAction)click6:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_SERIAL);
    //异步任务A
    dispatch_async(queue, ^{
        //同步任务B
        dispatch_sync(queue, ^{
            NSLog(@"任务C---%@",[NSThread currentThread]);
        });
    });

//    首先异步任务A进入到队列中，同步任务B对于异步任务A来说是代码执行部分，C对于同步任务B来说是代码执行部分，因为是在串行队列中，任务是串行执行的，根据队列先进先出原则，首先需要把任务A取出执行，即执行B的部分，但是B依赖C的执行，而C等待着B执行完成后执行，这样就形成了一个相互等待，造成死锁卡死。
//    『同步执行+串行队列』嵌套『同一个串行队列』造成死锁的情况同理分析。
}

//GCD线程间的通信
- (IBAction)click7:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1---%@",[NSThread currentThread]);
        // 模拟耗时操作
        sleep(2);
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    
//    2021-03-26 13:56:59.173062+0800 GcdNoteTest[71788:2332395] 1---<NSThread: 0x6000017d9100>{number = 4, name = (null)}
//    2021-03-26 13:57:01.177987+0800 GcdNoteTest[71788:2332215] 2---<NSThread: 0x6000017ec8c0>{number = 1, name = main}

//    从上面代码运行的结果可以看出，1是在子线程中执行的，隔2秒后打印2，2是在主线程中执行的。
}

//栅栏方法dispatch_barrier_async
- (IBAction)click8:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start");
    dispatch_async(queue, ^{
        NSLog(@"currentThread-1:%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"currentThread-2:%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
    });
    NSLog(@"pause");
    dispatch_async(queue, ^{
        NSLog(@"currentThread-3:%@", [NSThread currentThread]);
    });
    NSLog(@"end");

//    2021-03-26 14:05:03.449991+0800 GcdNoteTest[72142:2341604] start
//    2021-03-26 14:05:03.450469+0800 GcdNoteTest[72142:2341604] pause
//    2021-03-26 14:05:03.450598+0800 GcdNoteTest[72142:2341694] currentThread-1:<NSThread: 0x600002f54800>{number = 6, name = (null)}
//    2021-03-26 14:05:03.450772+0800 GcdNoteTest[72142:2341604] end
//    2021-03-26 14:05:03.451044+0800 GcdNoteTest[72142:2341694] currentThread-2:<NSThread: 0x600002f54800>{number = 6, name = (null)}
//    2021-03-26 14:05:05.452244+0800 GcdNoteTest[72142:2341694] currentThread-3:<NSThread: 0x600002f54800>{number = 6, name = (null)}
    
//    从上面的代码运行结果可以看出，start、pause、end都是在2执行答应的，说明dispatch_barrier_async并没有阻塞线程，3是在2打印两秒后打印的。

}

//栅栏方法dispatch_barrier_sync
- (IBAction)click9:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.thread.demo", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start");
    dispatch_async(queue, ^{
        NSLog(@"currentThread-1:%@", [NSThread currentThread]);
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"currentThread-2:%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
    });
    NSLog(@"pause");
    dispatch_async(queue, ^{
        NSLog(@"currentThread-3:%@", [NSThread currentThread]);
    });
    NSLog(@"end");

//    2021-03-26 14:07:48.355920+0800 GcdNoteTest[72508:2345858] start
//    2021-03-26 14:07:48.356472+0800 GcdNoteTest[72508:2345933] currentThread-1:<NSThread: 0x60000239d700>{number = 3, name = (null)}
//    2021-03-26 14:07:48.356808+0800 GcdNoteTest[72508:2345858] currentThread-2:<NSThread: 0x6000023cc1c0>{number = 1, name = main}
//    2021-03-26 14:07:50.357232+0800 GcdNoteTest[72508:2345858] pause
//    2021-03-26 14:07:50.357821+0800 GcdNoteTest[72508:2345858] end
//    2021-03-26 14:07:50.357988+0800 GcdNoteTest[72508:2345933] currentThread-3:<NSThread: 0x60000239d700>{number = 3, name = (null)}

//    从上面代码运行的结果可以看出，pause和end是在2之后打印的，说明dispatch_barrier_sync阻塞了线程，需要等待dispatch_barrier_sync执行完成后才会往后执行。
}

//延时执行方法-dispatch_after
- (IBAction)click10:(id)sender {
    NSLog(@"begin");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after---%@",[NSThread currentThread]);
    });
    
//    2021-03-26 14:10:14.928413+0800 GcdNoteTest[72590:2349214] begin
//    2021-03-26 14:10:17.975399+0800 GcdNoteTest[72590:2349214] after---<NSThread: 0x6000030e4140>{number = 1, name = main}

//    从上面代码的运行结果可以看出afer是在begin打印后3秒才打印的。
    
//    dispatch_after 方法并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after 方法是很有效的。
}

//一次性代码-dispatch_once
- (IBAction)click11:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"%s", __func__);
    });
    
//    static Test *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [Test alloc]init];
//    });
//    return instance;

//    GCD提供了只执行一次的方法dispatch_once，这个方法在我们创建单例的时候回经常用到。dispatch_once方法可以保证一段代码在程序运行过程中只被调用一次，而且在多线程环境下可以保证线程安全。
}


//调度组简单来说就是把异步执行的任务进行分组，等待所有的分组任务都执行完毕后再回到指定的线程执行任务。调用组使用dispatch_group_create来创建一个分组，dispatch_group_async方法先把任务添加到队列中，然后将队列方到调度组中，或者也可以使用dispatch_group_enter和dispatch_group_leave捉对实现将队列添加到调度组。调用dispatch_group_notify方法回到指定线程执行任务，或者调用dispatch_group_wait阻塞当前线程。

//调度组dispatch_group_wait
- (IBAction)click12:(id)sender {
    NSLog(@"current thread:%@", [NSThread currentThread]);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"thread-1:%@", [NSThread currentThread]);
    });

    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"thread-2:%@", [NSThread currentThread]);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{//注意，等上面两个线程过了之后才执行
        [NSThread sleepForTimeInterval:2];
        NSLog(@"thread-3:%@", [NSThread currentThread]);
        NSLog(@"group-end");
    });

    //会阻塞线程，
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_group_wait后继续执行任务");
    
//    2021-03-26 14:16:23.571074+0800 GcdNoteTest[72707:2355003] current thread:<NSThread: 0x600001bc0780>{number = 1, name = main}
//    2021-03-26 14:16:25.576045+0800 GcdNoteTest[72707:2355079] thread-1:<NSThread: 0x600001beb980>{number = 8, name = (null)}
//    2021-03-26 14:16:25.576049+0800 GcdNoteTest[72707:2355685] thread-2:<NSThread: 0x600001bdc240>{number = 9, name = (null)}
//    2021-03-26 14:16:25.576257+0800 GcdNoteTest[72707:2355003] dispatch_group_wait后继续执行任务
//    2021-03-26 14:16:27.577093+0800 GcdNoteTest[72707:2355003] thread-3:<NSThread: 0x600001bc0780>{number = 1, name = main}
//    2021-03-26 14:16:27.577451+0800 GcdNoteTest[72707:2355003] group-end

}

//调度组dispatch_group_notify
- (IBAction)click13:(id)sender {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_enter(group);

    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"thread_1:%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"thread_2:%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"thread_3:%@", [NSThread currentThread]);
        NSLog(@"group_end");
    });
    
//    2021-03-26 14:21:07.784800+0800 GcdNoteTest[72782:2359789] thread_2:<NSThread: 0x6000016c30c0>{number = 5, name = (null)}
//    2021-03-26 14:21:07.784801+0800 GcdNoteTest[72782:2359786] thread_1:<NSThread: 0x6000016d46c0>{number = 6, name = (null)}
//    2021-03-26 14:21:09.786474+0800 GcdNoteTest[72782:2359698] thread_3:<NSThread: 0x600001690700>{number = 1, name = main}
//    2021-03-26 14:21:09.786932+0800 GcdNoteTest[72782:2359698] group_end

//    需要注意的是`dispatch_group_enter `和`dispatch_group_leave `捉对出现的。
}

//GCD中的信号量是指的Dispatch Semaphore，是持有计数的信号。当信号量小于0时就会一直等待即阻塞所在线程，否则就可以正常执行。信号量可以保持线程的同步，将异步执行任务转换成同步任务执行， 同时保持线程的安全。
//Dispatch Semaphore提供了三个方法：
//
//dispatch_semaphore_create：创建一个 Semaphore 并初始化信号的总量
//dispatch_semaphore_signal：发送一个信号，让信号总量加 1
//dispatch_semaphore_wait：可以使总信号量减 1，信号总量小于 0 时就会一直等待（阻塞所在线程），否则就可以正常执行。

//信号量
- (IBAction)click14:(id)sender {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"里面的a的值：%d-----%@", a, [NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
            a++;
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    NSLog(@"外面的a的值：%d", a);
    
//    2021-03-26 14:24:53.691052+0800 GcdNoteTest[72847:2363708] 里面的a的值：0-----<NSThread: 0x6000037cad40>{number = 7, name = (null)}
//    2021-03-26 14:24:53.691261+0800 GcdNoteTest[72847:2363708] 里面的a的值：1-----<NSThread: 0x6000037cad40>{number = 7, name = (null)}
//    2021-03-26 14:24:53.691405+0800 GcdNoteTest[72847:2363708] 里面的a的值：2-----<NSThread: 0x6000037cad40>{number = 7, name = (null)}
//    2021-03-26 14:24:53.691560+0800 GcdNoteTest[72847:2363708] 里面的a的值：3-----<NSThread: 0x6000037cad40>{number = 7, name = (null)}
//    2021-03-26 14:24:53.691715+0800 GcdNoteTest[72847:2363708] 里面的a的值：4-----<NSThread: 0x6000037cad40>{number = 7, name = (null)}
//    2021-03-26 14:24:53.691830+0800 GcdNoteTest[72847:2363634] 外面的a的值：5

}

//定时器Dispatch_source
- (IBAction)click15:(id)sender {
    if (self.timer) {//移除定时器
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }

    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1 * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, start, interval, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            NSLog(@"定时器开启中........");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"主线程事件处理");
            });
        });

        //启动定时器
        dispatch_resume(self.timer);
    }
    
//    然后我总结了下用dispatch_source写定时器的优缺点
//    优点:
//    1、可以暂停，继续。 不用像NSTimer一样需要重新创建。
//    2、性能较好。
//    缺点：
//    1、dispatch_resume dispatch_suspend dispatch_source_cancel需要按状态使用，否则crash
//    共同点：
//    1、如果不手动释放就不会走dealloc。
//    2、不精确
}

@end
