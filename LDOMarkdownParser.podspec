Pod::Spec.new do |s|
  s.name             = 'LDOMarkdownParser'
  s.version          = '0.1.0'
  s.summary          = 'Parse (some) markdown attributes into an NSAttributedString.'

  s.description      = <<-DESC
Currently only supports bold, italic and links.
                       DESC

  s.homepage         = 'https://github.com/lurado/LDOMarkdownParser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Julian Raschke und Sebastian Ludwig GbR' => 'info@lurado.com' }
  s.source           = { :git => 'https://github.com/lurado/LDOMarkdownParser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'LDOMarkdownParser/Classes/**/*'
end
