//
//  SliderMenuController.h
//  Resume
//
//  Created by KishanKumar Sutariya on 08/06/16.
//  Copyright © 2016 Crayon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"

@interface SliderMenuController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

}

@property (nonatomic, retain) RDVTabBarController *rdvTabVC;
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
-(void)reloadData;
@end
