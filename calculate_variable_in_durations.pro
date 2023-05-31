; Caldulate the nearest value
FUNCTION calculate_instant_value, x, y, t
  new_y = INTERPOL(y, x, t)
  
  RETURN, new_y
END

;Calculate the mean value of y when x is between t_s and t_e. y is the
;value, x is the  time
FUNCTION calculate_mean_value_during_time, x, y, t_s, t_e
  index = where(x ge t_s and x le t_e, ct)
  IF ct EQ 0 THEN BEGIN
     t_mid = (t_s + t_e )/2
     y_mean = calculate_instant_value(x,y,t_mid)
     y_std = 0
  ENDIF ELSE BEGIN
     y_mean = TOTAL(y[index], /nan)/ct 
     y_std = STDDEV(y[index], /nan)
  ENDELSE
  
  RETURN, [y_mean,y_std]
END

;Extract data from tplot varialbe and calculate mean value of data.y
;within duration
FUNCTION calculate_variable_during_time, varname, time_duration
  tplot_names,varname, names=names
  if names(0) eq '' then begin
     output = [!VALUES.F_NAN, 0]
  endif else begin
     get_data, varname, data = data
     
     if MIN(time_duration) eq MAX(time_duration) $
     then output = calculate_instant_value(data.x, data.y, MAX(time_duration)) $
     else output = calculate_mean_value_during_time(data.x, data.y, MIN(time_duration), MAX(time_duration))
  endelse
  
  RETURN, output
END

;extract data from tplot variable varname, and calculate 
FUNCTION calculate_variable_in_durations,varname, time_durations
  output = DBLARR(N_ELEMENTS(time_durations)/2, 2)
  
  FOR itime = 0, N_ELEMENTS(time_durations)/2-1 DO $
    output[itime, *] = calculate_variable_during_time(varname, time_durations[*,itime])
  
  RETURN, output
END
