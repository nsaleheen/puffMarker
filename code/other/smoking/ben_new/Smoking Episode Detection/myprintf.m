function myprintf(fmt,varargin);

  global verbose_level;
  
  if(verbose_level>0) 
    fprintf(fmt,varargin{:});
  end
