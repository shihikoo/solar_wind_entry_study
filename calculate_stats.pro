pro calculate_stats, varname, t_s, t_e, output, output_mode = output_mode

  get_data, varname, data = data

  index = where(data.x ge t_s and data.x le t_e, ct)

  if ct eq 0  then stop
  
  x = data.x[index]
  y = data.y[index,*]
  
  x_mean = TOTAL(x,/nan)/ct
  y_mean = TOTAL(y,/nan)/ct
  x_std = STDDEV(x,/nan)
  y_std = STDDEV(y,/nan)

  output = [y_mean, y_std]
  
end 
