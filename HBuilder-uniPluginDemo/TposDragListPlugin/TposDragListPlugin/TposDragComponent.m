//
//  TposDragComponent.m
//  TposDragListPlugin
//
//  Created by 礼雨白 on 2024/8/22.
//

#import "TposDragComponent.h"
#import "SortTableViewCell.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#define kContentWidth [UIScreen mainScreen].bounds.size.width * 0.6115
@interface TposDragComponent ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIViewController * myVC;

@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) UITableView * myTableView;

@property (nonatomic, strong) NSMutableArray * dataList;

@property (nonatomic, strong) NSArray * tipsList;

@property (nonatomic, strong) NSString * confirmTitle;

@property (nonatomic, assign) BOOL isPad;

@property (nonatomic, assign) BOOL hideButton;

@property (nonatomic, strong) NSString * cellType;

@end

@implementation TposDragComponent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@" ****** viewDidLoad *****");
    [self setSubViews];
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"测试" message:@"加载出原生组件了"
    //                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//        controller.mediaTypes = mediaTypes;
//        controller.allowsEditing = YES;
//        controller.delegate = self;
//        
//        UIViewController * currentVC = [[self class] dc_findCurrentShowingViewController];
//        [currentVC presentViewController:controller
//                           animated:YES
//                         completion:^(void){
//            NSLog(@"Picker View Controller is presented");
//        }];
//    });
}

- (void)setSubViews{
    UIView * _bgView = (UIView *)self.view;
    if (self.hideButton){
        _bgView.backgroundColor = [UIColor whiteColor];
    }else{
        _bgView.backgroundColor = [UIColor colorWithRed:((float) 246/ 255.0f) green:((float) 246 / 255.0f) blue:((float) 246/ 255.0f) alpha:1.0f];
    }
    self.bgView = _bgView;
    
    self.isPad = CGRectGetWidth(self.bgView.frame) > 500;
    [self createTableView];
    
    
}

- (void)initData
{
    NSMutableArray * dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i++) {
        [dataList addObject:@{@"name_text":[NSString stringWithFormat:@"牛肉面第 %ld 碗", i], @"img_url": @"https://sandbox.tuanmanman.vip/storage/20240814/sellers/store/2024081422532866bcc4e8adcd4.png"}];
    }
    self.dataList = dataList;
    
 
    
}

