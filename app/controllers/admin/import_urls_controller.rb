require 'transition/import/urls'
class Admin::ImportUrlsController < ApplicationController

  def import
    @organisations = Organisation.order(:title)
    if request.post?
      errors= []
      errors << 'Site needs to be selected' if params[:site_id].blank?

      file = params[:file]
      unless file.present? and file.original_filename =~ /\.csv$/
        errors << 'CSV file needs to be selected'
      end

      if errors.any?
        flash.now[:error] = errors.join(' and ')
      else
        site = Site.find(params[:site_id])
        imported_file_name = save_import_file(file, site)
        logfile = Transition::Import::Urls.from_csv!(site.site, imported_file_name)
        @import_log = File.read(Rails.root.join('log', 'import_urls', logfile))
      end
    end
  end

  protected

  def save_import_file(file, site)
    timestamp = Time.now.strftime('%Y%m%d-%H:%M:%S')
    FileUtils.mkdir_p(Rails.root.join('tmp/import_urls'))
    write_path = Rails.root.join("tmp/import_urls/#{site.site.gsub(' ', '_')}-#{timestamp}.csv")
    File.open(write_path, 'w') { |f| f.write(file.read.force_encoding("UTF-8")) }
    write_path
  end
end
