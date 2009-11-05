class DataFile < ActiveRecord::Base
  validates_presence_of :comment, :name, :content_type

  before_destroy :delete_uploaded_file

  def uploaded_file=(upload)
    self.name = sanitize_file_name(upload.original_filename)
    self.content_type = upload.content_type.chomp
    File.open(absolute_path, "w") { |f| f.write(upload.read) }
  end

  def absolute_path
    File.join(Rails.root, 'public/system/documents', self.name)
  end

  private
  def sanitize_file_name(filename)
    File.basename(filename).gsub(/[^\w\.\_]/, '_')
  end

  def delete_uploaded_file
    File.delete(absolute_path) if File.exist?(absolute_path)
  end
end
