REM ===================================
REM  RDA5807M.BAS
REM  Class library
REM   for RDA5807M FM Radio Tuner
REM   on MachiKania type P/PU
REM ===================================

REM ====== Sample Program ======
USECLASS RDA5807M

USEVAR RDA

REM Set I2C Baudrate 100kHz
RDA=NEW(RDA5807M,100)

CLS
PRINT "RDA5807M Class Sample Program"
PRINT "[FIRE]=Quit [";CHR$($1C);"]/[";CHR$($1D);"]=Seek [";CHR$($1E);"]/[";CHR$($1F);"]=Vol"

RDA.INIT()
V = RDA.SETVOL(V)
RDA.SEEKUP()

F=RDA.RDFREQ()
CURSOR 0,3:PRINT "Frequency: ";F/10;".";F%10;" MHz "
CURSOR 0,5:PRINT "Volume: ";V;"  "
CURSOR 0,6:PRINT "Signal: ";RDA.RDRSSI();" "
CURSOR 0,7
IF RDA.RDST()==0 THEN
 PRINT "Mono  " 
ELSE
 PRINT "Stereo"
ENDIF

DO
 K = KEYS()
 IF K==0 THEN
  WAIT 10
  CONTINUE
 ELSEIF K==1 THEN
  IF V<15 THEN
   V = V + 1
   V = RDA.SETVOL(V)
  ENDIF
 ELSEIF K==2 THEN
  IF V>0 THEN
   V = V - 1
   V = RDA.SETVOL(V)
  ENDIF
 ELSEIF K==4 THEN
  RDA.SEEKDOWN()
 ELSEIF K==8 THEN
  RDA.SEEKUP()
 ELSEIF K==32 THEN
  END
 ENDIF

 F=RDA.RDFREQ()
 CURSOR 0,3:PRINT "Frequency: ";F/10;".";F%10;" MHz "
 CURSOR 0,5:PRINT "Volume: ";V;"  "
 CURSOR 0,6:PRINT "Signal: ";RDA.RDRSSI();" "
 CURSOR 0,7
 IF RDA.RDST()==0 THEN
  PRINT "Mono  " 
 ELSE
  PRINT "Stereo"
 ENDIF
 WAIT 10
LOOP


REM ====== Class ======
OPTION CLASSCODE

FIELD PRIVATE ADA,ADB,REG,HI,LO,VOL,STC,FREQ,RSSI,ST


METHOD INIT
 REM Clock (kHz)
 I2C ARGS(1)

 REM I2C 7bit slave addresses
 ADA = $10
 ADB = $11

 REM RDA registers 02H-07H (32bit)
 DIM R(5)

 REM initialize register values
 REM BAND:76-108 MHz (world wide)
 REM SPACE:100 kHz
 R(0) = $0000D005
 R(1) = $00000008
 R(2) = $00000A00
 R(3) = $00008880
 R(4) = 0
 R(5) = 0

 REM Volume (0-15)
 V = 1

 R(0) = R(0) OR $00000002
 R(0) = R(0) AND $FFFFFFFD
 GOSUB(WRITEALL)

 RETURN

REM Set volume
METHOD SETVOL
 VAR VOL
 VOL = ARGS(1)
 R(3) = (R(3) AND $FFFFFFF0) OR VOL
 GOSUB(WRITEREG,3)
 RETURN VOL

REM Seek up
METHOD SEEKUP
 VAR STC
 REM RDA registers 0AH-0FH (32bit)
 DIM G((6/2)-1)
 R(0) = R(0) OR $00000300
 GOSUB(WRITEREG,0)

 DO
  I2CREADDATA ADA,G,6*4
  WAIT 1
  STC = PEEK(G) AND $40
 LOOP UNTIL (STC != 0)
 RETURN

REM Seek down
METHOD SEEKDOWN
 VAR STC

 REM RDA registers 0AH-0FH (32bit)
 DIM G((6/2)-1)
 R(0) = R(0) OR $00000000
 GOSUB(WRITEREG,0)

 DO
  I2CREADDATA ADA,G,6*4
  WAIT 1
  STC = PEEK(G) AND $40
 LOOP UNTIL (STC != 0)
 RETURN

REM Read Frequency
METHOD RDFREQ
 VAR FREQ
 FREQ = (PEEK(G) AND $03) << 8
 FREQ = FREQ + PEEK(G+1) + 760
 RETURN FREQ

REM Read Signal power
METHOD RDRSSI
 VAR RSSI
 RSSI = (PEEK(G+2) AND $FE) >> 1
 RETURN RSSI

REM Stereo/Mono
METHOD RDST
 VAR ST
 ST = (PEEK(G) AND $04) >> 2
 RETURN ST

REM --------------------------------
REM Get high byte of R(reg)
LABEL GETHI
 VAR REG
 REG = ARGS(1)
 RETURN PEEK(R + REG*4 + 1)

REM Get low byte of R(reg)
LABEL GETLO
 VAR REG
 REG = ARGS(1)
 RETURN PEEK(R + REG*4 + 0)

REM Write one register
LABEL WRITEREG
 VAR REG,HI,LO
 REG = ARGS(1)
 HI = GOSUB(GETHI,REG)
 LO = GOSUB(GETLO,REG)
 I2CWRITE ADB,2+REG,HI,LO
 WAIT 1
 RETURN

REM Write all registers 0x02-0x07
LABEL WRITEALL
 VAR I
 FOR I=0 TO 5
  GOSUB(WRITEREG,I)
 NEXT
 RETURN