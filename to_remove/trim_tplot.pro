pro trim_tplot, varname, t_s, t_e, data_gsex = data_gsex

  get_data, varname, data = data, dlim = dlim, lim = lim

  index = where(data.x gt t_s and data.x le t_e, ct)

  if ct gt 0 then begin
     store_data, varname, data = {x:data.x[index], y:data.y[index,*]}, dlim=dlim,lim=lim
  endif else begin
     
     data_y = INTERPOL(data.y, data.x, data_gsex,/nan)
     index = where(data_gsex gt t_s and data_gsex le t_e, ct)
     store_data, varname, data = {x:data_gsex[index], y:data_y[index,*]}, dlim=dlim,lim=lim
     
     
  endelse
end
