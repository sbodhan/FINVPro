//
//  ChartListTableViewController.m
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/4/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import "ChartListTableViewController.h"
#import "DataChartViewController.h"

@interface ChartListTableViewController ()

@end

@implementation ChartListTableViewController
//NSArray *chartArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // chartArray = @[@"LineChart",@"BarChart",@"CircleChart",@"PieChart",@"ScatterChart",@"RadarChart"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chartArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [chartArray objectAtIndex:indexPath.row];
    
    return cell;
}

*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DataChartViewController * viewController = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"lineChart"]) {
        
        //Add line chart
        
        viewController.title = @"Line Chart";
        
    } else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add bar chart
        
        viewController.title = @"Bar Chart";
    } else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        //Add circle chart
        
        viewController.title = @"Circle Chart";
        
    } else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        //Add pie chart
        
        viewController.title = @"Pie Chart";
    } else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add scatter chart
        
        viewController.title = @"Scatter Chart";
    }else if ([segue.identifier isEqualToString:@"radarChart"])
    {
        //Add radar chart
        
        viewController.title = @"Radar Chart";
    }

}


@end
