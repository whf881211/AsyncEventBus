
Pod::Spec.new do |spec|


  spec.name         = "AsyncEventBus"
  spec.version      = "0.0.6"
  spec.summary      = "A publish/subscribe event bus for iOS."

  spec.homepage     = "https://github.com/whf881211/AsyncEventBus"


  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "whf881211" => "whf881211@gmail.com" }
  spec.ios.deployment_target = '9.0'
  spec.swift_versions = "4.0"
  spec.source       = { :git => "https://github.com/whf881211/AsyncEventBus.git", :tag => spec.version.to_s }
  spec.source_files  = "source/*.swift", "source/**/*.swift"
  spec.static_framework  =  true




end
