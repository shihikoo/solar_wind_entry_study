FUNCTION read_csv_data, fln, data, header = header
  names = FINDFILE(fln, count = ct)
  if ct eq 0 then begin
     print, 'no files found' 
     RETURN,0
  endif 

  data = READ_CSV(names(0), HEADER = header)
  
  data = RENAME_TAGS(data, TAG_NAMES(data), header)

  return, data

END
