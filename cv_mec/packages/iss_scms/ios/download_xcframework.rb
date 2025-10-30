require 'fileutils'
require 'open-uri'

def download_remote_xcframework(url, dest_dir)
  FileUtils.mkdir_p(dest_dir)

  filename = File.join(dest_dir, File.basename(url))
  framework_dir = filename.sub(/\.zip$/, '')

  # Skip download if already exists
  if File.exist?(framework_dir)
    puts "✅ Using cached xcframework at #{framework_dir}"
    return framework_dir
  end

  puts "⬇️  Downloading xcframework from #{url}"
  URI.open(url) do |remote_file|
    File.binwrite(filename, remote_file.read)
  end

  puts "📦  Unzipping #{filename}"
  system("unzip -o -q #{filename} -d #{dest_dir}")
  FileUtils.rm_f(filename)

  puts "✅  Framework ready at #{framework_dir}"
  framework_dir
end