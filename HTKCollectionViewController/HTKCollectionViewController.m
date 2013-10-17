//
//  HTKCollectionViewController.m
//  HTKCollectionViewController
//
//  Created by Triệu Khang on 16/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import "HTKCollectionViewController.h"
#import "HTKCollectionViewLayout.h"

@interface HTKCollectionViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
UIGestureRecognizerDelegate
>

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

#define getrandom(min, max) ((rand()%(int)(((max) + 1)-(min)))+ (min))

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger lastContentOffset;

@end

@implementation HTKCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    HTKCollectionViewLayout *layout = [[HTKCollectionViewLayout alloc] init];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self removeAllOldGuestures];
    [self.collectionView addGestureRecognizer:[self swipeRightGesture]];
}

#pragma mark - Gesture Factory
- (UIGestureRecognizer *)swipeRightGesture
{
    SEL swipeRightSelector = @selector(onSwipeRight:);
    return [self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionRight andSelector:swipeRightSelector];
}

- (UIGestureRecognizer *)swipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction
                                       andSelector:(SEL)seletor;
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:seletor];
    swipe.direction = direction;
    swipe.numberOfTouchesRequired = 1;
    return swipe;
}

#pragma mark - Utilities
- (void)removeAllOldGuestures
{
    NSArray *arrayGuestures = [self.collectionView gestureRecognizers];
    for (UIGestureRecognizer *gesture in arrayGuestures) {
        [self.collectionView removeGestureRecognizer:gesture];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] initWithFrame:self.view.frame];
    }
    
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:getrandom(0, 255)/255.0 green:getrandom(0, 255)/255.0 blue:getrandom(0, 255)/255.0 alpha:1.0];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    ScrollDirection scrollDirection;
//    if (self.lastContentOffset > scrollView.contentOffset.x)
//        scrollDirection = ScrollDirectionRight;
//    else if (self.lastContentOffset < scrollView.contentOffset.x)
//        scrollDirection = ScrollDirectionLeft;
//    
//    self.lastContentOffset = scrollView.contentOffset.x;
//    
//    NSIndexPath *currentIndexPath = [self getIndexPathBeforeScroll];
//    NSIndexPath *nextIndexPath = [self nextIndexPathWithDirection:ScrollDirectionRight
//                                              andCurrentIndexPath:currentIndexPath];
//    CGRect nextFrame = [self getFrameOfIndexPath:nextIndexPath];
//    
//    [scrollView scrollRectToVisible:nextFrame
//                           animated:NO];
//    
}

- (NSIndexPath *)getIndexPathBeforeScroll
{
    UIScrollView *scrollView = (UIScrollView *)self.collectionView;
    return [self indexPathWithPoint:scrollView.contentOffset];
}

- (NSIndexPath *)indexPathWithPoint:(CGPoint)point
{
    NSInteger row = point.x / 768;
    NSInteger section = point.y / 1024;
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSIndexPath *)nextIndexPathWithDirection:(ScrollDirection)direction
                    andCurrentIndexPath:(NSIndexPath *)currentIndexPath
{
    NSInteger row = currentIndexPath.row;
    NSInteger section = currentIndexPath.section;
    
    if (direction == ScrollDirectionRight) {
        row ++;
    }
    
    return [NSIndexPath indexPathForRow:row
                              inSection:section];
}

- (CGRect)getFrameOfIndexPath:(NSIndexPath *)indexPath
{
    return [HTKCollectionViewLayout frameForItemAtIndexPath:indexPath];
}

#pragma mark - Swipe gestures
- (void)onSwipeRight:(id)sender{
    NSLog(@"Swipe Right");
}

#pragma mark - Guesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end
