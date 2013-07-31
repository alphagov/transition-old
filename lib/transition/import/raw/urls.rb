module Transition
  module Import
    module Raw
      class Urls
        def self.import_file(filename)
          ActiveRecord::Base.transaction do
            Optic14n::CanonicalizedUrls.from_urls(File.read(filename).each_line, allow_query: :all).tap do |urls|
              puts "#{urls.seen} urls seen, #{urls.size} after canonicalisation"

              failures = {}

              urls.output_set.each do |url|
                failures[url.to_s] = "Path too long: #{url}" if url.path.length > 767

                ::Raw::Url.new(
                    host: url.host,
                    path: url.path,
                    query: url.query,
                    url: url.to_s
                ) do |raw_url|
                  raw_url.query_parts = url.query_hash.map { |k, v| ::Raw::QueryPart.create(key: k, value: v) }
                  ext = /\.(.*)$/.match(url.path)
                  raw_url.extension = ext[1] if ext && ext.length > 1

                  begin
                    failures[url.to_s] = raw_url.errors unless raw_url.save
                  rescue Exception => e
                    failures[url.to_s] = e
                  end
                end
              end

              failures.merge(urls.failures)

              ::Raw::ImportedFile.create(fullpath: File.expand_path(filename), urls_seen: urls.seen).tap do |imported_file|
                urls.failures.merge(failures).each_pair do |url, error|
                  ::Raw::FailedUrl.create(imported_file: imported_file, url: url, failure: error.to_s)
                end
              end
            end
          end
        end

        def self.from_dir!(input_dir)
          Dir.chdir(input_dir)

          Dir['*'].select { |entry| File.file?(entry) }.each do |filename|
            print "#{filename}: "

            if ::Raw::ImportedFile.exists?(fullpath: File.expand_path(filename))
              puts ' ... exists, skipping'
              next
            end

            Urls.import_file(filename)
          end
        end

        def self.wipe!
          [::Raw::QueryPart, ::Raw::Url, ::Raw::FailedUrl, ::Raw::ImportedFile].each do |klass|
            truncate = "TRUNCATE TABLE #{klass.table_name}"
            print "#{truncate} ... "
            ActiveRecord::Base.connection.execute(truncate)
            puts 'done'
          end
        end
      end
    end
  end
end
