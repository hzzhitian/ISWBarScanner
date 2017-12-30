 Pod::Spec.new do |s|

   s.name         = "ISWBarScanner"
   s.version      = "0.0.2"
   s.summary      = "扫二维码获取结果"

   s.description  = <<-DESC
        扫二维码获取结果，可支持手动输入
                    DESC

   s.homepage     = "https://github.com/hzzhitian/ISWBarScanner"
   s.license      = "MIT"
   s.author       = { "hzzhitian" => "bodimall@163.com" }
   s.platform     = :ios,'9.0'

   s.source       = { :git => "https://github.com/hzzhitian/ISWBarScanner.git", :tag => "#{s.version}" }
   s.source_files = "ISWBarScanner/src/*.{h,m}"
   s.resource     = 'ISWBarScanner/src/ISWBarScanner.bundle'
   s.framework    = "UIKit"
   s.dependency     'Masonry', '~> 1.0.2'
   s.requires_arc = true
 end
