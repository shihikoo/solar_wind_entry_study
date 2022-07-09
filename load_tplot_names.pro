FUNCTION load_tplot_names, sc, bmodel, energy_range = energy_range

  sc_str = STRING(sc, FORMAT = '(i1.1)')
  coord = 'GSM'
  
  all_tplot_names = { $
                    ephemeris_names: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_*', $
                    gse_name:'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSE', $
                    x_gse_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSE_X', $
                    y_gse_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSE_Y', $
                    z_gse_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSE_Z', $
                    gsm_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSM', $
                    x_gsm_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSM_X', $
                    y_gsm_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSM_Y', $
                    z_gsm_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_GSM_Z', $
                    mlt_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_MLT', $
                    ilat_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_MLAT', $
                    l_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_L_D', $
                    dist_name: 'MMS'+sc_str+'_EPHEM_'+bmodel+'_DIST',$
                    mag_names: 'MMS' + sc_str + '_FGM_SRVY_MAG_'+coord+'*', $
                    mag_name:  'MMS' + sc_str + '_FGM_SRVY_MAG_'+coord, $
                    mag_pressure_name:  'MMS' + sc_str + '_FGM_SRVY_MAG_'+coord+'_MAG_PR', $
                    bx_name: 'MMS'+sc_str+'_FGM_SRVY_MAG_GSM_X', $
                    by_gsm_name: 'MMS'+sc_str+'_FGM_SRVY_MAG_GSM_Y', $
                    bz_gsm_name: 'MMS'+sc_str+'_FGM_SRVY_MAG_GSM_Z', $
                    bt_name: 'MMS'+sc_str+'_FGM_SRVY_MAG_GSM_T', $
                    moments_names: 'MMS'+sc_str+'_HPCA_SRVY_L2_*', $
                    h1_pressure_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_h1_pressure' , $  
                    he2_pressure_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_he2_pressure'  , $   
                    h1_density_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_h1_density' , $   
                    he2_density_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_he2_density' , $   
                    h1_velocity_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_GSM' , $   
                    he2_velocity_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_GSM' , $  
                    h1_velocity_t_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_GSM_T' , $  
                    he2_velocity_t_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_GSM_T' , $  
                    h1_velocity_x_name: 'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_GSM_X' , $  
                    he2_velocity_x_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_GSM_X' , $ 
                    h1_velocity_y_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_GSM_Y' , $ 
                    he2_velocity_y_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_GSM_Y' , $ 
                    h1_velocity_z_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_GSM_Z' , $ 
                    he2_velocity_z_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_GSM_Z' , $ 
                    h1_velocity_par_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_par_GSM_T' , $   
                    he2_velocity_par_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_par_GSM_T' , $   
                    h1_velocity_perp_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_h1_velocity_perp_GSM_T' , $   
                    he2_velocity_perp_name:  'MMS'+sc_str+'_HPCA_SRVY_L2_he2_velocity_perp_GSM_T' , $   
                    beta_name: 'Plasma_Beta_SC'+sc_str ,$
                    p_total_name: 'Pressure_total_SC'+sc_str, $
                    density_ratio_name: 'Density_ratio_oplus_hplus_SC'+sc_str, $
                    diffflux_h1_name: 'mms'+sc_str+'_hpca_hplus_eflux_pa_red_000_180_nflux' , $
                    diffflux_he2_name: 'mms'+sc_str+'_hpca_heplusplus_eflux_pa_red_000_180_nflux' , $
                    diffflux_o1_name: 'mms'+sc_str+'_hpca_oplus_eflux_pa_red_000_180_nflux' , $
                    omni_tplot_names: 'OMNI_HR*', $
                    imf_bx_name: 'OMNI_HR_Bx_gse', $
                    imf_by_gse_name: 'OMNI_HR_By_gse', $
                    imf_bz_gse_name: 'OMNI_HR_Bz_gse', $
                    imf_by_gsm_name: 'OMNI_HR_By_gsm', $
                    imf_bz_gsm_name: 'OMNI_HR_Bz_gsm', $
                    sw_v_name: 'OMNI_HR_flow_speed', $
                    sw_p_name: 'OMNI_HR_flow_pressure', $
                    sw_n_name: 'OMNI_HR_proton_density', $
                    sw_t_name: 'OMNI_HR_temperature', $
                    sw_mack_number_name: 'OMNI_HR_alfven_mack_number', $
                    dst_name: 'OMNI_HR_SYM_H' , $
                    ae_name: 'OMNI_HR_AE_Index' , $
                    kp_name: 'Kp_Index' $
                    , ace_alpha_ratio: 'ACE_SWEPAM_CDF_alpha_ratio' $
                    , wind_alpha_proton_ratio: 'WIND_SWE_Alpha_Proton_ratio' $
                    , mms_alpha_ratio: 'mms_alpha_ratio' $
                    }
  
  RETURN, all_tplot_names
END
