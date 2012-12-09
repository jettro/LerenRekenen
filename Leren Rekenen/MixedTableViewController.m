//
// Created by jcoenradie on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MixedTableViewController.h"


@implementation MixedTableViewController {

}

- (id)init {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 25)];
//    greeting.text = @"Oefenen van gemengde tafels.";
//    [self.view addSubview:greeting];
//    [self.view addSubview:[self addSelectTableButton]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(logMe) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(20, 20, 300, 25)];
    [self.view addSubview:button];

}

- (void)logMe {
    NSLog(@"A button is clicked.");
}

- (UIView *)addSelectTableButton {
    UIButton *chooseTableBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chooseTableBtn setFrame:CGRectMake(200, 0, 100, 20)];
    [chooseTableBtn setTitle:@"Kies" forState:UIControlStateNormal];
    [chooseTableBtn addTarget:self action:@selector(selectTableDummy) forControlEvents:UIControlEventTouchUpInside];
    return chooseTableBtn;
}

- (void)selectTableDummy {
    NSLog(@"About to select a table");
}


@end