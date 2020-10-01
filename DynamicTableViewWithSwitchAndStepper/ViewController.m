//
//  ViewController.m
//  DynamicTableViewWithSwitchAndStepper
//
//  Created by The App Experts on 01/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property BOOL isOn;
@property int step;

- (IBAction)doStep:(UIStepper *)sender;

@end
/*
 When the switch is ON
 - incrementing stepper add new section with no rows, when
 - decrementing - section is removed
 
 When switch is OFF
  - incrementing stepper add new row to all sections,
  - decrementing last row in each section should be removed
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)doStep:(UIStepper *)sender {
}
@end
