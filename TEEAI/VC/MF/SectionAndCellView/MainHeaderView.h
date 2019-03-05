//
//  MainHeaderView.h
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelFlow;
@property (weak, nonatomic) IBOutlet UIProgressView *progressFlow;
@property (weak, nonatomic) IBOutlet UILabel *labelBattery;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalBattery;
@property (weak, nonatomic) IBOutlet UILabel *labelBatteryTotal;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBattery;

@property (weak, nonatomic) IBOutlet UILabel *labelBatteryTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettingFlow;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalFlow;
@property (weak, nonatomic) IBOutlet UILabel *labelFlowNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imageFlow;
@property (weak, nonatomic) IBOutlet UILabel *labelFlowTitle;

@end
