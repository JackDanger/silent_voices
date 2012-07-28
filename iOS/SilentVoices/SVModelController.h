//
//  SVModelController.h
//  SilentVoices
//
//  Created by Jack Canty on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVDataViewController;

@interface SVModelController : NSObject <UIPageViewControllerDataSource>
- (SVDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(SVDataViewController *)viewController;
@end
