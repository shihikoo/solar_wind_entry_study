PRO draw_scatter_plot, x,y, index1, index2, ps_plot = ps_plot, filename = filename, title = title, xtitle = xtitle, ytitle = ytitle, xrange = xrange, yrange = yrange, xlog = xlog, ylog = ylog,legends=legends
; default keywords settings
  if ~keyword_set(legends) then legends = ['','']
  if ~keyword_set(xrange) then xrange = [min(x) - 0.5 * min(x), max(x) + 0.5 * max(x)]
  if ~keyword_set(yrange) then yrange = [min(y) - 0.5 * min(y), max(y) + 0.5 * max(y)]
  
  PLOT,[0, 0, -100, 100], [-100, 100, 0, 0] $
       , title = title, xtitle = xtitle, ytitle = ytitle, xrange = xrange, yrange = yrange, xstyle = 1, ystyle = 1 $
       , charsize = 1.2,  xlog = xlog, ylog = ylog, xcharsize = 2, ycharsize = 2
  
; plot data with index1      
  oplot, x[index1],y[index1], symsize=1, psym = 4, color = 6
; plot data with index2
  oplot, x[index2],y[index2], symsize=1, psym = 4, color = 2
; legend         
  xyouts, 4, 1, legends[0], color = 6, charsize = 1
  xyouts, 4, 0.9, legends[1], color = 2, charsize = 1

; drow the center lines 
  OPLOT, [0, 0, -100, 100], [-100, 100, 0, 0], col = 0, thick = 8
END 
