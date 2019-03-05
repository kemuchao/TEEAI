//
//  SettingViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

#import "WiFiSettingViewController.h"
#import "MobileNetSettingViewController.h"
#import "ManagerPSWSettingViewController.h"
#import "SmartManagerViewController.h"
#import "USSDViewController.h"
#import "UpdateViewController.h"
#import "RouterManagerViewController.h"

#import "RouterTestViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    // Do any additional setup after loading the view.
    [self loadMainView];
    
    [self loadData];
}

- (void)loadMainView{
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT - HeightNanvi];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:HeightCell *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (void)loadData{
    NSArray *sectionOne = @[
                    @"WiFi设置",
                    @"移动网络设置",
                    @"USSD",
                    @"管理密码设置"];
    NSArray *sectionOneImage = @[@"settingWifi",@"settingMobileNet",@"settingUSSD",@"settingPSW"];
    
    NSArray *sectionTwo = @[@"路由器管理"];
    NSArray *sectionTwoImage = @[@"settingRouter"];
    
    _dataArray = (NSMutableArray *)@[sectionOne,sectionTwo];
    _imageArray = @[sectionOneImage,sectionTwoImage];
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    NSString *title =  _dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WiFiSettingViewController *wifi = [WiFiSettingViewController new];
            wifi.title = title;
            [self.navigationController pushViewController:wifi animated:YES];
        }else if (indexPath.row == 1){
            MobileNetSettingViewController *mobile = [[MobileNetSettingViewController alloc] init];
            mobile.title = title;
            [self.navigationController pushViewController:mobile animated:YES];
        }else if (indexPath.row == 2){
            USSDViewController *ussd = [USSDViewController new];
            ussd.title = title;
            [self.navigationController pushViewController:ussd animated:YES];
        }else{
            ManagerPSWSettingViewController *pswManager = [ManagerPSWSettingViewController new];
            pswManager.title = title;
            [self.navigationController pushViewController:pswManager animated:YES];
        }
    }else if (indexPath.section == 1){
        RouterManagerViewController *router = [[RouterManagerViewController alloc] init];
        router.title = title;
        [self.navigationController pushViewController:router animated:YES];
    }else{
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            FeedbackViewController *feedback = [FeedbackViewController new];
            feedback.title = title;
            [self.navigationController pushViewController:feedback animated:YES];
        }else{
            AboutViewController *about = [AboutViewController new];
            about.title = title;
            [self.navigationController pushViewController:about animated:YES];
        }
    }
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
