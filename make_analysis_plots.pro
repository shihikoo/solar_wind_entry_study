pro make_analysis_plots, ps_plot = ps_plot,crossing_number_max = crossing_number_max

  output_path = 'output/'

; read in crossing list   
  crossing_list = read_csv_data('data/sheath_ps_crossing_mms.csv',  header = header_crossing)

  data = read_csv_data(output_path + 'data/solar_wind_entry_study_output.csv', header = header_data)
  
; make the plots
  xrange = [-20, 10]
  yrange = [0,1.3]
  
  driver = 'imf_bz_gsm'
  type = 'mean'
  cutting = 0 
  make_swe_plots, crossing_list, data,  driver, type, cutting = cutting, ps_plot = ps_plot, filepath = output_path+'analysis_plots/', xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog, crossing_number_max = crossing_number_max

  driver = 'imf_bz_gsm'
  type = 'std'
  cutting = 1
  make_swe_plots, crossing_list, data,  driver, type, cutting = cutting, ps_plot = ps_plot, filepath = output_path+'analysis_plots/', xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog, crossing_number_max = crossing_number_max

  driver = 'imf_by_gsm'
  type = 'mean'
  cutting = 0
  make_swe_plots, crossing_list, data,  driver, type, cutting = cutting, ps_plot = ps_plot, filepath = output_path+'analysis_plots/', xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog, crossing_number_max = crossing_number_max

  driver = 'imf_by_gsm'
  type = 'std'
  cutting = 1
  make_swe_plots, crossing_list, data,  driver, type, cutting = cutting, ps_plot = ps_plot, filepath = output_path+'analysis_plots/', xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog, crossing_number_max = crossing_number_max

  
  stop
  
end
