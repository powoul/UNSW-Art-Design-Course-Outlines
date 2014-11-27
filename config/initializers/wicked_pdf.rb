if Rails.env.production?
  WickedPdf.config = { :exe_path => '/usr/bin/wkhtmltopdf'}
 else
  #WickedPdf.config = {:exe_path => Rails.root.join('bin', 'wkhtmltopdf').to_s}
end