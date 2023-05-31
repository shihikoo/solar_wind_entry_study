pro create_database_swe, sc = sc, store_tplot = store_tplot, output_path = output_path, recalc = recalc, save_data = save_data,ps_plot=ps_plot,idl_plot= idl_plot

;--------------------------------------------------------------------
; handling keywords
;--------------------------------------------------------------------
  sc = 2 
  sc_str = STRING(sc, FORMAT = '(i1.1)')

  output_path = 'output/'
 
  sp = 1
  
  solar_wind_delay_time_durations =  [[-1.*3600. , 0],[ -2.*3600. , -1.*3600.],[ -3.*3600., -2.*3600.]]
;--------------------------------------------------------------------
; Settings 
;-------------------------------------------------------------------- 
  bmodel = 't89d'; 'ts04d' 
  bin_size_pa = 11.25           ; for mms it's 11.25, for codif it's 22.5
  error_message = ''
  
  full_mms_energy_range = [1e1, 5e4]
  
; read in crossing list  
  crossing_list = READ_CSV('data/sheath_ps_crossing_mms.csv', header = header)
  n_crossing = N_ELEMENTS(crossing_list.FIELD01)
  
  crossing_number = crossing_list.FIELD01[0:n_crossing-1]
  smooth_turbulent = crossing_list.FIELD06[0:n_crossing-1]
  bl = crossing_list.FIELD07[0:n_crossing-1]
  dawndusk = crossing_list.FIELD08[0:n_crossing-1]
  inbound = crossing_list.FIELD09[0:n_crossing-1]
  crossing_pause = crossing_list.FIELD10[0:n_crossing-1]
  crossing_ps = crossing_list.FIELD11[0:n_crossing-1]

  time_start_sheath = (time_double(crossing_pause) + 10 * 60.)*(inbound eq 0) + (time_double(crossing_pause) - 30 * 60.)*(inbound eq 1)
  time_start_plasmasheet = (time_double(crossing_ps) + 10 * 60.)*(inbound eq 1) + (time_double(crossing_ps) - 30 * 60.)*(inbound eq 0)
  time_end_sheath = time_start_sheath + 20. * 60.
  time_end_plasmasheet = time_start_plasmasheet + 20.* 60.
  
  ;; time_start_sheath_1 = crossing_list.FIELD02[0:n_crossing-1]
  ;; time_end_sheath_1 = crossing_list.FIELD03[0:n_crossing-1]
  ;; time_start_plasmasheet_1 = crossing_list.FIELD04[0:n_crossing-1]
  ;; time_end_plasmasheet_1 = crossing_list.FIELD05[0:n_crossing-1]
 
;------------------------------------------------------------------------------------
;Load all the tplot_names for the routine
;------------------------------------------------------------------------------------
  all_tplot_names = load_tplot_names(sc, bmodel)

;------------------------------------------------------------------------------------
; Variables calculation settings
;------------------------------------------------------------------------------------
; locations 
  varnames_locations = [all_tplot_names.x_gse_name, all_tplot_names.y_gse_name, all_tplot_names.z_gse_name, $
                        all_tplot_names.y_gsm_name, all_tplot_names.z_gsm_name, $
                        all_tplot_names.dist_name, all_tplot_names.mlt_name, all_tplot_names.l_name]
  title_locations = ['xgse','ygse','zgse','ygsm','zgsm','dist','mlt','l']
  output_location = DBLARR(n_crossing, N_ELEMENTS(varnames_locations))
  
; moments
  varnames_moments = [all_tplot_names.bx_name, all_tplot_names.by_gsm_name, all_tplot_names.bz_gsm_name, all_tplot_names.b_theta_name, $
                      all_tplot_names.h1_density_name, all_tplot_names.he2_density_name,all_tplot_names.mms_alpha_ratio]
  title_moments = ['bx','by_gsm','bz_gsm', 'b_theta', $
                  'h1_density','he2_density','mms_alpha_ratio']
  output_type_moments = ['sheath_mean','sheath_std','ps_mean','ps_std']
  n_outputs_moments = N_ELEMENTS(output_type_moments)
  titles_moments = []
  for ii = 0 , N_ELEMENTS(varnames_moments)-1 do titles_moments = [titles_moments, title_moments[ii]+'_'+output_type_moments]
  output_moments = DBLARR(n_crossing,  N_ELEMENTS(varnames_moments)*4)
  
