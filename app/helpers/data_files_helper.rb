module DataFilesHelper
  def data_file_icon_src(mime_type)
    case mime_type
    when 'image/jpeg'
      'images/jpeg_file.png'
    when 'image/gif'
      'images/gif_file.png'
    when 'image/png'
      'images/png_file.png'
    when 'image/tiff'
      'images/tiff_file.png'
    when 'application/pdf'
      'images/pdf_file.png'
    else
      'images/zip_file.png'
    end
  end
end
