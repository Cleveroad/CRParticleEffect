//
//  CRViewController.m
//  CRParticleEffect
//
//  Created by Ihor Teltov on 02/07/2016.
//  Copyright (c) 2016 Ihor Teltov. All rights reserved.
//

#import "CRViewController.h"
#import <CRParticleEffect/CRParticleEffect.h>

@interface CRViewController () <CRMagicPanGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet CRMagicPanGestureRecognizer *magicPanGestureRecognizer;
@property (nonatomic) NSArray<UIImage *> *images;
@property (nonatomic) NSArray<UIColor *> *colors;

@property (nonatomic) CGFloat minScale;
@property (nonatomic) CGFloat maxScale;
@property (nonatomic) CGFloat scaleAffectedRadius;
@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = @[[UIImage imageNamed:kCRParticleEffectImageNameHearts],
                    [UIImage imageNamed:kCRParticleEffectImageNameSpades],
                    [UIImage imageNamed:kCRParticleEffectImageNameDiamonds],
                    [UIImage imageNamed:kCRParticleEffectImageNameClubs]];
    
    self.colors = @[[[UIColor redColor] colorWithAlphaComponent:0.75f],
                    [[UIColor blackColor] colorWithAlphaComponent:0.75f],
                    [[UIColor redColor] colorWithAlphaComponent:0.75f],
                    [[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    
    self.minScale = 0.5f;
    self.maxScale = 1.5f;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.scaleAffectedRadius = MAX(screenSize.width, screenSize.height) / 2;
    
    self.magicPanGestureRecognizer.delegate = self;
}

- (CGFloat)distanceFromCenterToPoint:(CGPoint)point
{
    return hypotf(self.view.center.x - point.x, self.view.center.y - point.y);
}

#pragma mark - CRMagicPanGestureRecognizerDelegate

- (CRParticleEffectLayer *)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
                 particleEffectLayerForTouch:(UITouch *)touch
                                   withIndex:(NSUInteger)index
{
    return [[CRParticleEffectLayer alloc] initWithImages:@[self.images[index]]];
}

- (void)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
willShowParticleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
                 forTouch:(UITouch *)touch
                withIndex:(NSUInteger)index
{
    particleEffectLayer.color = self.colors[index];
}

- (void)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
willMoveParticleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
                 forTouch:(UITouch *)touch withIndex:(NSUInteger)index
{
    CGPoint location = [touch locationInView:gestureRecognizer.view];
    CGFloat distance = [self distanceFromCenterToPoint:location];
    particleEffectLayer.scale = self.minScale + (self.maxScale - self.minScale) * (1 - distance / self.scaleAffectedRadius);
}

@end