#pragma mark -
#pragma mark create tableView
- (void)createTableView
{
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), 26)];
    
    if (self.isPad){
        if (self.hideButton) {
            topView.frame = CGRectMake(14, 0, CGRectGetWidth(self.bgView.frame) - 32, 40);
        }else{
            topView.backgroundColor = [UIColor colorWithRed:((float) 246/ 255.0f) green:((float) 246 / 255.0f) blue:((float) 246/ 255.0f) alpha:1.0f];
            topView.frame = CGRectMake((CGRectGetWidth(self.bgView.frame) - kContentWidth) / 2, 0, kContentWidth, 40);
        }
        
    }else{
        topView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.bgView addSubview:topView];
    
    // 商品名称
    UILabel * product_name = [[UILabel alloc] initWithFrame:CGRectMake(19, 0, 100, CGRectGetHeight(topView.frame))];
    if (self.tipsList && self.tipsList.count > 0){
        product_name.text = self.tipsList[0];
    }
    product_name.textColor = [UIColor colorWithRed:((float) 138/ 255.0f) green:((float) 138 / 255.0f) blue:((float) 142/ 255.0f) alpha:1.0f];
    product_name.font = [UIFont systemFontOfSize:12];
    [topView addSubview:product_name];
    
    // 拖动/编辑
    UILabel * drag_name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topView.bounds) - 43, 0, 43, CGRectGetHeight(topView.frame))];
    if (self.tipsList && self.tipsList.count > 2){
        drag_name.text = self.tipsList[2];
    }
    drag_name.textColor = [UIColor colorWithRed:((float) 138/ 255.0f) green:((float) 138 / 255.0f) blue:((float) 142/ 255.0f) alpha:1.0f];
    drag_name.font = [UIFont systemFontOfSize:12];
    [topView addSubview:drag_name];
    
    // 置顶
    UILabel * top_name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(drag_name.frame) - 46, 0, 40, CGRectGetHeight(topView.frame))];
    if (self.tipsList && self.tipsList.count > 1){
        top_name.text = self.tipsList[1];
    }
    top_name.textColor = [UIColor colorWithRed:((float) 138/ 255.0f) green:((float) 138 / 255.0f) blue:((float) 142/ 255.0f) alpha:1.0f];
    top_name.font = [UIFont systemFontOfSize:12];
    [topView addSubview:top_name];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bgView.bounds)-89, CGRectGetWidth(self.bgView.frame), 89)];
    bottomView.backgroundColor = [UIColor whiteColor];
    if (!self.hideButton){
        [self.bgView addSubview:bottomView];
    }else{
        bottomView.frame = CGRectZero;
    }
    
    UIButton * confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(28, 7, CGRectGetWidth(self.bgView.frame) - 56, 52)];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    confirmButton.backgroundColor = [UIColor colorWithRed:((float) 0/ 255.0f) green:((float) 109 / 255.0f) blue:((float) 226/ 255.0f) alpha:1.0f];
    confirmButton.layer.cornerRadius = self.isPad ? 52 / 2 : 9;
    if (self.confirmTitle){
        [confirmButton setTitle:self.confirmTitle forState:(UIControlStateNormal)];
    }else{
        [confirmButton setTitle:@"保存" forState:(UIControlStateNormal)];
    }
    [confirmButton addTarget:self action:@selector(confirmUpdate) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:confirmButton];
    
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - CGRectGetHeight(topView.frame) - CGRectGetHeight(bottomView.frame)) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.cellType && [self.cellType isEqualToString:@"gray-bg"] ? [UIColor whiteColor] : [UIColor clearColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.editing = YES;
    //    tableView.clipsToBounds = NO;
    //    tableView.dragDelegate = self;
    [self.bgView addSubview:tableView];
    self.myTableView = tableView;
    
    if (self.isPad){
        //        tableView.layer.borderColor = [UIColor colorWithRed:((float) 224/ 255.0f) green:((float) 224 / 255.0f) blue:((float) 234/ 255.0f) alpha:.5f].CGColor;
        //        tableView.layer.borderWidth = 0.5;
        //        tableView.layer.cornerRadius = 6;
        //        tableView.clipsToBounds = YES;
        
        if (self.hideButton){
            tableView.frame = CGRectMake(16, CGRectGetMaxY(topView.frame), CGRectGetWidth(self.bgView.frame) - 36, CGRectGetHeight(self.bgView.frame) - CGRectGetHeight(topView.frame));
        }else{
            tableView.frame = CGRectMake((CGRectGetWidth(self.bgView.frame) - kContentWidth) / 2, CGRectGetMinY(tableView.frame), kContentWidth, CGRectGetHeight(tableView.frame));
            confirmButton.frame = CGRectMake(CGRectGetMinX(tableView.frame), 7, kContentWidth, 52);
        }
        
    }
}

