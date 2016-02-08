//
//  CRParticleEffectLayer.h
//  CRMagicGesture
//
//  Created by Ihor Teltov on 1/31/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kCRParticleEffectImageNameHearts;
extern NSString * const kCRParticleEffectImageNameDiamonds;
extern NSString * const kCRParticleEffectImageNameClubs;
extern NSString * const kCRParticleEffectImageNameSpades;

typedef void (^CREmitterCellConfigBlock)(CAEmitterCell *emitterCell, NSInteger index);

/**
 CAEmitterLayer subclass that conforms to NSCopying protocol and simplifies particle effects creation.
 */
@interface CRParticleEffectLayer : CAEmitterLayer <NSCopying>

@property (nonatomic) UIColor *color;

/**
 Initializes an allocated CRParticleEffectLayer object and creates CAEmitterCell for every image in images array.
 @param images Array of UIImage instances.
 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images;
/**
 Initializes an allocated CRParticleEffectLayer object and creates CAEmitterCell for every image in images array.
 @param images Array of UIImage instances.
 @param configBlock Configuration block is called for every image in images array. Use to customize emitter cells attributes.
 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images
        emitterCellConfigBlock:(nullable CREmitterCellConfigBlock)configBlock;
/**
 Stops emitting new particles and removes layer from it's superlayer after animation finishes.
 */
- (void)finishAndRemoveFromSuperlayer;
@end

NS_ASSUME_NONNULL_END