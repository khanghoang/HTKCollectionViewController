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
    [self.collectionView addGestureRecognizer:[self swipeLeftGesture]];
    [self.collectionView addGestureRecognizer:[self swipeDownGesture]];
    [self.collectionView addGestureRecognizer:[self swipeUpGesture]];
}

#pragma mark - Gesture Factory
- (UIGestureRecognizer *)swipeUpGesture
{
    SEL swipeUpSelector = @selector(onSwipeUp:);
    return [self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionUp andSelector:swipeUpSelector];
}

- (UIGestureRecognizer *)swipeDownGesture
{
    SEL swipeDownSelector = @selector(onSwipeDown:);
    return [self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionDown andSelector:swipeDownSelector];
}

- (UIGestureRecognizer *)swipeLeftGesture
{
    SEL swipeLeftSelector = @selector(onSwipeLeft:);
    return [self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionLeft andSelector:swipeLeftSelector];
}

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
    
    UILabel *lblIdentifier = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 250, 100)];
    lblIdentifier.text = [NSString stringWithFormat:@"{%ld, %ld}", (long)indexPath.section, (long)indexPath.row];
    lblIdentifier.font = [UIFont boldSystemFontOfSize:35];
    [cell addSubview:lblIdentifier];
    
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:getrandom(0, 255)/255.0 green:getrandom(0, 255)/255.0 blue:getrandom(0, 255)/255.0 alpha:1.0];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (0 == section) {
        return 4;
    }
    
    if (1 == section) {
        return 1;
    }
    
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
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
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    switch (direction) {
        case ScrollDirectionRight:
            row < [self.collectionView numberOfItemsInSection:section]-1 ? row++ : row;
            break;
            
        case ScrollDirectionLeft:
            row > 0 ? row-- : row;
            break;
            
        case ScrollDirectionUp:
            section > 0 ? section-- : section;
            break;
        
        case ScrollDirectionDown:
            section < sectionCount-1 ? section++ : section;
            break;
            
        default:
            break;
    }
    
    NSInteger maxRowIndexInSection = [self.collectionView numberOfItemsInSection:section]-1;
    if (row > maxRowIndexInSection) {
        row = maxRowIndexInSection;
    }
    
    return [NSIndexPath indexPathForRow:row
                              inSection:section];
}

- (CGRect)getFrameOfIndexPath:(NSIndexPath *)indexPath
{
//    return [HTKCollectionViewLayout frameForItemAtIndexPath:indexPath];
    
    NSInteger x = indexPath.row * 768;
    NSInteger y = indexPath.section *1024;
    
    return CGRectMake(x, y, 768, 1024);
}

#pragma mark - Swipe gestures
- (void)onSwipeUp:(id)sender
{
    NSLog(@"Swipe Up");
    CGRect nextFrame = [self frameNextWithDirection:ScrollDirectionDown];
    [self.collectionView scrollRectToVisible:nextFrame animated:YES];
}

- (void)onSwipeDown:(id)sender
{
    NSLog(@"Swipe Down");
    CGRect nextFrame = [self frameNextWithDirection:ScrollDirectionUp];
    [self.collectionView scrollRectToVisible:nextFrame animated:YES];
}

- (void)onSwipeRight:(id)sender
{
    NSLog(@"Swipe Right");
    CGRect nextFrame = [self frameNextWithDirection:ScrollDirectionLeft];
    [self.collectionView scrollRectToVisible:nextFrame animated:YES];
}

- (void)onSwipeLeft:(id)sender
{
    NSLog(@"Swipe Left");
    
    CGRect nextFrame = [self frameNextWithDirection:ScrollDirectionRight];
    [self.collectionView scrollRectToVisible:nextFrame animated:YES];
}

- (CGRect)frameNextWithDirection:(ScrollDirection)direction
{
    NSIndexPath *currentIndexPath = [self getIndexPathBeforeScroll];
    NSIndexPath *nextIndexPath = [self nextIndexPathWithDirection:direction
                                              andCurrentIndexPath:currentIndexPath];
    CGRect nextIndexPathFrame = [self getFrameOfIndexPath:nextIndexPath];
    
    return nextIndexPathFrame;
}


@end