; solar wind
  varnames_imf = [all_tplot_names.imf_bx_name, all_tplot_names.imf_by_gse_name, all_tplot_names.imf_bz_gse_name, $
              all_tplot_names.imf_by_gsm_name, all_tplot_names.imf_bz_gsm_name, $
              all_tplot_names.sw_p_name, all_tplot_names.sw_v_name,all_tplot_names.dst_name]
  title_imf = ['imf_bx','imf_by_gse','imf_bz_gse','imf_by_gsm','imf_bz_gsm','sw_p','sw_v','dst']
  output_type_imf = ['1h_mean','1h_std','2h_mean','2h_std','3h_mean','3h_std']
  n_outputs_imf = N_ELEMENTS(output_type_imf)
  titles_imf = []
  for ii = 0 , N_ELEMENTS(varnames_imf)-1 do    titles_imf = [titles_imf,title_imf[ii]+'_'+output_type_imf]
  output_imf = DBLARR(n_crossing,  N_ELEMENTS(varnames_imf)*n_outputs_imf) 
  
;---------------------------------------------------------------------  
; loop through all crossings (start from 1)
;---------------------------------------------------------------------
  
  for index = 0, N_ELEMENTS(crossing_number)-1 do begin
;------------------------------------
; load times for the crossing
;------------------------------------
     icrossing_number = crossing_number[index]
     
 ;    index = where(crossing_number eq icrossing_number, ct)
 ;    index = index[0]
 ;    if ct eq 0 then CONTINUE

     t_crossing_pause = time_double(crossing_pause[index])
     t_crossing_ps = time_double(crossing_ps[index])
     t_s_sheath = time_double(time_start_sheath[index])
     t_e_sheath = time_double(time_end_sheath[index])
     t_s_plasmasheet = time_double(time_start_plasmasheet[index])
     t_e_plasmasheet = time_double(time_end_plasmasheet[index])
     
     t_s = (t_s_sheath < t_s_plasmasheet) - 6. * 3600.
     t_dt = 12. * 3600.
     t_e = t_s + t_dt
     
     ts = time_string(t_s)
     te = time_string(t_e)

     data_filename = output_path + 'data/output.csv'
     tplot_filename = output_path + 'tplot/' +  STRCOMPRESS(icrossing_number, /REMOVE_ALL)
     IF NOT KEYWORD_SET(log_filename) THEN log_filename = output_path + 'log.txt'
     timespan, t_s, t_dt,/seconds
     
;--------------------------------------------------------------------------
; Delete all the string stored data in order to make sure the program can run correctly
;----------------------------------------------------------------------------
     tplot_names, names = names
     store_data, DELETE = names
     
;------------------------------------------------------------------------
;If recalc is not set, then read the tplot varialbes
;-----------------------------------------------------------------------
     IF NOT KEYWORD_SET(recalc) THEN BEGIN
        PRINT, FINDFILE(tplot_filename+'.tplot.gz', COUNT = ct_tplot_gz)
        IF ct_tplot_gz THEN spawn,'gzip -df ' + tplot_filename + '.tplot.gz'
        PRINT, FINDFILE(tplot_filename+'.tplot', COUNT = ct_tplot)
        IF ct_tplot GT 0 THEN BEGIN     
           tplot_restore, filenames = tplot_filename + '.tplot' 
;           spawn,'gzip -9f '+tplot_filename+'.tplot'
        ENDIF
     ENDIF
     ;stop
