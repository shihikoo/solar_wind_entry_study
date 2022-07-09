PRO save_o_beam_data, date_s, date_e, output_path, all_tplot_names

  headers =  ['smooth_turbulent', 'Time' $
              , 'GSE_X', 'GSE_Y', 'GSE_Z' $
              , 'GSM_X', 'GSM_Y', 'GSM_Z' $
              , 'MLT', 'ILAT','DIST','L' $
              , 'Dst', 'AE', 'kp' $
              , 'Bx_GSM', 'By_GSM', 'Bz_GSM' $
              , 'H_v', 'H_p', 'H_n' $
              , 'H_vx', 'H_vy','H_vz' $
              , 'H_vpar','H_vperp' $ 
              , 'O_v', 'O_p', 'O_n' $
              , 'O_vx','O_vy','O_vz' $
              , 'O_vpar','O_vperp' $
              , 'Beta', 'P_tot' $
              , 'Region' $
              , 'E_h','E_o' $
              , 'IMF_Bx', 'IMF_By', 'IMF_Bz' $
              , 'SW_v', 'SW_p', 'SW_n', 'SW_t','alfven_mack' $  

              , 'IMF_Bx_para', 'IMF_By_para', 'IMF_Bz_para' $
              , 'SW_v_para', 'SW_p_para', 'SW_n_para', 'SW_t_para','alfven_mack_para' $
              
         ;     , 'Storm_phase', 'Substorm_phase' $
             ]
  
  data_tplot_names_x = all_tplot_names.x_gse_name
  
  data_tplot_names_y = [  all_tplot_names.x_gse_name, all_tplot_names.y_gse_name, all_tplot_names.z_gse_name $
                          , all_tplot_names.x_gsm_name, all_tplot_names.y_gsm_name, all_tplot_names.z_gsm_name $
                          , all_tplot_names.mlt_name, all_tplot_names.ilat_name, all_tplot_names.dist_name, all_tplot_names.l_name $
                          , all_tplot_names.dst_name, all_tplot_names.ae_name, all_tplot_names.kp_name $
                          , all_tplot_names.bx_name, all_tplot_names.by_gsm_name, all_tplot_names.bz_gsm_name $
                          , all_tplot_names.h1_velocity_t_name, all_tplot_names.h1_pressure_name, all_tplot_names.h1_density_name $
                          , all_tplot_names.h1_velocity_x_name, all_tplot_names.h1_velocity_y_name, all_tplot_names.h1_velocity_z_name $
                          , all_tplot_names.h1_velocity_par_name, all_tplot_names.h1_velocity_perp_name $
                          , all_tplot_names.o1_velocity_t_name, all_tplot_names.o1_pressure_name, all_tplot_names.o1_density_name $
                          , all_tplot_names.o1_velocity_x_name, all_tplot_names.o1_velocity_y_name, all_tplot_names.o1_velocity_z_name $
                          , all_tplot_names.o1_velocity_par_name, all_tplot_names.o1_velocity_perp_name $
                          , all_tplot_names.beta_name, all_tplot_names.p_total_name $
                          , all_tplot_names.region_name $
    
                          , all_tplot_names.electric_field_h_name, all_tplot_names.electric_field_o_name $
                          , all_tplot_names.imf_bx_name, all_tplot_names.imf_by_gsm_name, all_tplot_names.imf_bz_gsm_name $
                          , all_tplot_names.sw_v_name, all_tplot_names.sw_p_name, all_tplot_names.sw_n_name $
                          , all_tplot_names.sw_t_name,all_tplot_names.sw_mack_number_name $

                          , all_tplot_names.parallel_imf_bx_name, all_tplot_names.parallel_imf_by_gsm_name, all_tplot_names.parallel_imf_bz_gsm_name $
                          , all_tplot_names.parallel_sw_v_name,   all_tplot_names.parallel_sw_p_name,       all_tplot_names.parallel_sw_n_name $
                          , all_tplot_names.parallel_sw_t_name,   all_tplot_names.parallel_sw_mack_number_name $
;                          , all_tplot_names.storm_phase_tplot_name, all_tplot_names.substorm_phase_tplot_name $
                       ]
  
  data_dd_x = r_data(data_tplot_names_x(0), /X)
  n_avg = N_ELEMENTS(data_dd_x)

  data_dd_y = DBLARR(N_ELEMENTS(data_tplot_names_y), n_avg)
  nterm = N_ELEMENTS(data_tplot_names_y)
  FOR ii = 0, nterm-1 DO data_dd_y(ii,*) = r_data(data_tplot_names_y(ii), /Y)
  
  data_dd = [REFORM(data_dd_x,1,n_avg), data_dd_y $
             , REFORM(flag_para,1,n_avg), REFORM(pap_para,1,n_avg), REFORM(flux_para,1,n_avg),  REFORM(eflux_para,1,n_avg) $
             , REFORM(flag_anti,1,n_avg), REFORM(pap_anti,1,n_avg), REFORM(flux_anti,1,n_avg),  REFORM(eflux_anti,1,n_avg) $
            ]

; save the data
  fln_dump = output_path + 'data/' + 'storm_o_beam_' + date_s + '.csv' 
  WRITE_CSV, fln_dump, data_dd, HEADER = headers

END
