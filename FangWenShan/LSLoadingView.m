//
//  LSLoadingView.m
//  HairCut
//
//  Created by Leis on 15/11/13.
//  Copyright © 2015年 Leis. All rights reserved.
//

#import "LSLoadingView.h"
#import "AFURLSessionManager.h"


#define kHLoading   50
#define kWLoading   50

@interface LSLoadingView ()

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *btnCancel;
@end
@implementation LSLoadingView

- (id) initWithLoadingImgs:(NSArray<UIImage *> *)arrImg {
    if (arrImg.count < 1) {
        NSLog(@"LSLoadingView: No Imgs !");
        return nil;
    }
    if (self = [super init]) {
        self.frame = [[UIApplication sharedApplication] keyWindow].bounds;
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - kWLoading) / 2, (self.frame.size.height - kHLoading) / 2, kWLoading, kHLoading)];
        _imgView.animationDuration = 1.0;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.animationImages = arrImg;
//        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.layer.cornerRadius = 5.0;
        
//        _imgView.animationRepeatCount

        [self addSubview:_imgView];
        
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 80, 30)];
        [_btnCancel setTitle:@"取消加载" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnCancel addTarget:self action:@selector(btnCancelTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCancel];
    }
    return self;
}

- (void) btnCancelTouched {
    [self dismiss];
}

- (void) setLiveCount:(int)liveCount {
    _liveCount = liveCount;
    if (liveCount <= 0) {
        [self dismiss];
    } else {
        [self show];
    }
}

- (void) show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
//    self.backgroundColor = [UIColor whiteColor];
    if (_dimBackGround) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
    [_imgView startAnimating];
}

- (void) dismiss {
    [_imgView stopAnimating];
    [self removeFromSuperview];
    
}
@end

@implementation LSLoadingView (AFNetworking)


+ (LSLoadingView *) sharedLoadingView {
    static LSLoadingView *_loadingView = nil;
    if ( [[UIApplication sharedApplication] keyWindow] == nil ) {
        return nil;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableArray<UIImage *> *imgs = [[NSMutableArray alloc] init];
        
        for (int i = 1; i < 61; i++) {
            NSString *imgName = [NSString stringWithFormat:@"%d", i];
            [imgs addObject:[UIImage imageNamed:imgName]];
        }
        _loadingView = [[LSLoadingView alloc] initWithLoadingImgs:imgs];
        _loadingView.dimBackGround = YES;

    });
    
    return _loadingView;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            if (task.state == NSURLSessionTaskStateRunning) {
                [self startAnimating];
            } else {
                [self stopAnimating];
            }
            
            [notificationCenter addObserver:self selector:@selector(af_startAnimating) name:AFNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidSuspendNotification object:task];
        }
    }
}


#pragma mark -

- (void)af_startAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimating];
    });
}

- (void)af_stopAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopAnimating];
    });
}

#pragma mark -

- (void) startAnimating {
    [self show];
}

- (void) stopAnimating {
    [self dismiss];
}



@end
