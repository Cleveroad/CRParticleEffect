//
//  CRMagicPanGestureRecognizer.m
//  CRMagicGesture
//
//  Created by Ihor Teltov on 1/21/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRMagicPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface CRMagicPanGestureRecognizer ()
@property (nonatomic) NSMutableDictionary<NSString *, CRParticleEffectLayer *> *particleEffectLayers;
@end

@implementation CRMagicPanGestureRecognizer

@dynamic delegate;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.particleEffectLayers = [NSMutableDictionary new];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    return [self initWithTarget:target action:action particleEffectLayer:nil];
}

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
           particleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.particleEffectLayer = particleEffectLayer;
        self.particleEffectLayers = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark -

- (CRParticleEffectLayer *)particleEffectLayer
{
    if (!_particleEffectLayer) {
        _particleEffectLayer = [CRParticleEffectLayer new];
    }
    return _particleEffectLayer;
}

- (NSString *)keyForTouch:(nonnull UITouch *)touch
{
    return [NSString stringWithFormat:@"%p", touch];
}

- (CRParticleEffectLayer *)getOrCreateParticleEffectLayerForTouch:(UITouch *)touch
{
    NSString *key = [self keyForTouch:touch];
    CRParticleEffectLayer *particleEffectLayer = self.particleEffectLayers[key];
    if (!particleEffectLayer && self.particleEffectLayers.count < self.maximumNumberOfTouches) {
        
        NSUInteger indexOfTouch = self.particleEffectLayers.count;
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:particleEffectLayerForTouch:withIndex:)]) {
            particleEffectLayer = [self.delegate gestureRecognizer:self
                                       particleEffectLayerForTouch:touch
                                                         withIndex:indexOfTouch];
        }
        if (!particleEffectLayer) {
            particleEffectLayer = [self.particleEffectLayer copy];
        }
        
        particleEffectLayer.beginTime = CACurrentMediaTime();
        particleEffectLayer.birthRate = 1;
        
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:willShowParticleEffectLayer:forTouch:withIndex:)]) {
            [self.delegate gestureRecognizer:self
                 willShowParticleEffectLayer:particleEffectLayer
                                    forTouch:touch
                                   withIndex:indexOfTouch];
        }
        [self.view.layer addSublayer:particleEffectLayer];
        self.particleEffectLayers[key] = particleEffectLayer;
    }
    return particleEffectLayer;
}

- (void)removeParticleEffectForTouch:(UITouch *)touch
{
    NSString *key = [self keyForTouch:touch];
    CRParticleEffectLayer *particleEffectsLayer = self.particleEffectLayers[key];
    if (particleEffectsLayer) {
        [particleEffectsLayer finishAndRemoveFromSuperlayer];
        [self.particleEffectLayers removeObjectForKey:key];
    }
}

- (void)removeAllParticleEffectsAnimated:(BOOL)animated
{
    for (CRParticleEffectLayer *layer in self.particleEffectLayers.allValues) {
        layer.birthRate = 0;
        if (animated) {
            [layer finishAndRemoveFromSuperlayer];
        } else {
            [layer removeFromSuperlayer];
        }
    }
    [self.particleEffectLayers removeAllObjects];
}

#pragma mark - Override UIGestureRecognizer

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    switch (self.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            for (UITouch *touch in touches) {
                CRParticleEffectLayer *particleEffectsLayer = [self getOrCreateParticleEffectLayerForTouch:touch];
                if (particleEffectsLayer) {
                    if ([self.delegate respondsToSelector:@selector(gestureRecognizer:willMoveParticleEffectLayer:forTouch:withIndex:)]) {
                        NSUInteger indexOfTouch = [self.particleEffectLayers.allValues indexOfObject:particleEffectsLayer];
                        [self.delegate gestureRecognizer:self
                             willMoveParticleEffectLayer:particleEffectsLayer
                                                forTouch:touch
                                               withIndex:indexOfTouch];
                    }
                    particleEffectsLayer.emitterPosition = [touch locationInView:self.view];
                }
            }
            break;
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        [self removeParticleEffectForTouch:touch];
    }
}

- (void)setState:(UIGestureRecognizerState)state
{
    [super setState:state];
    
    switch (state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self removeAllParticleEffectsAnimated:YES];
            break;
        default:
            break;
    }
    if (state == UIGestureRecognizerStateFailed || state == UIGestureRecognizerStateCancelled) {
        
    }
}

@end
