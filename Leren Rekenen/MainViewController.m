//
// Created by jcoenradie on 11/29/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainViewController.h"
#import "SimpleTableViewController.h"
#import "MixedTableViewController.h"


@implementation MainViewController {

}

- (id)init {
    self = [super init];
    if (self) {
        UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 25)];
        greeting.text = @"Hallo, wat gaan we doen?";
        [self.view addSubview:greeting];
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    UIBarButtonItem *simple = [[UIBarButtonItem alloc] initWithTitle:@"Simpel" style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(openSimpleTable:)];

    UIBarButtonItem *mixed = [[UIBarButtonItem alloc] initWithTitle:@"Mixed" style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(openMixedTable:)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:simple,mixed,nil];
}

- (IBAction)openMixedTable:(id)sender {
    MixedTableViewController *mixedTableViewController = [MixedTableViewController new];
    [self.view addSubview:mixedTableViewController.view];
}

- (IBAction)openSimpleTable:(id)sender {
    SimpleTableViewController *simpleTableViewController = [SimpleTableViewController new];
    [self.view addSubview:simpleTableViewController.view];

}


@end