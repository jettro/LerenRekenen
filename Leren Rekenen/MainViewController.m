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
    self.title = @"Leren rekenen";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *simpleTableButton = [self createSimpleTableButton];
    UIButton *mixedTableButton = [self createMixedTableButton];

    [self.view addSubview:simpleTableButton];
    [self.view addSubview:mixedTableButton];
}

- (UIButton *)createSimpleTableButton {
    UIButton *simpleTableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [simpleTableButton setTitle:@"Eenvoudige tafels" forState:UIControlStateNormal];
    [simpleTableButton setFrame:CGRectMake(10, 50, 150, 30)];
    [simpleTableButton addTarget:self action:@selector(openSimpleTable) forControlEvents:UIControlEventTouchUpInside];
    return simpleTableButton;
}

- (UIButton *)createMixedTableButton {
    UIButton *simpleTableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [simpleTableButton setTitle:@"Gemengde tafels" forState:UIControlStateNormal];
    [simpleTableButton setFrame:CGRectMake(10, 90, 150, 30)];
    [simpleTableButton addTarget:self action:@selector(openMixedTable) forControlEvents:UIControlEventTouchUpInside];
    return simpleTableButton;
}

- (void)openMixedTable {
    MixedTableViewController *mixedTableViewController = [MixedTableViewController new];
    [self.navigationController pushViewController:mixedTableViewController animated:TRUE];
}

- (void)openSimpleTable {
    SimpleTableViewController *simpleTableViewController = [SimpleTableViewController new];
    [self.navigationController pushViewController:simpleTableViewController animated:TRUE];
}

@end