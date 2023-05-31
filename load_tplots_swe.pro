;------------------------------------------------------------------------------
; Purpose: Load data for solar wind entry project
;       
; Keywords: sc             : Cluster no. if not set the default is 1
;           sp             :
;           all_tplot_names:
;           bmodel         :
;           log_filename   :
;           store_tplot    :
;
; Output:
;
; Written by Jing Liao  07/03/2022
;-------------------------------------------------------------------------------

pro load_tplots_swe, all_tplot_names, sc, sp,bmodel, log_filename = log_filename, data_filename = data_filename, store_tplot = store_tplot

;-- Load Magnetic field--
  tplot_names, all_tplot_names.mag_names, names = names
  IF names(0) eq '' THEN plot_mms_fgm_mag, [sc], 'GSM'
                                ; if magnetic field is not load for the sc then load with sc = 1
  tplot_names, all_tplot_names.mag_names, names = names
  IF names(0) eq '' THEN BEGIN
     sc_mag = 1
     plot_mms_fgm_mag,[sc_mag],'GSM'
     all_tplot_names = load_tplot_names(sc, bmodel, sc_mag = sc_mag)
  ENDIF
                                ; if magnetic field is not load for the sc then load with sc = 2
  tplot_names, all_tplot_names.mag_names, names = names
  IF names(0) eq '' THEN BEGIN
     sc_mag = 2
     plot_mms_fgm_mag,[sc_mag],'GSM'
     all_tplot_names = load_tplot_names(sc, bmodel, sc_mag = sc_mag)
  ENDIF
                                ; if magnetic field is not load for the sc then load with sc = 3
  tplot_names, all_tplot_names.mag_names, names = names
  IF names(0) eq '' THEN BEGIN
     sc_mag = 3
     plot_mms_fgm_mag,[sc_mag],'GSM'
     all_tplot_names = load_tplot_names(sc, bmodel, sc_mag = sc_mag)
  ENDIF
                                ; if magnetic field is not load for the sc then load with sc = 4
  tplot_names, all_tplot_names.mag_names, names = names
  IF names(0) eq '' THEN BEGIN
     sc_mag = 4
     plot_mms_fgm_mag,[sc_mag],'GSM'
     all_tplot_names = load_tplot_names(sc, bmodel, sc_mag = sc_mag)
  ENDIF

; If there still no magnetic field loaded  then the local mag field
; will be recorded as NaN
  
;-- Load H+ and He++ moments--
  tplot_names, all_tplot_names.moments_names, names = names
  IF names(0) eq '' THEN plot_mms_hpca_moments, [sc, sc], [0, sp], 'GSM'
  
;-- Load ephemeris--
  tplot_names, all_tplot_names.ephemeris_names, names = names
  IF names(0) eq '' THEN BEGIN
     plot_mms_ephemeris, [sc]
     tplot_names, all_tplot_names.ephemeris_names, names = names
     if not keyword_set(names) then begin
        bmodel = 't89d'
        all_tplot_names = load_tplot_names(sc, bmodel)
        get_mms_ephemeris, [sc], bmodel = bmodel  
     endif 
  ENDIF 

;-- Load H+, He++, O+ energy spectra --
  tplot_names, all_tplot_names.diffflux_h1_name, names = names
  IF names(0) eq '' THEN plot_mms_hpca_en_spec, [sc,sc,sc], [0,1,3], 'DIFF FLUX',pa = [0,180]
  
;-- Load solar wind data from OMNI --
  tplot_names, all_tplot_names.kp_name, names = names
  IF names(0) eq '' THEN BEGIN
     read_omni, hr = 0, /all
     read_omni, hr = 1, /all

;-- handling kp index --
     get_data, all_tplot_names.x_gse_name, data = x_gse_data
     get_data, all_tplot_names.kp_name, data = data, dlim=dlim, lim=lim
     
     data_kp = INTERPOL(data.y, data.x, x_gse_data.x, /NAN)/10.
     store_data, all_tplot_names.kp_name, data = {x:x_gse_data.x, y:data_kp, dlim:dlim,lim:lim}
  ENDIF
  
;-- Load solar wind data from WIND SWE --
  get_timespan, tt
  ts = time_struct(tt[0])
  sw_filename = ['data/ace_swe_'+STRING(ts.year,FORMAT='(i4.4)')+'.tplot', 'data/wind_swe_h1_'+STRING(ts.year,FORMAT='(i4.4)')+'.tplot']
  tplot_restore, f=sw_filename[0]
  tplot_restore, f=sw_filename[1]
  
  ;; if ts.year eq 2016 then begin
  ;;    tplot_restore, f='data/sw_2016.tplot'
  ;; endif else begin
  ;;    if ts.year eq 2017 then begin
  ;;       tplot_restore, f='data/sw_2017.tplot'
  ;;    endif else stop
  ;; endelse

;-- Calculate MMS density ratio --
  get_data, all_tplot_names.h1_density_name, data=h1dens
  get_data, all_tplot_names.he2_density_name, data=he2dens
  
  he2dens_new = INTERPOL(he2dens.y, he2dens.x, h1dens.x)
  
; why 0.025 ?
  store_data, all_tplot_names.mms_alpha_ratio, data={x:h1dens.x, y:he2dens_new / h1dens.y}      
  
end 
