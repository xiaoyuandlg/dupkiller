@echo off

echo --------------------------------------------------------------------
echo Calc each file's md5Value in current folder, saving to a file...
for %%i in (*.*) do (
	md5sum %%i >> md5AndFileName.txt
	)

echo --------------------------------------------------------------------
echo Format to save only md5Values info...
cut -f 1 -d' ' md5AndFileName.txt > md5Value.txt


echo --------------------------------------------------------------------
echo Save only unique lines of md5Value...
cat md5Value.txt|sort|uniq > uniqMd5Value.txt

echo --------------------------------------------------------------------
echo Match only one line for each unique md5Value...
for /f "tokens=*" %%j in (uniqMd5Value.txt) do (
	grep -m 1 %%j md5AndFileName.txt >> uniqItems.txt
	)

echo --------------------------------------------------------------------
echo Inverse match to figure out duplicate files...
grep -vF -f uniqItems.txt md5AndFileName.txt > duplicateItems.txt

echo --------------------------------------------------------------------
echo Save only duplicate file names...
cut -f 2 -d'*' duplicateItems.txt > duplicateItemsFileNames.txt

echo --------------------------------------------------------------------
echo Loop deleting duplicate files by file names...
for /f "tokens=*" %%k in (duplicateItemsFileNames.txt) do (
	del /q %%k
	)

echo --------------------------------------------------------------------
echo Done!
pause
