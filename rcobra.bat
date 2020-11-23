echo off
copy %1 bin
cd bin
copy %1 INPFILE
echo ******COBRA******
cobra
echo *****************
copy OUTFILE ..\
copy PLOTFILE ..\
del INPFILE OUTFILE PLOTFILE grafile grbfile
cd ../
copy OUTFILE %1.out
copy PLOTFILE %1.plt
del OUTFILE PLOTFILE 
