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
  
;-----------------------------------------
;Get the time interval from timespan
;------------------------------------------
  ;; IF NOT KEYWORD_SET(t_s) OR NOT KEYWORD_SET(t_e) THEN BEGIN
  ;;    get_timespan, interval
  ;;    t_s = interval(0)
  ;;    t_e = interval(1)
  ;; ENDIF 
 
;-----------------------------------------------------------------
; Load the tplot varibles
;----------------------------------------------------------------

;-- Load Magnetic field--
  tplot_names, all_tplot_names.mag_names, names = names
  IF NOT KEYWORD_SET(names) THEN plot_mms_fgm_mag, [sc], 'GSM'

;-- Load H+ and He++ moments--
  tplot_names, all_tplot_names.moments_names, names = names
  IF NOT KEYWORD_SET(names) THEN plot_mms_hpca_moments, [sc, sc], [0, sp], 'GSM' 
   ;; get_data, p12, data=h1dens
	;; get_data, p13, data=he2dens
	;; he2dens_new = INTERPOL(he2dens.y, he2dens.x, h1dens.x)
	;; store_data, p18, data={x:h1dens.x, y:he2dens_new*0.025 / h1dens.y}
  
;-- Load ephemeris--
  tplot_names, all_tplot_names.ephemeris_names, names = names
  IF NOT KEYWORD_SET(names) THEN BEGIN
;     get_mms_ephemeris, [sc], bmodel = bmodel  
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
  IF NOT KEYWORD_SET(names) THEN plot_mms_hpca_en_spec, [sc,sc,sc], [0,1,3], 'DIFF FLUX',pa = [0,180]
  
;-- Load solar wind data from OMNI --
  tplot_names, all_tplot_names.kp_name, names = names
  IF NOT KEYWORD_SET(names) THEN BEGIN
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
  if ts.year eq 2016 then begin
     tplot_restore, f='data/sw_2016.tplot'
  endif else begin
     if ts.year eq 2017 then begin
        tplot_restore, f='data/sw_2017.tplot'
     endif else stop
  endelse
        
end 
