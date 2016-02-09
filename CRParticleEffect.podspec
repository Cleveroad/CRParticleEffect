#
# Be sure to run `pod lib lint CRParticleEffect.podspec' to ensure this is a
# valid spec before submitting.
#
Pod::Spec.new do |s|
  s.name             = "CRParticleEffect"
  s.version          = "0.0.2"
  s.summary          = "A UIPanGestureRecognizer subclass that provides particle effect on finger movement and simple CAEmitterLayer subclass"
  s.description      = <<-DESC
                       A CocoaPod that simplifies creation of the particle effects. Supplied with UIPanGestureRecognizer subclass. Customize particle effect for every touch on screen separately. Works with storyboards.
                       DESC
  s.homepage         = "https://github.com/Cleveroad/CRParticleEffect"
  s.screenshot       = "https://www.cleveroad.com/public/comercial/CRParticleEffect.gif"
  s.license          = 'MIT'
  s.author           = { "Ihor Teltov" => "igor.teltov@gmail.com" }
  s.source           = { :git => "https://github.com/Cleveroad/CRParticleEffect.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.{h,m}'
  s.resource_bundles = {
    'CRParticleEffect' => ['Pod/Assets/*.xcassets/**/*.png']
  }
end
