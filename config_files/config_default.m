% DEFAULT CONFIG FILE SETUP
 
% OUTDATED - DO NOT USE

inifile('\image mosaic\config_files\conf.ini','new');
writeKeys = {

           'description','','main','main routine for calling image composition';...
           'description','','patch_mosaic','routine for patching mosaic';...

           'main','database','folder','/image mosaic/images/building';...
           'main','database','format','.jpg';...
           'main','database','num', 5;... 
           
           'variables','findHomography', 'minPtNum', 4;...
           'variables','findHomography', 'iterNum', 30;...
           'variables','findHomography', 'thDist', 4;...
           'variables','findHomography', 'thInlrRatio', 0.2};

inifile('\image mosaic\config_files\conf.ini','write',writeKeys,'plain');