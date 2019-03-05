//
//  MoreViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MoreViewController.h"
#import "ContentTableViewCell.h"
#import "ContentDetailTableViewCell.h"

#import "ResetRouterViewController.h"
#import "CloseRouterViewController.h"
#import "RestoreFactoryViewController.h"
#import "NISelectModel.h"

#import "NetServiceViewController.h"
#import "APNManagerViewController.h"
#import "PINManagerViewController.h"
@interface MoreViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    // Do any additional setup after loading the view.
}


- (void)loadData{
    _dataArray =
    (NSMutableArray *)@[
                        [NISelectModel setTitle:@"网络运营商" value:@"选择网络运营商"],
                        [NISelectModel setTitle:@"APN设置" value:nil],
                        [NISelectModel setTitle:@"PIN管理" value:nil]
                        ];
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NISelectModel *cellData = _dataArray[indexPath.row];
    ContentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentDetailTableViewCell"];
    cell.labelTitle.text = cellData.title;
    [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
    cell.labelDetail.text = cellData.value;
    [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontDetail];
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NISelectModel *cellData = _dataArray[indexPath.row];
    if (indexPath.row == 0) {
         [self performSegueWithIdentifier:@"toNetServiceViewController" sender:self];
    } else if(indexPath.row == 1){
         [self performSegueWithIdentifier:@"toAPNManagerViewController" sender:self];
    }else{
//        PINManagerViewController *pin = [PINManagerViewController new];
//        pin.title = cellData.title;
//        [self.navigationController pushViewController:pin animated:YES];
        [self performSegueWithIdentifier:@"toPINManagerViewController" sender:self];
    }
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
