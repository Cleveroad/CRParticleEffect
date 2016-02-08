//
//  CRMagicPanGestureRecognizer.h
//  CRMagicGesture
//
//  Created by Ihor Teltov on 1/21/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRParticleEffectLayer.h"

NS_ASSUME_NONNULL_BEGIN

@class CRMagicPanGestureRecognizer;

/**
 CRMagicPanGestureRecognizerDelegate is UIGestureRecognizerDelegate extension
 */
@protocol CRMagicPanGestureRecognizerDelegate <UIGestureRecognizerDelegate>
@optional
/**
 Called before gesture recognizer creates new particle effect for the touch. Returning nil causes it to use layer from particleEffectLayer property.
 */
- (CRParticleEffectLayer *)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
                 particleEffectLayerForTouch:(UITouch *)touch
                                   withIndex:(NSUInteger)index;
/**
 Called when gesture recognizer is ready to display new particle effect for the touch. Use to customize particle effects before showing.
 */
- (void)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
willShowParticleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
                 forTouch:(UITouch *)touch
                withIndex:(NSUInteger)index;
/**
 Called when gesture recognizer touch moved. Use to customize particle effects during panning (dragging).
 */
- (void)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
willMoveParticleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
                 forTouch:(UITouch *)touch
                withIndex:(NSUInteger)index;
@end


/**
 CRMagicPanGestureRecognizer subclass of UIPanGestureRecognizer that provides particle effects on finger movement. Set minimumNumberOfTouches and maximumNumberOfTouches to limit number of active particle effects.
 */
@interface CRMagicPanGestureRecognizer : UIPanGestureRecognizer

/**
 Initializes an allocated gesture-recognizer object with a target, an action selector and an instance of CRParticleEffectLayer.
 @param target An object that is the recipient of action messages sent by the receiver when it recognizes a gesture. nil is not a valid value.
 @param action A selector that identifies the method implemented by the target to handle the gesture recognized by the receiver. The action selector must conform to the signature described in the class overview. NULL is not a valid value.
 @param particleEffectLayer Effect layer that will be used when it's not provided by delegete method gestureRecognizer:willShowParticleEffectLayer:forTouch:withIndex:. Can be nil.
 */
- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
           particleEffectLayer:(nullable CRParticleEffectLayer *)particleEffectLayer NS_DESIGNATED_INITIALIZER;

/**
 The delegate of the gesture recognizer.
 */
@property (weak, nonatomic, nullable) id<CRMagicPanGestureRecognizerDelegate> delegate;

/**
 Effect layer that will be copied for every new touch on screen. Lazy initialization.
 */
@property (nonatomic) CRParticleEffectLayer *particleEffectLayer;

/**
 Removes all active particle effects for gesture.
 @param animated Pass YES to wait till particle animation finishes.
 */
- (void)removeAllParticleEffectsAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END