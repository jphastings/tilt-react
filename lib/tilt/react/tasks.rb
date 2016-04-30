require 'fileutils'

namespace :react do
  desc "Compiles components according to the webpack config."
  task compile: :'setup:webpack' do
    puts "Running webpack…"

    libs = {
      tilt_react_client: File.expand_path('../../../ext/tilt-react.js', __dir__),
      tilt_react_server: File.expand_path('../../../ext/tilt-react-server.js', __dir__),
    }

    libs.each do |file, source|
      FileUtils.cp(source, "components/#{file}.js")
    end

    %x[webpack]

    libs.each do |file, _|
      FileUtils.rm("components/#{file}.js")
    end
  end

  desc "Compiles components according to the webpack config."
  task watch: :'setup:webpack' do
    puts "Watching for changes in components…"
    %x[webpack --watch]
  end

  namespace :setup do
    desc "Installs all required npm packages."
    task npm: :package do
      puts "Ensuring all NPM packages are installed…"
      %x[npm install]
    end

    desc "Copies the default package.json to the current directory."
    task :package do
      default_package = File.expand_path('../../../ext/default.package.json', __dir__)
      local_package   = File.expand_path('./package.json')
      
      if !File.exist?(local_package)
        FileUtils.cp(default_package, local_package)
        puts "Default package.json copied to local directory"
      end
    end

    desc "Copies the default webpack.config.json to the current directory."
    task :webpack do
      default_config = File.expand_path('../../../ext/webpack.config.js', __dir__)
      local_config   = File.expand_path('./webpack.config.js')
      
      if !File.exist?(local_config)
        FileUtils.cp(default_config, local_config)
        puts "Default webpack.config.js copied to local directory"
      end
    end
  end
end
