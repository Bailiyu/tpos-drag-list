//
//  TestVCViewController.m
//  DCTestUniPlugin
//
//  Created by 礼雨白 on 2024/4/18.
//  Copyright © 2024 DCloud. All rights reserved.
//

#import "TestVCViewController.h"
#import "ICGVideoTrimmerView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface TestVCViewController ()<UIVideoEditorControllerDelegate, UIImagePickerControllerDelegate, ICGVideoTrimmerDelegate>

//@property (nonatomic, assign) BOOL haveComplete;
//@property (nonatomic, strong) WKWebView * webView;
//@property (nonatomic, strong) NSString * webUrl;

@property (nonatomic, strong) UIViewController * myVC;
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

@implementation TestVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@" ****** viewDidLoad *****");
    
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];

    [self setSubViews];
//    UIImagePickerController * imgPicker = [[UIImagePickerController alloc] init];
//    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imgPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
//    imgPicker.editing = NO;
//    imgPicker.delegate = self;
//    [self.myVC  presentViewController:imgPicker animated:YES completion:^{
//        NSLog(@"图片选择打开");
//    }];
}

- (void)setSubViews{
    UIView * _bgView =(UIView *)self.view;
    _bgView.backgroundColor = [UIColor blackColor];
    
//    UIButton * tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [tempBtn setTitle:@"选择视频" forState:(UIControlStateNormal)];
//    tempBtn.backgroundColor = [UIColor blueColor];
//    [tempBtn addTarget:self action:@selector(sendEventToUni:) forControlEvents:(UIControlEventTouchUpInside)];
//    [_bgView addSubview:tempBtn];
    
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
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
    [videoBg addGestureRecognizer:tap];
    self.tap = tap;
    
    ICGVideoTrimmerView * trimmerView = [[ICGVideoTrimmerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.bounds) - 60, CGRectGetWidth(videoBg.frame) , 60) asset:self.asset];
    [trimmerView setAsset:self.asset];
    [trimmerView setShowsRulerView:NO];
//    [trimmerView setRulerLabelInterval:10];
    [trimmerView setTrackerColor:[UIColor whiteColor]];
    [trimmerView setDelegate:self];
    
    [_bgView addSubview:trimmerView];
    self.trimmerView = trimmerView;
    [trimmerView resetSubviews];
    
    self.videoPlaybackPosition = 0;
    [self tapOnVideoLayer:tap];
}

- (void)sendEventToUni:(UIButton *)sender
{
    self.myVC = [TestVCViewController dc_findCurrentShowingViewController];
    NSLog(@"uniInstance viewController => %@", self.myVC.navigationController);
}

- (void)addEvent:(NSString *)eventName
{
    NSLog(@"事件名称 => %@", eventName);
    if ([eventName isEqualToString:@"test_event"]){
//        _haveComplete = YES;
    }
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


//
//#pragma mark - WKWebDelegate
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    NSLog(@"**** WKWeb加载完成 *****");
//    [self fireEvent:@"test_event" params:@{@"detail":@{@"wkWeb":@"网页加载完成"}} domChanges:nil];
//}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        /*
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:@"public.movie"]) {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            UIVideoEditorController *editVC; // 检查这个视频资源能不能被修改
            if ([UIVideoEditorController canEditVideoAtPath:videoURL.path]) {
                editVC = [[UIVideoEditorController alloc] init];
                editVC.videoPath = videoURL.path;
                editVC.delegate = self;
            }
            editVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            editVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.myVC presentViewController:editVC animated:YES completion:nil];
        }
         */
    }];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];

//    self.tempVideoPath = url;
//    [self setSubViews];

    /*
    
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"选中视频url => %@", url);
    
    AVPlayer * player = [AVPlayer playerWithURL:url];
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.videoBg.bounds;
    [self.videoBg.layer addSublayer:playerLayer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [player play];
    });
    */
    
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
//        [self stopPlaybackTimeChecker];
        
//        self.videoPlaybackPosition = 0;
//        [self seekVideoToPos: self.startTime];
//
//        _restartOnPlay = YES;
//        [self tapOnVideoLayer:self.tap];
        
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
        [self stopPlaybackTimeChecker];
    }else {
        if (_restartOnPlay){
            [self seekVideoToPos: self.startTime];
            [self.trimmerView seekToTime:self.startTime];
            _restartOnPlay = NO;
        }
        [self.player play];
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
//                        self.tempVideoPath = [NSString stringWithFormat:@"file://%@",11,self.tempVideoPath];
                        /*
                        NSURL *movieUrl = [NSURL fileURLWithPath:self.tempVideoPath];
                        
                        AVAsset * asset = [AVAsset assetWithURL:movieUrl];
                        
                        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
                        AVPlayer * player = [AVPlayer playerWithPlayerItem:item];
                        
                        AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
                    
                        playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
                        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                        playerLayer.backgroundColor = [[UIColor redColor] CGColor];
                        playerLayer.frame = CGRectMake(100, 100, 100, 200);
                        [self.videoBg.layer addSublayer:playerLayer];
                        [player play];
                        */
                        [self fireEvent:@"complete" params:@{@"detail":@{@"filePath":self.tempVideoPath}} domChanges:nil];
//                        UISaveVideoAtPathToSavedPhotosAlbum([movieUrl relativePath], self,@selector(video:didFinishSavingWithError:contextInfo:), nil);
                    });
                    
                    break;
            }
        }];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self fireEvent:@"complete" params:@{@"detail":@{@"filePath":weakSelf.tempVideoPath}} domChanges:nil];
//    });
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
