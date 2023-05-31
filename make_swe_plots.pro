PRO make_swe_plots, crossing_list, data,  driver, type,cutting=cutting, ps_plot = ps_plot, filepath = filepath, title = title, xtitle = xtitle, ytitle = ytitle, xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog, crossing_number_max = crossing_number_max

  if ~keyword_set(cutting) then cutting = 0
  drivers = driver +['_1h_', '_2h_', '_3h_']+type
  if ~keyword_set(crossing_number_max) then crossing_number_max = max(crossing_list.event)
  
  index_dawn = where(crossing_list.dawndusk eq 'Dawnside' and crossing_list.event le crossing_number_max)
  index_dusk = where(crossing_list.dawndusk eq 'Duskside' and crossing_list.event le crossing_number_max)
  
  !X.MARGIN = [15,5]
  !Y.MARGIN = [10,10]
  !P.Multi = [0, 3, 2]
  IF KEYWORD_SET(ps_plot) THEN BEGIN 
     filename =  filepath + driver +'_'+type+'_output.ps'
     spawn, 'mkdir -p ' + FILE_DIRNAME(filename)
    
     popen, filename, /land 
  ENDIF
  
  for idawndusk = 0, 1 do begin
     if idawndusk eq 0 then index_dawndusk = index_dawn else index_dawndusk = index_dusk
     for idriver = 0, N_ELEMENTS(drivers)-1 do begin
        
        x = data.xgse[index_dawndusk]
        y = data.mms_alpha_ratio_ps_mean[index_dawndusk] / data.mms_alpha_ratio_sheath_mean[index_dawndusk]
        
        tags = tag_names(data)
        index_driver_tag = where(tags eq strupcase(drivers[idriver]))
        
        index_pos = where(data.(index_driver_tag)[index_dawndusk] ge cutting)
        index_neg = where(data.(index_driver_tag)[index_dawndusk] le cutting)
        
        draw_scatter_plot, x,y, index_pos, index_neg, ps_plot = ps_plot, filename = filename, title = title, xtitle = 'X!LGSE', ytitle = 'Fraction of solar wind entry', xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog $
                           , legends=['>'+STRING(cutting,FORMAT='(f4.2)'),'<'+STRING(cutting,FORMAT='(f4.2)' ) $
                                     ]     
        
     endfor
  endfor
  
  IF KEYWORD_SET(ps_plot) THEN BEGIN
     pclose
     png_filename = STRMID(filename, 0, STRPOS(filename,'.ps')) + '.png'  
     spawn, 'mogrify -format png -alpha opaque -density 150 '+ filename
     spawn, 'mogrify -rotate -90 '+ png_filename
;     spawn, 'rm -f ' + filename      
  ENDIF ELSE stop
  
  !P.Multi = 0
END 



