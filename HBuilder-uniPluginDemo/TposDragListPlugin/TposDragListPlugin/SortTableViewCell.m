//
//  SortTableViewCell.m
//  TposDragListPlugin
//
//  Created by 礼雨白 on 2024/8/23.
//

#import "SortTableViewCell.h"
#import "SDWebImageManager.h"

#define kSortTop @"https://sandbox.tuanmanman.vip/image/sort_top.png"
#define kSortDrag @"https://sandbox.tuanmanman.vip/image/sort_drag.png"
#define kEditIcon @"https://sandbox.tuanmanman.vip/image/edit_icon.png"

@implementation SortTableViewCell
{
    UIView * _cellBgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
//    self.contentView.backgroundColor = [UIColor blueColor];
    
    if (!_cellBgView){
        _cellBgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_cellBgView];
    }
    
    // 图片
    if (!self.imgV){
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgV.backgroundColor = [UIColor colorWithRed:((float) 246/ 255.0f) green:((float) 246 / 255.0f) blue:((float) 246 / 255.0f) alpha:1.0f];
        [_cellBgView addSubview:imgV];
        self.imgV = imgV;
    }
    
  

    // 商品名称
    if (!self.nameLab){
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor colorWithRed:((float) 18/ 255.0f) green:((float) 18 / 255.0f) blue:((float) 18 / 255.0f) alpha:1.0f];
        label.font = [UIFont boldSystemFontOfSize:14];
        [_cellBgView addSubview:label];
        self.nameLab = label;
    }
    
    if (!self.subTitleLab){
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor colorWithRed:((float) 186 / 255.0f) green:((float) 186 / 255.0f) blue:((float) 196 / 255.0f) alpha:1.0f];
        label.font = [UIFont systemFontOfSize:12];
        [_cellBgView addSubview:label];
        self.subTitleLab = label;
    }
    
    // 置顶按钮
    if (!self.topImgV){
        UIImageView * topImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        topImgV.userInteractionEnabled = YES;
        [_cellBgView addSubview:topImgV];
        self.topImgV = topImgV;
    
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:kSortTop] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            topImgV.image = image;
        }];
    }

    if (!self.stickTopButton) {
        UIButton * stickTopButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:stickTopButton];
        self.stickTopButton = stickTopButton;
    }
  
    if (!self.bottomLine){
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        bottomLine.backgroundColor = [UIColor colorWithRed:((float) 224/ 255.0f) green:((float) 224 / 255.0f) blue:((float) 224 / 255.0f) alpha:.5f];
        [_cellBgView addSubview:bottomLine];
        self.bottomLine = bottomLine;
    }
    
    if (self.cellType && [self.cellType isEqualToString:@"gray-bg"]){
        _cellBgView.backgroundColor = [UIColor colorWithRed:((float) 246/ 255.0f) green:((float) 246 / 255.0f) blue:((float) 246 / 255.0f) alpha:1.0f];
        self.imgV.backgroundColor = [UIColor colorWithRed:((float) 224/ 255.0f) green:((float) 224 / 255.0f) blue:((float) 224 / 255.0f) alpha:1.0f];
        [self.bottomLine removeFromSuperview];
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)loadViewWithData:(NSDictionary *)data
{
    [self.nameLab setText:data[@"name_text"]];
    if (data[@"sub_title"]){
        [self.subTitleLab setText:data[@"sub_title"]];
    }
    if (data[@"is_edit"]){
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:kEditIcon] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.topImgV.image = image;
        }];
    }else{
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:kSortTop] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.topImgV.image = image;
        }];
    }
    if (data[@"img_url"]){
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:data[@"img_url"]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.imgV.image = image;
        }];
    }else{
        self.imgV.hidden = YES;
    }
}

- (void)updateCorner:(NSInteger)type
{
    BOOL isPad = CGRectGetWidth(self.frame) > 500;
    if (!isPad){
        return;
    }
    
    if (type == 0){
        // 无圆角
        self.layer.mask = nil;
    }
    
    if (type == 1 || type == 2 || type == 3){
        CGRect rect = self.bounds;
        CGSize radio = CGSizeMake(10, 10);//圆角尺寸
        UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight;//这只圆角位置
        if (type == 1){
            corner = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
        if (type == 2){
            corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
        CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
        masklayer.frame = self.bounds;
        masklayer.path = path.CGPath;//设置路径
        self.layer.mask = masklayer;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _cellBgView.frame = CGRectMake(0, 7, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 14);
    _cellBgView.layer.cornerRadius = 10;
    _cellBgView.clipsToBounds = YES;
    
    if (!self.cellType || ![self.cellType isEqualToString:@"gray-bg"]){
        _cellBgView.frame = self.bounds;

        if (self.indexPath.row == 0){
            [self updateCorner:1];
        }else if (self.indexPath.row == self.totalCount - 1){
            [self updateCorner:2];
        }else if (self.totalCount == 1){
            [self updateCorner:3];
        }else{
            [self updateCorner:0];
        }
    }
    
    self.bottomLine.frame = CGRectMake(17, CGRectGetMaxY(_cellBgView.bounds) - 0.5, CGRectGetWidth(_cellBgView.bounds) - 34, 0.5);
    // 无图
    if (self.imgV.isHidden) {
        self.nameLab.frame = CGRectMake(19, 0, CGRectGetWidth(_cellBgView.frame) - 120, CGRectGetHeight(_cellBgView.frame));
    }else{
        self.imgV.frame = CGRectMake(19, CGRectGetMidY(_cellBgView.bounds) - 40 / 2, 40, 40);
        self.imgV.layer.cornerRadius = 6;
        self.imgV.clipsToBounds = YES;
        self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.imgV.frame) + 10, 0, CGRectGetWidth(_cellBgView.frame) - 120, CGRectGetHeight(_cellBgView.frame));
    }
    
    if (self.subTitleLab && self.subTitleLab.text){
        self.nameLab.frame = CGRectMake(CGRectGetMinX(self.nameLab.frame), 16, CGRectGetWidth(self.nameLab.frame), 22);
        self.subTitleLab.frame = CGRectMake(CGRectGetMinX(self.nameLab.frame), CGRectGetMaxY(self.nameLab.frame), CGRectGetWidth(self.nameLab.frame), 18);
    }
    
    self.topImgV.frame = CGRectMake(CGRectGetMaxX(_cellBgView.bounds) - 86 , CGRectGetMidY(_cellBgView.bounds) - 18/2, 18, 18);
    self.stickTopButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.bounds)-40, 0, 40, CGRectGetHeight(self.contentView.frame));

    NSString * type = @"UITableViewCellReorderControl";
    
    for (UIView * view in self.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:type] || [NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
//            view.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 20);
//            view.backgroundColor = [UIColor redColor];
            // 替换排序按钮
            for (UIView * subview in view.subviews) {
                if ([subview isKindOfClass: [UIImageView class]]) {
                    subview.frame = CGRectMake(CGRectGetMinX(subview.frame), CGRectGetMinY(subview.frame), 18, 18);
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:kSortDrag] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        ((UIImageView *)subview).image = image;
                    }];
                }
            }
        }
    }
}


+ (CGFloat)cellHightWithObject:(id)object
{
    NSDictionary * dict = (NSDictionary *)object;
    return 66;
}
@end
