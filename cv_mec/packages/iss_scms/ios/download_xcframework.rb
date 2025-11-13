require 'fileutils'
require 'open-uri'

# def download_remote_xcframework(url, dest_dir)
#   FileUtils.mkdir_p(dest_dir)

#   filename = File.join(dest_dir, File.basename(url))
#   framework_dir = filename.sub(/\.zip$/, '')

#   # Skip download if already exists
#   if File.exist?(framework_dir)
#     puts "✅ Using cached xcframework at #{framework_dir}"
#     return framework_dir
#   end

#   puts "⬇️  Downloading xcframework from #{url}"
#   URI.open(url) do |remote_file|
#     File.binwrite(filename, remote_file.read)
#   end

#   puts "📦  Unzipping #{filename}"
#   system("unzip -o -q #{filename} -d #{dest_dir}")
#   FileUtils.rm_f(filename)

#   puts "✅  Framework ready at #{framework_dir}"
#   framework_dir
# end

def download_remote_xcframework(url, dest_dir, custom_name)
  FileUtils.mkdir_p(dest_dir)

  final_path = File.join(dest_dir, "#{custom_name}.xcframework")
  zip_filename = File.join(dest_dir, File.basename(url))

  # Skip if already cached
  if File.exist?(final_path)
    puts "✅ Using cached xcframework at #{final_path}"
    return final_path
  end

  puts "⬇️  Downloading xcframework from #{url}"
  URI.open(url) do |remote_file|
    File.binwrite(zip_filename, remote_file.read)
  end

  # Extract into a temporary folder so we don't mess with other frameworks
  Dir.mktmpdir("xcframework_extract") do |tmp_dir|
    puts "📦  Unzipping #{zip_filename} into temp dir"
    system("unzip -o -q #{zip_filename} -d #{tmp_dir}")
  # Find the extracted .xcframework in the temp folder
    extracted_framework = Dir.glob(File.join(tmp_dir, '*.xcframework')).find do |path|
      File.directory?(path)
    end

    raise "❌ Could not find any .xcframework in downloaded archive" if extracted_framework.nil?

    # Move to destination with the custom name
    FileUtils.mv(extracted_framework, final_path)
  end

  FileUtils.rm_f(zip_filename)
  puts "✅  Framework ready at #{final_path}"
  final_path
end