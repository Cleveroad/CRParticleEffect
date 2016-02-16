## CRParticleEffect [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome) <img src="https://www.cleveroad.com/public/comercial/label-ios.svg" height="20"> <a href="https://www.cleveroad.com/?utm_source=github&utm_medium=label&utm_campaign=contacts"><img src="https://www.cleveroad.com/public/comercial/label-cleveroad.svg" height="20"></a>

#### A CocoaPod that simplifies creation of particle effects. Supplied with UIPanGestureRecognizer subclass.

<img src="https://www.cleveroad.com/public/comercial/CRParticleEffect.gif" />

We know how to add some visual allure to your mobile app and can't wait to share with you. Meet new open-source library for iOS applications created by Cleveroad. CRParticleEffect function will make any pan touch visually attractive and memorable by adding unique particle effect. To know all the advantages of CRParticleEffect library and find out how to implement it into your app, read our blog post - <a href="https://www.cleveroad.com/blog/how-we-created-particle-effect-for-ios-apps">How we created Particle Effect for iOS apps</a>

## Installation

CRParticleEffect is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CRParticleEffect"
```

and run `pod install` in terminal.

```objective-c
#import <CRparticleEffect/CRParticleEffect.h>
```

## Usage
* ### `CRParticleEffectLayer`
   * ##### Init with array of images `NSArray<UIImage *>`:
     ```objective-c
     CRParticleEffectLayer *layer = [[CRParticleEffectLayer alloc] initWithImages:@[...]];
     ```
     
     Note: By default `CRParticleEffectLayer` scales images respecting `[UIScreen mainScreen].scale`. Set layer's `contentScale` to change this behavior.
     
   * ##### Config `CAEmitterCell` for every image in array:
     ```objective-c
     CRParticleEffectLayer *layer =
     [[CRParticleEffectLayer alloc] initWithImages:@[...]
                            emitterCellConfigBlock:^(CAEmitterCell * _Nonnull emitterCell, NSInteger index) {
        emitterCell.birthRate = 10 * (index + 1);
     }];
     ```
     
   * ##### Set color for all particle effect's cells with layer's `color` property
     ```objective-c
     particleEffectLayer.color = [[UIColor redColor] colorWithAlphaComponent:0.75f]
     ```
     
* ### `CRMagicPanGestureRecognizer`
   * Supports storyboards;
   * Set `minimumNumberOfTouches` and `maximumNumberOfTouches` to limit number of active particle effects.
   * Implement `CRMagicPanGestureRecognizerDelegate` to customize particle effects behavior.
* ### `CRMagicPanGestureRecognizerDelegate`
  ```objective-c
  - (CRParticleEffectLayer *)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
                   particleEffectLayerForTouch:(UITouch *)touch
                                     withIndex:(NSUInteger)index
  {
      //Supply particleEffectLayer for each new touch with index
      return [[CRParticleEffectLayer alloc] initWithImages:@[self.images[index]]];
  }

  - (void)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
  willShowParticleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
                   forTouch:(UITouch *)touch
                  withIndex:(NSUInteger)index
  {
      //Change particles color for every touch with index
      particleEffectLayer.color = self.colors[index];
  }

  - (void)gestureRecognizer:(CRMagicPanGestureRecognizer *)gestureRecognizer
  willMoveParticleEffectLayer:(CRParticleEffectLayer *)particleEffectLayer
                   forTouch:(UITouch *)touch withIndex:(NSUInteger)index
  {
      //Update particle effect's attributes during panning (dragging) for specific touch with index
  }
  ```

## Custom particle images
* Use white images with transparent background;
* If you do not supply multiple resolutions set `CRparticleEffectLayer`'s `contentScale` to 1.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Support
If you have any questions, please contact us for support at info@cleveroad.com (email subject: «CRParticleEffect support.»)
<br>or
<br>Use our contacts:
<br><a href="https://www.cleveroad.com/?utm_source=github&utm_medium=link&utm_campaign=contacts">Cleveroad.com</a>
<br><a href="https://www.facebook.com/cleveroadinc">Facebook account</a>
<br><a href="https://twitter.com/CleveroadInc">Twitter account</a>
<br><a href="https://www.youtube.com/c/Cleveroadinc">Youtube account</a>
<br><a href="https://plus.google.com/+CleveroadInc/">Google+ account</a>
<br><a href="https://www.linkedin.com/company/cleveroad-inc-">LinkedIn account</a>
<br><a href="https://dribbble.com/cleveroad">Dribbble account</a>

## License

CRParticleEffect is available under the MIT license. See the LICENSE file for more info.
