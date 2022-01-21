#
#  Be sure to run `pod spec lint Login.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "Login"
  spec.version      = "0.0.1"
  spec.summary      = "Login is module leve xx."

  spec.description  = <<-DESC
  TODO: Add long description of the pod here.
                   DESC

  spec.homepage     = "https://github.com/herlianzhang/Login"

  spec.author             = { "Herlian" => "t-herlian.zhang@traveloka.com" }
  spec.ios.deployment_target = "12.0"

  spec.source       = { :git => "https://github.com/herlianzhang/Login.git", :tag => "#{spec.version}" }

  spec.source_files  = "Login/**/*.{h,m,swift}"
  spec.resources = "Login/**/*.xib"

  spec.platform = :ios

  spec.public_header_files = "Login/**/*.h"


end
