//
// Created by jcoenradie on 12/9/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SelectTableViewController : UIViewController {

}

@property(nonatomic, copy) NSString *selectedTable;
@property(nonatomic, copy) void (^tableSelected)(NSString *);

- (void)closeModal:(id)sender;

@end