#pragma mark tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hideButton){
        return 84;
    }else{
        return 66;
    }
    //    NSDictionary * dict = self.dataList[indexPath.row];
    //    return [SortTableViewCell cellHightWithObject:dict];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SortTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SortTableViewCell"];
    if (!cell){
        cell = [[SortTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SortTableViewCell"];
    }
    cell.cellType = self.cellType;
    cell.indexPath = indexPath;
    cell.totalCount = self.dataList.count;
    [cell setupSubviews];
    NSDictionary * dict = self.dataList[indexPath.row];
    [cell loadViewWithData:dict];
    cell.stickTopButton.tag = indexPath.row + 100;
    [cell.stickTopButton addTarget:self action:@selector(topAction:) forControlEvents:(UIControlEventTouchUpInside)];
    if (indexPath.row >= self.dataList.count - 1){
        cell.bottomLine.hidden = YES;
    }
    cell.clipsToBounds = NO;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
    //    return UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView dragSessionWillBegin:(id<UIDragSession>)session
{
    NSLog(@"dragSessionWillBegin => %@", session);
    
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"shouldIndentWhileEditingRowAtIndexPath => %ld", indexPath.row);
//
//    return NO;
//}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 互换 sort
    NSDictionary * sourceDict = self.dataList[sourceIndexPath.row];
    [self.dataList removeObjectAtIndex:sourceIndexPath.row];
    [self.dataList insertObject:sourceDict atIndex:destinationIndexPath.row];
    [self didChangeMoveCell];
    [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self batchRefreshCellButtonTag];
    }];
    
    
    //    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    //    BlyShopInfoModel * destinationModel = self.dataArray[destinationIndexPath.row];
    //    NSString * sort = destinationModel.sort;
    //    destinationModel.sort = sourceModel.sort;
    //    sourceModel.sort = sort;
}

// 批量刷新按钮tag
- (void)batchRefreshCellButtonTag
{
    for (NSInteger i = 0; i < self.dataList.count; i++) {
        SortTableViewCell * cell = (SortTableViewCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell){
            cell.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell.stickTopButton.tag = i + 100;
            cell.bottomLine.hidden = i >= self.dataList.count - 1;
            
            if (i == 0){
                [cell updateCorner:1];
            }else if (i == self.dataList.count - 1){
                [cell updateCorner:2];
            }else if (self.dataList.count == 1){
                [cell updateCorner:3];
            }else{
                [cell updateCorner:0];
            }
        }
    }
}

// 置顶操作
- (void)topAction:(UIButton *)sender
{
    NSInteger row = sender.tag - 100;
    NSDictionary * currentDict = self.dataList[row];
    if (currentDict[@"is_edit"]){
        [self fireEvent:@"tool_action" params:@{@"detail":@{@"item": currentDict}} domChanges:nil];
        return;
    }
    
    
    [self.myTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // 取出当前数据
    [self.dataList removeObjectAtIndex:row];
    
    // 添加到第一个位置
    [self.dataList insertObject:currentDict atIndex:0];
    [NSTimer scheduledTimerWithTimeInterval:.3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self batchRefreshCellButtonTag];
    }];
    [self didChangeMoveCell];
}


// TODO: - vue页面传值
- (void)onCreateComponentWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events uniInstance:(DCUniSDKInstance *)uniInstance
{
    NSLog(@"******* 创建原生组件 - 传值 ****** %@", attributes);
    if (attributes[@"dataList"]){
        self.dataList = [attributes[@"dataList"] mutableCopy];
    }
    if (attributes[@"tips"]){
        self.tipsList = attributes[@"tips"];
    }
    if (attributes[@"confirmTitle"]){
        self.confirmTitle = attributes[@"confirmTitle"];
    }
    if (attributes[@"hideButton"]){
        self.hideButton = attributes[@"hideButton"];
    }
    if (attributes[@"cellType"]){
        self.cellType = attributes[@"cellType"];
    }
    
}

// TODO: - 向vue传值
- (void)confirmUpdate
{
    [self fireEvent:@"confirm_update" params:@{@"detail":@{@"dataList": self.dataList}} domChanges:nil];
}


- (void)didChangeMoveCell
{
    [self fireEvent:@"did_changed" params:@{@"detail":@{@"dataList": self.dataList}} domChanges:nil];
}


UNI_EXPORT_METHOD(@selector(reloadData:))
- (void)reloadData:(NSArray *)dataList
{
    NSLog(@"即将刷新 => %@", dataList);
    self.dataList = dataList;
    [self.myTableView reloadData];
}



#pragma mark -- 类方法
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
