;--------------------------------------------------------------------------
; Purpose: make tplots in idl and/or ps for streaming O+
; Inputs: sc_str, t_s, t_e, t_dt, output_path, all_tplot_names
; Keywords: displaytime, ps, idl_plot
; Written by Jing Liao1
; Written on 04/15/2021
;-------------------------------------------------------------------------

PRO make_tplots, sc_str, output_path, all_tplot_names, bars = bars, ps = ps
  
  options, '*', 'panel_size', 2
  tplot_options, 'num_lab_min', 6
  options, '*', 'ysubtitle', ''
  options, '*', 'thick', 2

  get_timespan, tt
  d1 = time_string(tt(0))
  sdate_str = strmid(d1, 0, 4) + strmid(d1, 5, 2) + strmid(d1, 8, 2)
  stime_str = strmid(d1, 11, 2) + strmid(d1, 14, 2) + strmid(d1, 17, 2)
  
  zlim, [all_tplot_names.diffflux_h1_name], 1e1, 1e5, 1
  zlim, [all_tplot_names.diffflux_he2_name], 1e1*0.04, 1e5*0.04, 1

  options, all_tplot_names.diffflux_h1_name, 'ytitle', 'mms!C!Chpca!C!CH!U+!N E (eV)'
  options, all_tplot_names.diffflux_o1_name, 'ytitle', 'mms!C!Chpca!C!CO!U+!N E (eV)'
  options, all_tplot_names.imf_bz_gse_name, 'ytitle', 'IMF!C!CB!LZ!N GSE'
  options, all_tplot_names.imf_by_gse_name, 'ytitle', 'IMF!C!CB!LY!N GSE'
  options, all_tplot_names.sw_p_name, 'ytitle', 'SW!C!CPress'
  options, all_tplot_names.sw_n_name, 'ytitle', 'SW!C!CDens'
  options, all_tplot_names.sw_v_name, 'ytitle', 'SW!C!CVel'

  options, [all_tplot_names.diffflux_o1_name], 'ztitle', ''

  ylim, all_tplot_names.h1_density_name, 0.1, 50, 1
  ylim, all_tplot_names.mms_alpha_ratio, 1e-3, 1e0, 1
  ylim, all_tplot_names.imf_bz_gse_name, -25, 15, 0
  ylim, all_tplot_names.imf_by_gse_name, -20, 30, 0
  ylim, all_tplot_names.sw_p_name, 0, 15, 0
  ylim, all_tplot_names.sw_n_name, 0, 40, 0
  ylim, all_tplot_names.sw_v_name, 0, 600, 0
  options, all_tplot_names.mms_alpha_ratio, 'panel_size', 4
  options, all_tplot_names.he2_density_name, 'color', 2
  options, all_tplot_names.ace_alpha_ratio, 'color', 2
  options, all_tplot_names.wind_alpha_proton_ratio, 'color', 6
  options, all_tplot_names.mms_alpha_ratio, 'ytitle', 'He++/H+!CMMS (black)!CACE (blue)!CWIND (red)'
  options, [all_tplot_names.ace_alpha_ratio,all_tplot_names.wind_alpha_proton_ratio], 'thick', 1


  IF KEYWORD_SET(ps) THEN BEGIN  
     ps_folder = output_path + 'plots/'
     spawn, 'mkdir -p ' + ps_folder
     fln = ps_folder + 'srv_' + sdate_str + '_' + stime_str + '_mms' + sc_str + '_alphas'+'.ps'
     
     popen, fln, /port
  ENDIF
  
  tplot, [all_tplot_names.imf_bz_gse_name $
          , all_tplot_names.imf_by_gse_name $
          , all_tplot_names.sw_p_name $
          ,all_tplot_names.sw_v_name $
          ,all_tplot_names.diffflux_h1_name $
          ,all_tplot_names.diffflux_he2_name $
          ,all_tplot_names.diffflux_o1_name $
          ,all_tplot_names.mag_name $
          ,all_tplot_names.h1_density_name $
          ,all_tplot_names.mms_alpha_ratio], $
         var_label=[all_tplot_names.dist_name, all_tplot_names.x_gse_name ,all_tplot_names.y_gse_name, all_tplot_names.z_gse_name]
  
  yline, [all_tplot_names.imf_bz_gse_name,all_tplot_names.imf_by_gse_name,all_tplot_names.sw_p_name,all_tplot_names.sw_n_name,all_tplot_names.sw_v_name]
  
  tplot_panel, v=all_tplot_names.h1_density_name, o=all_tplot_names.he2_density_name
  tplot_panel, v=all_tplot_names.mms_alpha_ratio, o=all_tplot_names.ace_alpha_ratio, psym=3
  tplot_panel, v=all_tplot_names.mms_alpha_ratio, o=all_tplot_names.wind_alpha_proton_ratio, psym=3
  yline, all_tplot_names.mms_alpha_ratio, offset=0.04
  
  for ibar = 0, N_ELEMENTS(bars) -1 do timebar, bars[ibar], color= FLOOR(ibar/2)+1
  
  IF KEYWORD_SET(ps) THEN BEGIN  
     pclose
     spawn, 'mogrify -format png -alpha opaque -density 150 '+ fln
;     spawn, 'rm -f '+ fln
  ENDIF ELSE stop
  
END
