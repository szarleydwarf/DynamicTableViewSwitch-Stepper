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
//@property NSMutableArray*rowsValues;

@property int newStepValueForSection;
@property int oldStepValueForSection;
@property int newStepValueForRows;
@property int oldStepValueForRows;

- (IBAction)resetStepperWhenStatusChange:(UISwitch *)sender;
- (IBAction)doStep:(UIStepper *)sender;
- (void)updateSections;
- (void)updateRows;
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
    
    self.dictionary = [[NSMutableDictionary alloc]init];
//    self.rowsValues = [[NSMutableArray alloc]init];
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
        NSLog(@"section value> %f",sender.value);
self.newStepValueForSection = sender.value;
        [self updateSections];
    } else if (!self.switcher.isOn) {
        NSLog(@"rows value> %f",sender.value);
//        self.newStepValueForRows = sender.value;
        [self updateRows];
    }
}

- (void) updateSections {
    NSMutableArray*rows = [[NSMutableArray alloc]init];
    NSString*sectionFormatedString = @"Section %d";
    
    if (self.oldStepValueForSection < self.newStepValueForSection) {
        NSString*key = [[NSString alloc] initWithFormat:sectionFormatedString, self.newStepValueForSection];
        [self.dictionary setValue:rows forKey:key];
    }
    else if (self.oldStepValueForSection > self.newStepValueForSection) {
        NSString*key = [[NSString alloc] initWithFormat:sectionFormatedString, self.oldStepValueForSection];
        [self.dictionary removeObjectForKey:key];
    }
    [self.mainTableView reloadData];
    self.oldStepValueForSection = self.newStepValueForSection;
}

- (void) updateRows {
    //    test if there are any sections
    int dictionarySize = (int)[[self.dictionary allKeys]count];
    if(dictionarySize > 0){
//        check if section has any rows ad new row
        NSArray*keys = [self.dictionary allKeys];
        NSString*sectionFormatedString = @"Row %d";
              
        for(int i = 0; i < dictionarySize; i++){
            NSLog(@"keys value> %@",keys);
            NSMutableArray*value = [self.dictionary valueForKey:keys[i]];
            //find if you need to add or remove object
            NSString*key = [[NSString alloc] initWithFormat:sectionFormatedString, value.count];
            
            [value addObject:key];
            [self.dictionary setValue:value forKey:keys[i]];

        }
        [self.mainTableView reloadData];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.dictionary allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray*dictionaryKeys = [self.dictionary allKeys];
    int count = (int)[[self.dictionary valueForKey:dictionaryKeys[section]]count];
    
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray*keys = [self.dictionary allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString*s1, NSString*s2) {
        return [s1 compare:s2 options:(NSNumericSearch)];
    }];
    
    return [[NSString alloc] initWithFormat: @"%@", keys[section]];
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
