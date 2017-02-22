10 REM == RAM/ROM CHECKER ==
20 REM  'RUN' to probe for RAM and not-RAM
30 REM  'RUN 1000' to copy ROM to RAM and switch to RAM
40 REM  Full test:  'RUN'  'RUN 1000'  'RUN'

100 REM == Check memory chunks ==
110 FOR M=0 TO 63 STEP 8
120 R = M * 1024
130 IF M < 32 GOTO 150
140 R = R - (64*1024)
150 PRINT "Memory at " ; M ; "K is ";
160 GOSUB 200
170 NEXT M
180 END

200 REM == Check a location ==
210 X = PEEK( R ) 
220 POKE R, 55
230 Y = PEEK( R )
240 IF Y = 55 GOTO 400

300 REM == It was ROM ==
310 PRINT "ROM"
320 RETURN

400 REM == it was RAM ==
410 PRINT "RAM"
420 POKE R, X
430 RETURN


1000 REM == Copy and Run ==
1010 GOSUB 2000
1020 GOSUB 3000
1030 PRINT "Ready!"
1040 END


2000 REM == Copy ROM to RAM ==
2010 PRINT "Copying ROM..."
2020 FOR A = 0 TO 8192
2030 PRINT ".";
2040 B = PEEK( A )
2050 POKE A, B
2060 NEXT A
2070 RETURN

3000 REM == Switch off ROM ==
3010 PRINT "Switching to RAM"
3020 OUT 0, 1
3030 PRINT "Running from RAM!"
3040 RETURN

