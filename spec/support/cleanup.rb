at_exit do
  puts "Cleaning up..."
  [
    'log/import_urls',
    'tmp/import_urls'
  ].each do |folder|
    path = File.join(Rails.root, folder)
    FileUtils.rm_r(path) if File.exists?(path)
  end
  puts "Done."
end
