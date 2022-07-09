pro create_database_swe, sc = sc, store_tplot = store_tplot, output_path = output_path, recalc = recalc, save_data = save_data,ps=ps

;--------------------------------------------------------------------
; handling keywords
;--------------------------------------------------------------------
  sc = 2
  store_tplot = 1
  output_path = 'output/'
  save_data = 1
  sc_str = STRING(sc, FORMAT = '(i1.1)')
  sp = 1
;--------------------------------------------------------------------
; Settings 
;-------------------------------------------------------------------- 
  bmodel = 'ts04d' 
  bin_size_pa = 11.25           ; for mms it's 11.25, for codif it's 22.5
  error_message = ''
  
  full_mms_energy_range = [1e1, 5e4]
  
; read in crossing list  
  crossing_list = READ_CSV('data/sheath_ps_crossing_mms.csv', header = header)
  n_time = N_ELEMENTS(crossing_list.FIELD01)
  
  crossing_number = crossing_list.FIELD01[0:n_time-1]
  time_start_sheath = crossing_list.FIELD02[0:n_time-1]
  time_end_sheath = crossing_list.FIELD03[0:n_time-1]
  time_start_plasmasheet = crossing_list.FIELD04[0:n_time-1]
  time_end_plasmasheet = crossing_list.FIELD05[0:n_time-1]
  smooth_turbulent = crossing_list.FIELD06[0:n_time-1]
  bl = crossing_list.FIELD07[0:n_time-1]
  dawndusk = crossing_list.FIELD08[0:n_time-1]
  inbound = crossing_list.FIELD09[0:n_time-1]
  crossing_pause = crossing_list.FIELD10[0:n_time-1]
  crossing_ps = crossing_list.FIELD11[0:n_time-1]
  
; loop through all crossings
  for icrossing_number = 1, MAX(crossing_number) do begin
;------------------------------------
; load times for the crossing
;------------------------------------
     index = where(crossing_number eq icrossing_number, ct)
     index = index[0]
     if ct eq 0 then stop

     t_crossing_pause = time_double(crossing_pause[index])
     t_s_sheath = time_double(time_start_sheath[index])
     t_e_sheath = time_double(time_end_sheath[index])
     t_s_plasmasheet = time_double(time_start_plasmasheet[index])
     t_e_plasmasheet = time_double(time_end_plasmasheet[index])
     
     t_s = (t_s_sheath < t_s_plasmasheet) - 3. * 3600.
;   t_e = t_e_sheath > t_e_plasmasheet
;   t_s = time_double(EXTRACT_DATE_STRING(time_string(t_s_sheath)))
     t_dt = 6. * 3600.
     t_e = t_s + t_dt
     
     ts = time_string(t_s)
     te = time_string(t_e)
;     t_dt = t_e - t_s
     
     data_filename = output_path + 'data/output.csv'
     tplot_filename = output_path + 'tplot/' + STRING(icrossing_number, format='(i1.1)')
     IF NOT KEYWORD_SET(log_filename) THEN log_filename = output_path + 'log.txt'
     timespan, t_s, t_dt,/seconds
     
;--------------------------------------------------------------------------
; Delete all the string stored data in order to make sure the program can run correctly
;----------------------------------------------------------------------------
     tplot_names, names = names
     store_data, DELETE = names
     
;------------------------------------------------------------------------------------
;Load all the tplot_names for the routine
;------------------------------------------------------------------------------------
     all_tplot_names = load_tplot_names(sc, bmodel)
;------------------------------------------------------------------------
;If recalc is not set, then read the tplot varialbes
;-----------------------------------------------------------------------
     IF NOT KEYWORD_SET(recalc) THEN BEGIN
        PRINT, FINDFILE(tplot_filename+'.tplot.gz', COUNT = ct_tplot_gz)
        IF ct_tplot_gz THEN spawn,'gzip -df ' + tplot_filename + '.tplot.gz'
        PRINT, FINDFILE(tplot_filename+'.tplot', COUNT = ct_tplot)
        IF ct_tplot GT 0 THEN BEGIN     
           tplot_restore, filenames = tplot_filename + '.tplot' 
           spawn,'gzip -9f '+data_filename+'.tplot'
        ENDIF
     ENDIF
   
