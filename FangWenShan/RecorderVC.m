//
//  RecorderVC.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "RecorderVC.h"
#import "FangWenShan-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "JXTProgressLabel.h"
#import "APIClient.h"
#import "LyricLine.h"

@interface RecorderVC ()

@property (strong, nonatomic) S_EffectView *vEffect;

@property (weak, nonatomic) IBOutlet UIView *vProgressLabelContainer;
@property (nonatomic, strong) JXTProgressLabel * progressLabel2;
@property (weak, nonatomic) IBOutlet UIProgressView *vProgress;
@property (weak, nonatomic) IBOutlet UILabel *lTitle;

@property (weak, nonatomic) IBOutlet UITextView *tvLyrics;
@property (strong, nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) NSString *lrcPath;
@property (strong, nonatomic) NSString *mp3Path;
@property (strong, nonatomic) NSString *lrcLocalPath;
@property (strong, nonatomic) NSString *mp3LocalPath;
@property (strong, nonatomic) NSString *lrcFullLocalPath;
@property (strong, nonatomic) NSString *mp3FullLocalPath;

@property (strong, nonatomic) NSURL *songFileURL;

@property (strong, nonatomic) NSArray<LyricLine *> *arrLyric;

@property (assign, nonatomic) BOOL downloadComplete;
@end

@implementation RecorderVC

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
//    }
//    return self;
//}

- (void) initLabels {
    if (_progressLabel2 != nil) {
        return;
    }
    _progressLabel2 = [[JXTProgressLabel alloc] initWithFrame:_vProgressLabelContainer.bounds];
    //    _progressLabel2.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 105 + 64);
    
    _progressLabel2.backgroundColor = [UIColor clearColor];
    _progressLabel2.backgroundTextColor = [UIColor whiteColor];
    _progressLabel2.foregroundTextColor = [UIColor redColor];
    //    _progressLabel2.text = @"显示一句话，看着像歌词";
    _progressLabel2.textAlignment = NSTextAlignmentCenter;
    _progressLabel2.font = [UIFont systemFontOfSize:22];
    _vProgressLabelContainer.clipsToBounds = YES;
    [_vProgressLabelContainer addSubview:_progressLabel2];
    
}

- (void) initAppearance {
    //    [_tvLyrics scrollRangeToVisible:NSMakeRange(0, 5)];
    //    http://blog.csdn.net/colorapp/article/details/44223807
    _tvLyrics.textContainerInset = UIEdgeInsetsZero;
    _tvLyrics.textContainer.lineFragmentPadding = 0;
    _lTitle.text = _song.name;
}

- (void) loadData {
    NSString *urlPath = [ImageServerBaseURLStr stringByAppendingFormat:@"%@/%@_%@/", _song.subCategory, _song.name, _song.author];
    _lrcPath = [urlPath stringByAppendingFormat:@"%@.lrc", _song.idCode];
    _mp3Path = [urlPath stringByAppendingFormat:@"%@.mp3", _song.idCode];
    
    _lrcLocalPath = [NSString stringWithFormat:@"%@_%@_%@_%@.lrc", _song.subCategory, _song.name, _song.author, _song.idCode];
    _mp3LocalPath = [NSString stringWithFormat:@"%@_%@_%@_%@.mp3", _song.subCategory, _song.name, _song.author, _song.idCode];
    
    _lrcFullLocalPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:_lrcLocalPath];
    
    _mp3FullLocalPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:_mp3LocalPath];
    
    _downloadComplete = NO;
    [self downloadLrc];
}

- (void) downloadLrc {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_lrcFullLocalPath]) {
        NSLog(@"lrc本地存在");
        
        NSString *str = [NSString stringWithContentsOfFile:_lrcFullLocalPath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@", str);
        _arrLyric = [LyricLine parseFromString:str];
        LyricLine * line1 = _arrLyric[ 0 ] ;
        NSLog( @"%@", line1.content);
        [self downloadMp3];
        return;
    } else {
        NSLog(@"lrc本地不存在");
    }
    
    NSURL *URL = [NSURL URLWithString:[_lrcPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld / %lld", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"fullPath:%@", _lrcFullLocalPath);
        return [NSURL fileURLWithPath:_lrcFullLocalPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            return;
        }
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSString *str = [NSString stringWithContentsOfFile:imgFilePath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@", str);
        _arrLyric = [LyricLine parseFromString:str];
        [self downloadMp3];
    }];
    [downloadTask resume];
}

- (void) downloadMp3 {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_mp3FullLocalPath]) {
        NSLog(@"mp3本地存在");
        [self loadLyric];
        _downloadComplete = YES;
        return;
    } else {
        NSLog(@"mp3本地不存在");
    }
    
    NSURL *URL = [NSURL URLWithString:[_mp3Path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld / %lld", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"fullPath:%@", _mp3FullLocalPath);
        return [NSURL fileURLWithPath:_mp3FullLocalPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            return ;
        }
        NSLog(@"%@", [filePath path]);
//        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        NSString *str = [NSString stringWithContentsOfFile:imgFilePath encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"%@", str);
//        _arrLyric = [LyricLine parseFromString:str];
//        [self downloadMp3];
        
        [self loadLyric];
        _downloadComplete = YES;
    }];
    [downloadTask resume];
}

