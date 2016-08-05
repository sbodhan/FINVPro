//
//  DataChartViewController.m
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/4/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import "DataChartViewController.h"
#define ARC4RANDOM_MAX 0x100000000

@interface DataChartViewController ()

@end

@implementation DataChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarChart];
    // Do any additional setup after loading the view.
}

-(void)createBarChart {
    if ([self.title isEqualToString:@"Line Chart"]) {
        
        self.title = @"Line Chart";
        
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        self.lineChart.yLabelFormat = @"%1.1f";
        self.lineChart.backgroundColor = [UIColor clearColor];
        [self.lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        self.lineChart.showCoordinateAxis = YES;
        
        // added an examle to show how yGridLines can be enabled
        // the color is set to clearColor so that the demo remains the same
        self.lineChart.yGridLinesColor = [UIColor clearColor];
        self.lineChart.showYGridLines = YES;
        
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        self.lineChart.yFixedValueMax = 300.0;
        self.lineChart.yFixedValueMin = 0.0;
        
        [self.lineChart setYLabels:@[
                                     @"0 min",
                                     @"50 min",
                                     @"100 min",
                                     @"150 min",
                                     @"200 min",
                                     @"250 min",
                                     @"300 min",
                                     ]
         ];
        
        // Line Chart #1
        NSArray * data01Array = @[@60.1, @160.1, @126.4, @0.0, @186.2, @127.2, @176.2];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.dataTitle = @"Alpha";
        data01.color = PNFreshGreen;
        data01.alpha = 0.3f;
        data01.itemCount = data01Array.count;
        data01.inflexionPointColor = PNRed;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart #2
        NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.dataTitle = @"Beta";
        data02.color = PNTwitterColor;
        data02.alpha = 0.5f;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleCircle;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        self.lineChart.chartData = @[data01, data02];
        [self.lineChart strokeChart];
        self.lineChart.delegate = self;
        
        
        [self.view addSubview:self.lineChart];
        
        self.lineChart.legendStyle = PNLegendItemStyleStacked;
        self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.lineChart.legendFontColor = [UIColor redColor];
        
        UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
        [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
        [self.view addSubview:legend];
    }
    else if ([self.title isEqualToString:@"Bar Chart"])
    {
        static NSNumberFormatter *barChartFormatter;
        if (!barChartFormatter){
            barChartFormatter = [[NSNumberFormatter alloc] init];
            barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            barChartFormatter.allowsFloats = NO;
            barChartFormatter.maximumFractionDigits = 0;
        }
        self.title = @"Bar Chart";
        
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        //        self.barChart.showLabel = NO;
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
        };
        
        self.barChart.yChartLabelWidth = 20.0;
        self.barChart.chartMarginLeft = 30.0;
        self.barChart.chartMarginRight = 10.0;
        self.barChart.chartMarginTop = 5.0;
        self.barChart.chartMarginBottom = 10.0;
        
        
        self.barChart.labelMarginTop = 5.0;
        self.barChart.showChartBorder = YES;
        [self.barChart setXLabels:@[@"2",@"3",@"4",@"5",@"2",@"3",@"4",@"5"]];
        //       self.barChart.yLabels = @[@-10,@0,@10];
        //        [self.barChart setYValues:@[@10000.0,@30000.0,@10000.0,@100000.0,@500000.0,@1000000.0,@1150000.0,@2150000.0]];
        [self.barChart setYValues:@[@10.82,@1.88,@6.96,@33.93,@10.82,@1.88,@6.96,@33.93]];
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNGreen,PNRed,PNGreen]];
        self.barChart.isGradientShow = NO;
        self.barChart.isShowNumbers = NO;
        
        [self.barChart strokeChart];
        
        self.barChart.delegate = self;
        
        [self.view addSubview:self.barChart];
    }
    else if ([self.title isEqualToString:@"Circle Chart"])
    {
        self.title = @"Circle Chart";
        
        
        self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,150.0, SCREEN_WIDTH, 100.0)
                                                          total:@100
                                                        current:@60
                                                      clockwise:YES];
        
        self.circleChart.backgroundColor = [UIColor clearColor];
        
        [self.circleChart setStrokeColor:[UIColor clearColor]];
        [self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
        [self.circleChart strokeChart];
        
        [self.view addSubview:self.circleChart];
    }
    else if ([self.title isEqualToString:@"Pie Chart"])
    {
        self.title = @"Pie Chart";
        
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                           ];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.showOnlyValues = NO;
        [self.pieChart strokeChart];
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        
        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
        [self.view addSubview:legend];
        
        [self.view addSubview:self.pieChart];
    }
    else if ([self.title isEqualToString:@"Scatter Chart"])
    {
        
        self.title = @"Scatter Chart";
        
        self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6.0 - 30, 135, 280, 200)];
        //        self.scatterChart.yLabelFormat = @"xxx %1.1f";
        [self.scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
        [self.scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];
        [self.scatterChart setAxisXLabel:@[@"x1", @"x2", @"x3", @"x4", @"x5", @"x6"]];
        [self.scatterChart setAxisYLabel:@[@"y1", @"y2", @"y3", @"y4", @"y5"]];
        
        NSArray * data01Array = [self randomSetOfObjects];
        PNScatterChartData *data01 = [PNScatterChartData new];
        data01.strokeColor = PNGreen;
        data01.fillColor = PNFreshGreen;
        data01.size = 2;
        data01.itemCount = [[data01Array objectAtIndex:0] count];
        data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
        __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
        __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
        
        data01.getData = ^(NSUInteger index) {
            CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
            CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
            return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
        };
        
        [self.scatterChart setup];
        self.scatterChart.chartData = @[data01];
        /***
         this is for drawing line to compare
         CGPoint start = CGPointMake(20, 35);
         CGPoint end = CGPointMake(80, 45);
         [self.scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
         ***/
        self.scatterChart.delegate = self;
        [self.view addSubview:self.scatterChart];
    }
    else if ([self.title isEqualToString:@"Radar Chart"])
    {
        self.title = @"Radar Chart";
        
        NSArray *items = @[[PNRadarChartDataItem dataItemWithValue:15 description:@"Eating Out"],
                           [PNRadarChartDataItem dataItemWithValue:3 description:@"Groceries"],
                           [PNRadarChartDataItem dataItemWithValue:57 description:@"Household"],
                           ];

        self.radarChart = [[PNRadarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 300.0) items:items valueDivider:1];
        [self.radarChart strokeChart];
        
        [self.view addSubview:self.radarChart];
    }
    
}

- (NSArray *) randomSetOfObjects{
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25 ; i++) {
        [XAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisX_maxValue - self.scatterChart.AxisX_minValue) + self.scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisY_maxValue - self.scatterChart.AxisY_minValue) + self.scatterChart.AxisY_minValue)]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return (NSArray*) array;
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
