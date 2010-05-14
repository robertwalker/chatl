module DataFilesHelper
  def data_file_icon_src(mime_type)
    case mime_type
    when 'image/jpeg'
      'jpeg_file.png'
    when 'image/gif'
      'gif_file.png'
    when 'image/png'
      'png_file.png'
    when 'image/tiff'
      'tiff_file.png'
    when 'application/pdf'
      'pdf_file.png'
    else
      'zip_file.png'
    end
  end
end
