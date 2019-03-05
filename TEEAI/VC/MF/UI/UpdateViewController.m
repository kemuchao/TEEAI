//
//  UpdateViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UpdateViewController.h"
#import "ContentDetailImageTableViewCell.h"
#import "MainTypeOneTableViewCell.h"
#import "APPIconView.h"
#define HeightHeadView SCREEN_HEIGHT*0.4

#import "UpdateCustomerViewController.h"
#import "UpdateDeviceViewController.h"
@interface UpdateViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorWhite;
   
    [self loadMainView];
//    [self loadSelfNavi];
    [self loadData];
}

- (void)loadMainView{
    
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT-HeightNanvi];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:HeightCell *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"MainTypeOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)loadData{
    _dataArray = @[@{@"title":@"手机客户端",
                     @"value":@"1.2.65",
                     @"image":@"settingPhone"
                     },
                   @{@"title":@"路由器固件",
                     @"value":@"1.5.64",
                     @"image":@"settingRouter"
                     }];
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    MainTypeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.imageIcon.image = IMAGE(dict[@"image"]);
    cell.labelTitle.text = [dict objectForKey:@"title"];
    cell.labelTitle.textColor = [UIColor colorWithHexString:ColorBlueNormal];
    cell.labelTitle.font = FontRegular;
    
    cell.labelDetail.text = [dict objectForKey:@"value"];
    cell.labelDetail.textColor = [UIColor colorWithHexString:ColorBlueLight];
    cell.labelDetail.font = FontNormal;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightHeadView*Ratio)];
    CGFloat iconWidth = 90*Ratio;
    CGFloat iconY = (HeightHeadView*Ratio - iconWidth)/2;
    CGFloat iconX = (SCREEN_WIDTH - iconWidth)/2;
    APPIconView *icon = [[APPIconView alloc] initWithFrame:[self dealGetFrameWithX:iconX Y:iconY Width:iconWidth Height:iconWidth]];
    [header addSubview:icon];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HeightCell*Ratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeightHeadView*Ratio;
}
#pragma mark - 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UpdateCustomerViewController *customer = [UpdateCustomerViewController new];
        customer.title = @"客户端软件升级";
        [self.navigationController pushViewController:customer animated:YES];
    } else {
        UpdateDeviceViewController *customer = [UpdateDeviceViewController new];
        customer.title = @"路由器软件升级";
        [self.navigationController pushViewController:customer animated:YES];    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
