//
//  TmmVideoEditorComponent.m
//  TmmVideoEditor
//
//  Created by 礼雨白 on 2024/4/22.
//

#import "TmmVideoEditorComponent.h"
#import "ICGVideoTrimmerView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SDWebImageManager.h"

#define kPlayIcon @"https://sandbox.tuanmanman.vip/image/playFill.png"
#define kPauseIcon @"https://sandbox.tuanmanman.vip/image/pauseFill.png"
@interface TmmVideoEditorComponent ()<UIVideoEditorControllerDelegate, ICGVideoTrimmerDelegate>

@property (nonatomic, strong) UIViewController * myVC;

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * videoBg;

#pragma mark - ICG codes
@property (nonatomic, assign) BOOL isPlaying;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (assign, nonatomic) CGFloat videoPlaybackPosition;

@property (nonatomic, strong) ICGVideoTrimmerView * trimmerView;
@property (strong, nonatomic) NSString * tempVideoPath;
@property (nonatomic, strong) NSString * showVideoPath;

@property (strong, nonatomic) AVAssetExportSession * exportSession;
@property (strong, nonatomic) AVAsset * asset;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;
@property (assign, nonatomic) BOOL restartOnPlay;
@property (nonatomic, strong) UITapGestureRecognizer *tap;


@end
@implementation TmmVideoEditorComponent
{
    UIView * _bottomToolBg;
    UIButton * _playButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@" ****** viewDidLoad *****");
    
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];
    [self setSubViews];

}

- (void)setSubViews{
    UIView * _bgView =(UIView *)self.view;
    _bgView.backgroundColor = [UIColor blackColor];
    self.bgView = _bgView;
    
    UIView * videoBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.bounds) - 80)];
    videoBg.backgroundColor = [UIColor blackColor];
    [_bgView addSubview:videoBg];
    self.videoBg = videoBg;
    
    NSLog(@"**** tempVideoPath => %@ **** ", self.tempVideoPath);
    //    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.tempVideoPath]];
    AVAsset * asset = [AVAsset assetWithURL:[NSURL URLWithString:self.showVideoPath]];
    self.asset = asset;
    
    AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer * player = [AVPlayer playerWithPlayerItem:item];
    self.player = player;
    
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playerLayer = playerLayer;
        
    playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    //    playerLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    playerLayer.frame = self.videoBg.bounds;
    [videoBg.layer addSublayer:playerLayer];
        
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
//    [videoBg addGestureRecognizer:tap];
//    self.tap = tap;

    [self setupBottomTools];

    // 自动从第一帧开始播放
    self.videoPlaybackPosition = 0;
//    [self tapOnVideoLayer:tap];
}

#pragma mark - 布局底部操作界面
- (void)setupBottomTools
{
    _bottomToolBg = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bgView.bounds) - 60, CGRectGetWidth(self.bgView.bounds) - 20, 50)];
    _bottomToolBg.backgroundColor = [UIColor colorWithRed:56.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1];
    _bottomToolBg.layer.cornerRadius = 8.f;
    _bottomToolBg.clipsToBounds = YES;
    _bottomToolBg.layer.masksToBounds = YES;
    [self.bgView addSubview:_bottomToolBg];
    
    // 播放/暂停按钮
    UIButton * playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    playButton.backgroundColor = [UIColor redColor];
    [playButton addTarget:self action:@selector(tapPlayButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    playButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [playButton setTitle:@"" forState:(UIControlStateNormal)];
    _playButton = playButton;
    [_bottomToolBg addSubview:playButton];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:kPlayIcon] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [playButton setImage:image forState:(UIControlStateNormal)];
    }];

    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:kPauseIcon] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [playButton setImage:image forState:(UIControlStateSelected)];
    }];
    
    // 中间黑线
    UIView * centerLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playButton.frame), 0, 2, CGRectGetHeight(_bottomToolBg.bounds))];
    centerLine.backgroundColor = [UIColor blackColor];
    [_bottomToolBg addSubview:centerLine];
    
    // 控制进度条
    ICGVideoTrimmerView * trimmerView = [[ICGVideoTrimmerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(centerLine.frame), 0, CGRectGetWidth(_bottomToolBg.frame) - CGRectGetWidth(centerLine.frame) - CGRectGetWidth(playButton.frame), CGRectGetHeight(_bottomToolBg.frame)) asset:self.asset];
    [trimmerView setAsset:self.asset];
    [trimmerView setShowsRulerView:NO];
//    [trimmerView setRulerLabelInterval:10];
    [trimmerView setTrackerColor:[UIColor whiteColor]];
    [trimmerView setDelegate:self];
    [_bottomToolBg addSubview:trimmerView];
    self.trimmerView = trimmerView;
    [trimmerView resetSubviews];
}


- (void)sendEventToUni:(UIButton *)sender
{
    self.myVC = [TmmVideoEditorComponent dc_findCurrentShowingViewController];
    NSLog(@"uniInstance viewController => %@", self.myVC.navigationController);
}

- (void)addEvent:(NSString *)eventName
{
    NSLog(@"事件名称 => %@", eventName);
    if ([eventName isEqualToString:@"test_event"]){
//        _haveComplete = YES;
    }
}