;----------------------------------------
; Load tplot variables     
;----------------------------------------
     load_tplots_swe, all_tplot_names, sc,sp, bmodel, log_filename = log_filename, data_filename = data_filename, store_tplot = store_tplot

;---------------------------------------------------------------------
; Save tplot varialbes 
;---------------------------------------------------------------------
     IF KEYWORD_SET(store_tplot)  THEN  BEGIN
        
; Calculate MMS density ratio
        get_data, all_tplot_names.h1_density_name, data=h1dens
        get_data, all_tplot_names.he2_density_name, data=he2dens
        
        he2dens_new = INTERPOL(he2dens.y, he2dens.x, h1dens.x)
; why 0.025 ?
        store_data, all_tplot_names.mms_alpha_ratio, data={x:h1dens.x, y:he2dens_new*0.025 / h1dens.y}
        
; trim the tplot varialbes        
        time_trim_tplot_variable, '*', t_s, t_e
; save the data
        tplot_save, filename = tplot_filename
; zip the tplot file
        spawn,'gzip -9f ' + tplot_filename + '.tplot'
     ENDIF     

;--------------------------------------------------------------
; Overview plots
;--------------------------------------------------------------
     make_o_beam_tplots, sc_str, output_path, all_tplot_names, bars = [[t_s_sheath,t_e_sheath],[t_s_plasmasheet,t_e_plasmasheet]],  ps = ps

;--------------------------------------------------------------
; Calculate variables
;--------------------------------------------------------------
     varnames = [all_tplot_names.x_gse_name, all_tplot_names.y_gse_name, $
                 all_tplot_names.z_gse_name,all_tplot_names.x_gsm_name, $
                 all_tplot_names.y_gsm_name, all_tplot_names.y_gsm_name, $
                 all_tplot_names.z_gsm_name, all_tplot_names.dist_name, $
                 all_tplot_names.mlt_name, all_tplot_names.l_name, $
                 all_tplot_names.bx_name, all_tplot_names.by_gsm_name, $
                 all_tplot_names.bz_gsm_name,  all_tplot_names.imf_bx_name, $
                 all_tplot_names.imf_by_gse_name, all_tplot_names.imf_bz_gse_name,$
                 all_tplot_names.imf_by_gsm_name, all_tplot_names.imf_bz_gsm_name, $
                 all_tplot_names.sw_v_name, all_tplot_names.sw_p_name, all_tplot_names.dst_name $
                 ,  all_tplot_names.h1_density_name, all_tplot_names.he2_density_name,all_tplot_names.mms_alpha_ratio]
     
     output = DBLARR(n_time,  N_ELEMENTS(varnames),5)
     
     for ivar = 0, N_ELEMENTS(varnames)-1 do begin        
        calculate_stats, varnames(ivar), t_s_sheath, t_e_sheath, output_sheath
        calculate_stats, varnames(ivar), t_s_plasmasheet, t_e_plasmasheet, output_plasmasheet

        output[index, ivar, *] = [icrossing_number, output_sheath[0], output_sheath[1], output_plasmasheet[0], output_plasmasheet[1]], 
 
     endfor
     
;----------------------------------------
; Calculate solar wind delay     
;----------------------------------------
     names = [all_tplot_names.imf_bx_name, all_tplot_names.imf_by_gse_name, all_tplot_names.imf_bz_gse_name, all_tplot_names.imf_by_gsm_name, all_tplot_names.imf_bz_gsm_name, all_tplot_names.sw_p_name, all_tplot_names.sw_v_name,all_tplot_names.dst_name ]
     calculate_solarwind_delayed, names, t_crossing_pause, delayed_solarwind_parameter
     stop
  endfor
;--------------------------------------
; Save the data
;--------------------------------------    
  IF keyword_set(save_data) THEN  BEGIN
     save_o_beam_data, data_filename, all_tplot_names
  ENDIF 

  close, /all
end
