puts "Copying assets..."

images_source = File.join(File.dirname(__FILE__), "assets", "images")
stylesheets_source = File.join(File.dirname(__FILE__), "assets", "stylesheets", "message_block.css")

images_target = File.join(RAILS_ROOT, "public", "images", "message_block")
stylesheets_target = File.join(RAILS_ROOT, "public", "stylesheets", "message_block.css")

unless File.exists?(images_target)
  FileUtils.mkdir(images_target)
  
  Dir["#{images_source}/*.png"].each do |file|
    FileUtils.cp(file, "#{images_target}/#{File.basename(file)}")
    puts "  Copied #{File.basename(file)}"
  end
else
  puts "  Images appear to already be installed, not copying."
end

unless File.exists?(stylesheets_target)
  FileUtils.cp(stylesheets_source, stylesheets_target)
  puts "  Copied #{File.basename(stylesheets_target)}"
else
  puts "  Stylesheet appears to already be installed, not copying"
end