- (void)tapPlayButtonAction:(UIButton *)sender
{
//    sender.selected = !sender.isSelected;
    NSLog(@"触发点击事件 => %@", sender);
    if (self.isPlaying) {
        [self.player pause];
        _playButton.selected = NO;

        [self stopPlaybackTimeChecker];
    }else {
        if (_restartOnPlay){
            [self seekVideoToPos: self.startTime];
            [self.trimmerView seekToTime:self.startTime];
            _restartOnPlay = NO;
        }
        [self.player play];
        _playButton.selected = YES;

        if (self.trimmerView.delegate){
            [self startPlaybackTimeChecker];
        }
    }
    self.isPlaying = !self.isPlaying;
    [self.trimmerView hideTracker:!self.isPlaying];
}


- (void)removeEvent:(NSString *)eventName
{
    NSLog(@"移除事件 =>%@", eventName);
    if ([eventName isEqualToString:@"test_event"]){
//        _haveComplete = NO;
    }
}

- (void)onCreateComponentWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events uniInstance:(DCUniSDKInstance *)uniInstance
{
    NSLog(@"******* 创建原生组件 - 传值 ******");
    NSLog(@"ref => %@, type => %@, styles => %@ , attr => %@, events => %@", ref, type, styles, attributes, events);
    if (attributes[@"videoUrl"]){
        NSString * videoUrl = attributes[@"videoUrl"];
//        self.webUrl = videoUrl;
        self.showVideoPath = videoUrl;
        NSLog(@"******* 正在加载 videoUrl ****** %@", videoUrl);
    }
}

- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
       NSLog(@"编辑成功后的Video被保存在沙盒的临时目录中 =>%@",editedVideoPath);
}

// 编辑失败后调用的方法
- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
       NSLog(@"编辑失败后调用的方法 => %@",error.description);
}


#pragma mark - ICGVideoTrimmerDelegate

// 改变控制条的左右位置
- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime
{
    _restartOnPlay = YES;
    [self.player pause];
    _playButton.selected = NO;
    
    self.isPlaying = NO;
    [self stopPlaybackTimeChecker];
    
    [self.trimmerView hideTracker:YES];
    
    if (startTime != self.startTime){
        [self seekVideoToPos:startTime];
    }else{
        [self seekVideoToPos:endTime];
    }
    self.startTime = startTime;
    self.stopTime = endTime;
}

- (void)startPlaybackTimeChecker
{
    [self stopPlaybackTimeChecker];
    
    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}

- (void)stopPlaybackTimeChecker
{
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}

- (void)onPlaybackTimeCheckerTimer
{
    CMTime curTime = [self.player currentTime];
    Float64 seconds = CMTimeGetSeconds(curTime);
//    NSLog(@"seconds => %f", seconds);
    
    if (seconds < 0){
        seconds = 0; // this happens! dont know why.
    }
    self.videoPlaybackPosition = seconds;

    [self.trimmerView seekToTime:seconds];
    
//    NSLog(@"stopTime => %f", self.stopTime);

    if (self.videoPlaybackPosition >= self.stopTime) {
        
        self.videoPlaybackPosition = self.startTime;
        [self seekVideoToPos: self.startTime];
        [self.trimmerView seekToTime:self.startTime];
        [self stopPlaybackTimeChecker];
        [self tapOnVideoLayer:self.tap];
    }

}


- (void)seekVideoToPos:(CGFloat)pos
{
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
    //NSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - actions
- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap
{
    NSLog(@"触发点击事件 => %@", tap);
    if (self.isPlaying) {
        [self.player pause];
        _playButton.selected = NO;
        
        [self stopPlaybackTimeChecker];
    }else {
        if (_restartOnPlay){
            [self seekVideoToPos: self.startTime];
            [self.trimmerView seekToTime:self.startTime];
            _restartOnPlay = NO;
        }
        [self.player play];
        _playButton.selected = YES;
        
        if (self.trimmerView.delegate){
            [self startPlaybackTimeChecker];
        }
    }
    self.isPlaying = !self.isPlaying;
    [self.trimmerView hideTracker:!self.isPlaying];
}


// 开始保存视频
- (void)saveVideoAction
{
    
}

// !!!: - 保存视频前先删除
- (void)deleteTempFile
{
    NSURL *url = [NSURL fileURLWithPath:self.tempVideoPath];
//    NSURL * url = [NSURL fileURLWithPath:self.tempVideoPath isDirectory:YES];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}


// !!!: - 开始导出视频
- (void)startExportVideo{
    [self deleteTempFile];
    [self.player pause];
    _playButton.selected = NO;

    [self stopPlaybackTimeChecker];
}


UNI_EXPORT_METHOD(@selector(exportVideo:))

- (void)exportVideo:(NSDictionary *)options {
    NSLog(@"开始导出视频 %@", options);
//    __block typeof(self) weakSelf = self
    
    [self startExportVideo];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:self.asset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.
        
        NSURL *furl = [NSURL fileURLWithPath:self.tempVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime - self.startTime, self.asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self fireEvent:@"complete" params:@{@"detail":@{@"filePath":self.tempVideoPath}} domChanges:nil];
                    });
                    
                    break;
            }
        }];
    }
    
}

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    NSLog(@"videoPath ===> %@", videoPath);

    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
}


// 获取当前显示的 UIViewController
+ (UIViewController *)dc_findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    // 递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) {
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }

    return currentShowingVC;
}


@end
