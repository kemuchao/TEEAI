//
//  RouterManagerViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "RouterManagerViewController.h"
#import "ContentTableViewCell.h"
#import "ContentDetailTableViewCell.h"

#import "ResetRouterViewController.h"
#import "CloseRouterViewController.h"
#import "RestoreFactoryViewController.h"
@interface RouterManagerViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RouterManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadMainView];
    
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)loadMainView{
    
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT - HeightNanvi];
    UITableView *tableView =  [self dealSetTableViewWithCellHeight:HeightCell *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    [tableView registerNib:[UINib nibWithNibName:@"ContentDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
    
    _tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (void)loadData{
    NSArray *sectionOne = @[@"重启路由器",@"关闭路由器",@"恢复出厂设置"];

    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        _dataArray = (NSMutableArray *)@[@[@"重启路由器",@"恢复出厂设置"]];
    }else{
        _dataArray = (NSMutableArray *)@[sectionOne];
    }
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MarginY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return MarginY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        NSString *title = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.labelTitle.text = title;
        [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
        return cell;
    } else {
        ContentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        NSString *title = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.labelTitle.text = title;
        [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
        cell.labelDetail.text = Localized(@"undefined");
        [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontDetail];
        return cell;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {

            [self performSegueWithIdentifier:@"toResetRouterViewController" sender:self];
        } else if(indexPath.row == 1){
            if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {

                [self performSegueWithIdentifier:@"toRestoreFactoryViewController" sender:self];
                
            }else{

                 [self performSegueWithIdentifier:@"toCloseRouterViewController" sender:self];
            }
            
        }else{

            [self performSegueWithIdentifier:@"toRestoreFactoryViewController" sender:self];
        }
    } else {
        if (indexPath.row == 0) {
            
        } else if(indexPath.row == 1){
            
        }else{
            
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        //        if (tableView == self.tableView) {
//        CGFloat cornerRadius = 10.f;
//        cell.backgroundColor = ColorClear;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
//        BOOL addLine = NO;
//        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//        } else if (indexPath.row == 0) {
//            
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//            addLine = YES;
//            
//        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//        } else {
//            CGPathAddRect(pathRef, nil, bounds);
//            addLine = YES;
//        }
//        layer.path = pathRef;
//        CFRelease(pathRef);
//        //颜色修改
//        layer.fillColor = ColorWhite.CGColor;
//        layer.strokeColor = ColorWhite.CGColor;
//        if (addLine == YES) {
//            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (BorderWidth / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+MarginX, bounds.size.height-lineHeight, bounds.size.width-MarginX, lineHeight);
//            lineLayer.backgroundColor = NormalGray.CGColor;
//            [layer addSublayer:lineLayer];
//        }
//        UIView *testView = [[UIView alloc] initWithFrame:bounds];
//        [testView.layer insertSublayer:layer atIndex:0];
//        testView.backgroundColor = UIColor.clearColor;
//        cell.backgroundView = testView;
//    }
//    //    }
//}
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
