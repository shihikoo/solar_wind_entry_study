;Calculate the mean value of y when x is between t_s and t_e. y is the
;value, x is the  time
FUNCTION calculate_mean_value_during_time, x, y, t_s, t_e
  index = where(x ge t_s and x le t_e, ct)
  IF ct EQ 0 THEN stop
  y_mean = TOTAL(y[index], /nan)/ct 
  y_std = STDDEV(y[index], /nan)
  
  RETURN, [y_mean,y_std]
END

;extract data from tplot variable varname, and calculate 
FUNCTION calculate_delayed_solarwind_parameter,varname, time_durations
  print, varname
  get_data, varname, data = data

  delayed_solarwind_parameter = DBLARR(N_ELEMENTS(time_durations)/2, 2)
  
  FOR itime = 0, N_ELEMENTS(time_durations)/2-1 DO delayed_solarwind_parameter[itime, *] = calculate_mean_value_during_time(data.x, data.y, MIN(time_durations[*,itime]), MAX(time_durations[*, itime]))
  
  RETURN,   delayed_solarwind_parameter
END

PRO  calculate_solarwind_delayed, varnames, time, delayed_solarwind_parameter, time_durations =  time_durations
  
  IF ~KEYWORD_SET(time_durations) THEN time_durations =  [[time - 1. * 3600. , time],[ time - 2. * 3600. , time - 1. * 3600.],[time - 3. * 3600. , time - 2. * 3600.]]

  n_variables = N_ELEMENTS(varnames)
  n_time_durations = N_ELEMENTS(time_durations)/2
  delayed_solarwind_parameter = DBLARR(n_variables, n_time_durations,2)
  
  FOR ii = 0, n_variables-1 DO BEGIN
     print,ii
     varname = varnames[ii]
     delayed_solarwind_parameter[ii,*,*] = calculate_delayed_solarwind_parameter(varname, time_durations)
  ENDFOR


  
END
