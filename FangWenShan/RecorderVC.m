//
//  RecorderVC.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "RecorderVC.h"
#import "FangWenShan-Swift.h"
#import "Song.h"
#import "JXTProgressLabel.h"

@interface RecorderVC ()

@property (strong, nonatomic) S_EffectView *vEffect;

@property (weak, nonatomic) IBOutlet UIView *vProgressLabelContainer;
@property (nonatomic, strong) JXTProgressLabel * progressLabel2;
@property (weak, nonatomic) IBOutlet UITextView *tvLyrics;

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

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_tvLyrics scrollRangeToVisible:NSMakeRange(0, 5)];
//    http://blog.csdn.net/colorapp/article/details/44223807
    _tvLyrics.textContainerInset = UIEdgeInsetsZero;
    _tvLyrics.textContainer.lineFragmentPadding = 0;
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
        //            timeNum = 0.0
        //            recoderTimeLabel.text = "00:00:00"
        //            Recoder.recoder.startRecoder()
        _vEffect = [[S_EffectView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 5, [UIScreen mainScreen].bounds.size.height / 3, [UIScreen mainScreen].bounds.size.width / 2, 50.0)];
        [self.view addSubview:_vEffect];
        //            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updataTime), userInfo: nil, repeats: true)
        [_progressLabel2 progressText:@"今天很开心" within:2 didFinish:^{
            ;
        }];
        
        _tvLyrics.layoutManager.allowsNonContiguousLayout = NO;// .layoutManager.allowsNonContiguousLayout = false
        [_tvLyrics scrollRangeToVisible:NSMakeRange(14, 2)];
    } else {
        if (_vEffect == nil) {
            return;
        }
        [_vEffect removeFromSuperview];
        _vEffect = nil;
        [_progressLabel2 stopProgress];
    }
    sender.selected = !sender.isSelected;
}

- (IBAction)btnReturnTouched:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
