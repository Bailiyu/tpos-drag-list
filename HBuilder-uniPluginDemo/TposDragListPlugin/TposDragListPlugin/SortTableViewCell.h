//
//  SortTableViewCell.h
//  TposDragListPlugin
//
//  Created by 礼雨白 on 2024/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * imgV;

@property (nonatomic, strong) UILabel * nameLab;

@property (nonatomic, strong) UILabel * subTitleLab;

@property (nonatomic, strong) UIView * bottomLine;

@property (nonatomic, strong) UIImageView * topImgV;

@property (nonatomic, strong) UIButton * stickTopButton;

@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSString * cellType;


- (void)setupSubviews;

- (void)loadViewWithData:(NSDictionary *)data;

- (void)updateCorner:(NSInteger)type;

+ (CGFloat)cellHightWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END