- (void) loadLyric {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (LyricLine *line in _arrLyric) {
        [str appendFormat:@"%@\n", line.content];
    }
    [str appendString:@"\n\n\n\n\n\n"];
//    _tvLyrics.text = str;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineHeightMultiple = 20.f;
//    paragraphStyle.maximumLineHeight = 25.f;
//    paragraphStyle.minimumLineHeight = 15.f;
//    paragraphStyle.firstLineHeadIndent = 20.f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]
                                  };
    _tvLyrics.attributedText = [[NSAttributedString alloc]initWithString:str attributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAppearance];
    [self loadData];
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self initLabels];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self initLabels];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)btnGoTouched:(UIButton *)sender {
    if (sender.isSelected == false) {
        if (_vEffect != nil) {
            return;
        }
        if (_downloadComplete == NO) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"下载尚未完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            return;
        }
        
        
        NSError *createError = nil;
//              NSString *songFilePath = [NSBundle.mainBundle pathForResource:@"70后_一起走过的日子_刘德华_7" ofType:@"wav"];
//        NSString *songFilePath = [NSBundle.mainBundle pathForResource:@"viv" ofType:@"wav"];
                self.songFileURL = [[NSURL alloc] initFileURLWithPath:_mp3FullLocalPath];
//        self.songFileURL = [[NSURL alloc] initFileURLWithPath:songFilePath];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.songFileURL error:&createError];
        NSLog( @"%@", createError);
        
        NSError *activationError = nil;
        [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
        NSLog( @"%@", activationError);
        
        [self.player prepareToPlay];
        self.player.volume = 1.0;
        [self.player play];
        
//        self.songProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
//                                                                  target:self
//                                                                selector:@selector(updateSongProgress)
//                                                                userInfo:nil
//                                                                 repeats:YES];
        
        //            timeNum = 0.0
        //            recoderTimeLabel.text = "00:00:00"
        //            Recoder.recoder.startRecoder()
        
//        effect
        _vEffect = [[S_EffectView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 5, [UIScreen mainScreen].bounds.size.height / 3, [UIScreen mainScreen].bounds.size.width / 2, 50.0)];
        [self.view addSubview:_vEffect];
        //            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updataTime), userInfo: nil, repeats: true)
        
        [self startLrcProgress:0];
        
    } else {
        if (_vEffect == nil) {
            return;
        }
        [_vEffect removeFromSuperview];
        _vEffect = nil;
        [_progressLabel2 stopProgress];
        
        [self.player stop];
        self.player = nil;
    }
    sender.selected = !sender.isSelected;
}

- (void) startLrcProgress:(int)number {
    if (number >= _arrLyric.count) {
        return;
    }
    NSTimeInterval duration = 2;
    if (number == _arrLyric.count - 1) {
        ;
    } else {
        duration = _arrLyric[ number + 1 ].time  - _arrLyric[number].time;
    }
    if (_arrLyric[number].content.length < 1) {
        _arrLyric[number].content = @" ";
        [self startLrcProgress:number + 1];
        return;
    }
    if ([_arrLyric[number].content isEqualToString:@"Next Song~"]) {
        [self startLrcProgress:number + 1];
        return;
    }
    if (duration < 0.02) {
        [self startLrcProgress:number + 1];
        return;
    }
    NSLog(@"%@: duration : %f", _arrLyric[number].content, duration);
    
    [_progressLabel2 progressText:_arrLyric[number].content within:duration didFinish:^{
        [self startLrcProgress:number + 1];
    }];
    int iChar = 0;
    if (number+4 < _arrLyric.count) {
        iChar = _arrLyric[number+4].duration + number;
    } else {
        iChar = [_arrLyric lastObject].duration + number - _arrLyric.count + 1 + 4;
    }
    
    _tvLyrics.layoutManager.allowsNonContiguousLayout = NO;
    [_tvLyrics scrollRangeToVisible:NSMakeRange(iChar, 1)];
}

- (IBAction)btnReturnTouched:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