;-------------------------------------------------------------------
; Load tplot variables     
;-------------------------------------------------------------------
     load_tplots_swe, all_tplot_names, sc,sp, bmodel, log_filename = log_filename, data_filename = data_filename, store_tplot = store_tplot   
; adjust m
     varnames_moments = [all_tplot_names.bx_name, all_tplot_names.by_gsm_name, all_tplot_names.bz_gsm_name, all_tplot_names.b_theta_name, $
                         all_tplot_names.h1_density_name, all_tplot_names.he2_density_name,all_tplot_names.mms_alpha_ratio]

;---------------------------------------------------------------------
; Save tplot varialbes 
;---------------------------------------------------------------------
     IF KEYWORD_SET(store_tplot)  THEN  BEGIN       
; trim the tplot varialbes        
        time_trim_tplot_variable, '*', t_s, t_e
; save the data
        tplot_save, filename = tplot_filename
; zip the tplot file
;        spawn,'gzip -9f ' + tplot_filename + '.tplot'
     ENDIF     

;--------------------------------------------------------------
; Overview plots
;--------------------------------------------------------------
     if keyword_set(ps_plot) or keyword_set(idl_plot) then make_tplots, sc_str, output_path, all_tplot_names, bars = [[t_s_sheath,t_e_sheath],[t_crossing_pause, t_crossing_ps],[t_s_plasmasheet,t_e_plasmasheet]],  ps = ps_plot
    
;--------------------------------------------------------------
; Extract locations
;--------------------------------------------------------------
     time_durations = [t_crossing_pause, t_crossing_pause]
    
     for ivar = 0, N_ELEMENTS(varnames_locations)-1 do begin
        output =  calculate_variable_in_durations(varnames_locations(ivar), time_durations)
        output_location[index, ivar] = output[0]
     endfor 
;--------------------------------------------------------------
; Calculate moments before and after crossing
;--------------------------------------------------------------     
     time_durations = [[t_s_sheath, t_e_sheath], [t_s_plasmasheet, t_e_plasmasheet]]
           
     for ivar = 0, N_ELEMENTS(varnames_moments)-1 do begin
        output = calculate_variable_in_durations(varnames_moments(ivar),time_durations )
        output_moments[index, INDGEN(n_outputs_moments)+ivar*n_outputs_moments] = REFORM(TRANSPOSE(output),1,n_outputs_moments)
     endfor
     
;----------------------------------------
; Calculate solar wind delayed   
;----------------------------------------
     time_durations = t_crossing_pause + solar_wind_delay_time_durations
     
     for ivar = 0, N_ELEMENTS(varnames_imf)-1 do begin
        output = calculate_variable_in_durations(varnames_imf(ivar),time_durations )
        output_imf[index, INDGEN(n_outputs_imf)+ivar*n_outputs_imf] = REFORM(TRANSPOSE(output),1,n_outputs_imf)
     endfor
     
  endfor
  
;--------------------------------------
; Save the data
;--------------------------------------
  
  IF keyword_set(save_data) THEN  BEGIN
     headers = [title_locations, titles_moments, titles_imf, 'crossing_number' $
     ;,'smooth_turbulent','bl','dawndusk','inbound','crossing_pause','crossing_ps','ts_sheath','te_sheath','ts_ps','te_ps'
        ]

   ;  index_crossing = sort(crossing_number)
     output_data = TRANSPOSE([[output_location], [output_moments], [output_imf] ,[crossing_number] $
                                ; ,[smooth_turbulent],[bl],[dawndusk],[inbound],[crossing_pause],[crossing_ps],[time_start_sheath],[time_end_sheath],[time_start_plasmasheet],[time_end_plasmasheet] $ 
                             ])
     
     fln_dump = output_path + 'data/' + 'solar_wind_entry_study_output.csv' 
     WRITE_CSV, fln_dump, output_data, HEADER = headers
     
 ;    save_o_beam_data, data_filename, all_tplot_names
  ENDIF 

  close, /all
end
