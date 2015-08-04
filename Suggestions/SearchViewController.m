//
//  SearchViewController.m
//  Suggestions
//
//  Created by Vova Musiienko on 04.08.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import "SearchViewController.h"
#import "SuggestionItem.h"
#import "SearchStore.h"


@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

// array with sections (arrays) of items
@property (nonatomic, strong) NSArray* currentItems;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    

}


- (IBAction) serchFieldChanged:(UITextField*)searchField
{
    __weak typeof(self) weakSelf = self;
    
    if (searchField.text.length >= 2) {
        [[SearchStore sharedStore] getSuggestionsForQuery:searchField.text completionBlock:^(NSArray *suggestions, NSError *error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf updateTableForSuggestions:suggestions];
                });
            }
        }];
    }
}


- (void) updateTableForSuggestions:(NSArray*)suggestions
{
    self.currentItems = [self divideForSections:suggestions key:@"type"];
    [self.tableView reloadData];
}


- (NSArray*) divideForSections:(NSArray*)origArr key:(NSString*)sectionKey
{
    NSMutableDictionary *grouped = [[NSMutableDictionary alloc] initWithCapacity:origArr.count];
    for (NSDictionary *dict in origArr) {
        id key = [dict valueForKey:sectionKey];
        
        NSMutableArray *tmp = [grouped objectForKey:key];
        if (tmp == nil) {
            tmp = [NSMutableArray new];
            [grouped setObject:tmp forKey:key];
        }
        [tmp addObject:dict];
    }
    NSArray* result = [grouped allValues];
    return result;
}


- (id) itemAtIndexPath:(NSIndexPath*) ip {
    return self.currentItems[ip.section][ip.row];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.currentItems.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* rowItems = self.currentItems[section];
    return rowItems.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray* rowItems = self.currentItems[section];
    return [(SuggestionItem*)rowItems[0] type];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SuggestionItem* item = [self itemAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Country: %@, City: %@, count: %@", item.localizedCountryName, item.localizedName, item.offerCount];
    
    return cell;
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
