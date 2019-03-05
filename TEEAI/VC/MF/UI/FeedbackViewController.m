//
//  FeedbackViewController.m
//  MifiManager
//
//  Created by yanlei jin on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "FeedbackViewController.h"
//#import "FeedbackCollectionViewCell.h"
#import "SettingTableViewCell.h"
@interface FeedbackViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
    // Do any additional setup after loading the view.
    [self loadMainView];
   
    [self loadData];
}
- (void)loadData{
    
    NSArray *sectionOne = @[
                            @"上网问题",
                            @"流量问题",
                            @"电量问题",
                            @"智能管理"
                            ];
    NSArray *sectionTwo = @[
                            @"产品建议",
                            @"其他"
                            ];
    NSArray *sectionImageOne = @[@"feedBackNet",@"feedBackFlow",@"feedBackBattery",@"feedBackManager"];
    NSArray *sectionImageTwo = @[@"feedBackLight",@"feedBackOther"];
    _dataArray = [NSMutableArray arrayWithObjects:sectionOne,sectionTwo, nil];
    _imageArray = @[sectionImageOne,sectionImageTwo];
    [_tableView reloadData];
}

- (void)loadMainView{
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT - HeightNanvi];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:HeightCell *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightLabel*2)];
        UILabel *signal = [[UILabel alloc] initWithFrame:CGRectMake(MarginX, MarginY, SCREEN_WIDTH - 2*MarginX, HeightLabel)];
        signal.text = @"你的反馈，是我们每天进步的动力";
        signal.font = FontRegular;
        signal.textColor = ColorWhite;
        [view addSubview:signal];
        return view;
    }else{
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return HeightLabel*2;
    }else{
         return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HeightCell*Ratio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.labelTitle.text = title;
    NSString *imageStr = [[_imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageIcon.image = [UIImage imageNamed:imageStr];
    [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
    cell.backgroundColor = ColorClear;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count];
}
#pragma mark - 页面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        //        if (tableView == self.tableView) {
        CGFloat cornerRadius = 10.f;
        cell.backgroundColor = ColorClear;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = ColorWhite.CGColor;
        layer.strokeColor = ColorWhite.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (BorderWidth / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+MarginX, bounds.size.height-lineHeight, bounds.size.width-MarginX, lineHeight);
            lineLayer.backgroundColor = NormalGray.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
