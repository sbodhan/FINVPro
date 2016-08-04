//
//  DataChartViewController.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/4/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface DataChartViewController : UIViewController<PNChartDelegate>

@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
@property (nonatomic) PNRadarChart *radarChart;

@end
