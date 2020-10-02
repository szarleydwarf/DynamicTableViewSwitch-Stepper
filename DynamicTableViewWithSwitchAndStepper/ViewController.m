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
@property NSMutableDictionary*dictionary;

@property BOOL isOn;
@property int step;
@property int previousStepValue;

- (IBAction)doStep:(UIStepper *)sender;
- (void)updateSections;
- (void)updateRows;
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
@synthesize isOn, step, previousStepValue, stepper, switcher, mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.switcher setOn: true];
    [self.stepper setValue:0];
    
    self.previousStepValue = 0;
    self.dictionary = [[NSMutableDictionary alloc]init];
}


- (IBAction)doStep:(UIStepper *)sender {
    self.step = sender.value;
    if (self.switcher.isOn) {
        [self updateSections];
    } else if (!self.switcher.isOn) {
        [self updateRows];
    }
}

- (void) updateSections {
    
}

- (void) updateRows {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.dictionary allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray*dictionaryKeys = [self.dictionary allKeys];
    int count = (int)[[self.dictionary valueForKey:dictionaryKeys[section]]count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSArray*dictionaryKeys = [self.dictionary allKeys];
    NSArray*valuesForKey = [self.dictionary valueForKey:dictionaryKeys[indexPath.section]];
    
    cell.textLabel.text = valuesForKey[indexPath.row];
    
    return cell;
}

@end
