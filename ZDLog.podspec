Pod::Spec.new do |s|
  s.name             = 'ZDLog'
  s.version          = '1.0.5'
  s.summary          = '日志管理和异常信息输出'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/izaodao/ZDLog'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lvhaoxuan' => 'lvhaoxuan@izaodao.com' }
  s.source           = { :git => 'https://github.com/izaodao/ZDLog.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'ZDLog/Classes/**/*'
  s.dependency 'CocoaLumberjack'
end
