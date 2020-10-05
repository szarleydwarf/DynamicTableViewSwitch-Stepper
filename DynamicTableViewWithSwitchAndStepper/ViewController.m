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
@property NSMutableArray*arrayTopLevel;

@property int newStepValueForSection;
@property int oldStepValueForSection;
@property int newStepValueForRows;
@property int oldStepValueForRows;

- (IBAction)resetStepperWhenStatusChange:(UISwitch *)sender;
- (IBAction)doStep:(UIStepper *)sender;
- (void)updateSections;
- (void)updateRows:(BOOL) addRow;
@end
/* Requirements:
 When the switch is ON
 - incrementing stepper add new section with no rows, when
 - decrementing - section is removed
 
 When switch is OFF
 - incrementing stepper add new row to all sections,
 - decrementing last row in each section should be removed
 */
@implementation ViewController
@synthesize newStepValueForSection, oldStepValueForSection, stepper, switcher, mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.switcher setOn: true];
    [self.stepper setValue:0];
    
    self.oldStepValueForSection = 0;
    self.oldStepValueForRows = 0;
    
    self.arrayTopLevel = [[NSMutableArray alloc]init];
}

- (IBAction)resetStepperWhenStatusChange:(UISwitch *)sender {
    if (sender.isOn) {
        [self.stepper setValue:self.oldStepValueForSection];
    } else if (!sender.isOn) {
        [self.stepper setValue:self.oldStepValueForRows];
    }
}

- (IBAction)doStep:(UIStepper *)sender {
    if (self.switcher.isOn) {
        self.newStepValueForSection = sender.value;
        [self updateSections];
    } else if (!self.switcher.isOn) {
        self.newStepValueForRows = sender.value;
        BOOL addRow = (self.oldStepValueForRows > self.newStepValueForRows) ? false : true;
        [self updateRows: addRow];
    }
}

- (void) updateSections {
    NSMutableArray*rows = [[NSMutableArray alloc]init];

    if (self.oldStepValueForSection < self.newStepValueForSection) {
        [self.arrayTopLevel addObject:rows];
    }
    else if (self.oldStepValueForSection > self.newStepValueForSection) {
        [self.arrayTopLevel removeLastObject];
    }
    [self.mainTableView reloadData];
    self.oldStepValueForSection = self.newStepValueForSection;
}

- (void) updateRows:(BOOL) addRow {
    int arraySize = (int)[self.arrayTopLevel count];
    if(arraySize > 0){
        for (int i = 0; i < arraySize; i++) {
            if (addRow) {
                int size = (int)[self.arrayTopLevel[i] count];
                [self.arrayTopLevel[i] addObject:[[NSString alloc]initWithFormat:@"Row # %d", size++]];
            } else if (!addRow) {
                [self.arrayTopLevel[i] removeLastObject];
            }
        }
        
        [self.mainTableView reloadData];
        self.oldStepValueForRows = self.newStepValueForRows;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrayTopLevel count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayTopLevel[section] count];;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  [[NSString alloc]initWithFormat:@"Section %ld", section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.textLabel.text = self.arrayTopLevel[indexPath.section][indexPath.row];
    
    return cell;
}

@end
