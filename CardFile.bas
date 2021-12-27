DEFINT A-Z

DECLARE SUB Center (x, Text$)
DECLARE SUB Choose (x, y, Prompt$, Choice$, Choices$)
DECLARE SUB DisplayBackground ()
DECLARE SUB DisplayCards ()
DECLARE SUB DisplayFileList ()
DECLARE SUB DisplayHelp ()
DECLARE SUB DisplayHelpTopic (TopicNr)
DECLARE SUB DisplayInformation ()
DECLARE SUB DisplayPullDownMenus ()
DECLARE SUB DisplayTitle ()
DECLARE SUB DrawBox (x, y, Wdth, Height, Shadow)
DECLARE SUB InputBox (x, y, Prompt$, Text$, MaxLength, AllowFileList)
DECLARE SUB LoadFile ()
DECLARE SUB Main ()
DECLARE SUB PrintCards ()
DECLARE SUB ProcessChoice ()
DECLARE SUB RemoveFile ()
DECLARE SUB SaveFile ()
DECLARE FUNCTION FileExists (FileName$)
OPTION BASE 1
ON ERROR GOTO ErrorTrap
DIM SHARED CurRow, CurCard, CardCnt, FileName$, MenuBar$, MenuNr, MenuCurX, MenuY, DispDate, DispTime
DIM SHARED CardCaption$(100), CardText$(5, 100)
DIM SHARED ControlChar$(48), HelpText$(48), Topic$(4)
DIM SHARED MenuItem$(6, 4), MenuH(4), MenuW(4), State$(-1 TO 0)
SCREEN 0: WIDTH 80, 25: COLOR 7, 0: CLS
ERASE CardCaption$, CardText$
ERASE ControlChar$, HelpText$, Topic$
ERASE MenuItem$, MenuH, MenuW, State$
DispTime = -1: DispDate = -1
MenuBar$ = " File      Options   Card      Help     " + SPACE$(40)
State$(-1) = "On": State$(0) = "Off"
CardCnt = 10: CurCard = 1: CurRow = 1: FileName$ = " None "

DisplayTitle
CALL Main

PullDownMenuData:
DATA 13,6,12,2,17,3,14,2

ErrorTrap:
 DO
  e = ERR
  COLOR 7, 0: LOCATE 4
   FOR Row = 1 TO 6
    Center 0, SPACE$(26)
   NEXT Row
  COLOR 0, 7: LOCATE 5
   IF e = 7 OR e = 14 THEN
    Center 0, " Not enough memory. "
    Center 0, " Error: 1           "
   ELSEIF e = 52 OR e = 64 THEN
    Center 0, " Bad file name. "
    Center 0, " Error: 2       "
   ELSEIF e = 53 THEN
    Center 0, " Cannot find file. "
    Center 0, " Error: 3          "
   ELSEIF e = 61 THEN
    Center 0, " The disk is full. "
    Center 0, " Error: 4          "
   ELSEIF e = 62 THEN
    Center 0, " Error while   "
    Center 0, " reading file. "
    Center 0, " Error: 5      "
   ELSEIF e = 70 THEN
    Center 0, " Disk/file is     "
    Center 0, " write protected. "
    Center 0, " Error: 6         "
   ELSEIF e = 71 THEN
    Center 0, " No disk in diskdrive. "
    Center 0, " Error: 7              "
   ELSEIF e = 72 THEN
    Center 0, " The disk is damaged. "
    Center 0, " Error: 8             "
   ELSEIF e = 76 THEN
    Center 0, " Cannot find "
    Center 0, " directory.  "
    Center 0, " Error: 9    "
   ELSE
    Center 0, " Unexpected error. "
    Center 0, " Error: 0       "
   END IF
  PRINT : COLOR 7, 0
  Center 0, " Enter = Retry  Spacebar = Ignore  Escape = Quit "
  Center 0, " F1 = Help "
   DO
    DO
     Key$ = INKEY$
    LOOP WHILE Key$ = ""
    IF Key$ = " " THEN RESUME NEXT
    IF Key$ = CHR$(0) + ";" THEN DisplayHelpTopic 3: EXIT DO
    IF Key$ = CHR$(13) THEN RESUME
    IF Key$ = CHR$(27) THEN COLOR 7, 0: CLS : SYSTEM
   LOOP
 LOOP

SUB Center (x, Text$)
 IF x > 0 THEN LOCATE x
LOCATE , INT(40 - (LEN(Text$) / 2))
PRINT Text$
END SUB

SUB Choose (x, y, Prompt$, Choice$, Choices$)
COLOR 7, 0: LOCATE x, y: PRINT Prompt$
 DO
  Choice$ = UCASE$(INPUT$(1))
 LOOP UNTIL INSTR(Choices$, Choice$)
LOCATE x, y: PRINT SPACE$(LEN(Prompt$))
END SUB

SUB DisplayBackground
COLOR 7, 0
LOCATE 22, 3: PRINT USING " Card: ###/###"; CurCard; CardCnt
 IF DispTime THEN LOCATE 23, 3: PRINT USING " Time: \            \ "; TIME$
 IF DispDate THEN LOCATE 23, 25: PRINT USING " Date: \            \ "; DATE$
LOCATE 23, 58: PRINT USING " File Name: \        \"; FileName$
LOCATE 21, 1: PRINT STRING$(80, "Ä")
END SUB

SUB DisplayCards
CardX = 5: CardY = 30
 IF CurCard > CardCnt - 5 THEN
  CardX = CardX + ((4 - (CardCnt - CurCard)) * 2)
  CardY = CardY - ((4 - (CardCnt - CurCard)) * 2)
 END IF
COLOR 7, 0: LOCATE 3, 1: PRINT SPACE$(1400)
COLOR 0, 7
 FOR Card = 5 TO 1 STEP -1
  IF (CurCard - 1) + Card < CardCnt + 1 THEN
   LOCATE CardX - 2, CardY: PRINT "Ú"; STRING$(17, "Ä"); "¿"
   LOCATE CardX - 1, CardY: PRINT USING "³ \             \ ³"; CardCaption$((CurCard - 1) + Card);
   DrawBox CardX, CardY, 25, 5, 0
   LOCATE CardX, CardY: PRINT "Ã"; STRING$(17, "Ä"); "Á"
   CardX = CardX + 2: CardY = CardY - 2
  END IF
 NEXT Card
 FOR Row = 1 TO 5
  LOCATE Row + 13, 24: PRINT CardText$(Row, CurCard)
 NEXT Row
END SUB

SUB DisplayFileList
COLOR 7, 0: CLS : COLOR 0, 7: Center 1, " File List "
PRINT " Name:        Time:        Date: "; SPC(46);
COLOR 7, 0: LOCATE 22, 1: PRINT STRING$(80, "Ä")
OPEN "Names.lst" FOR APPEND AS 1: CLOSE 1
OPEN "Names.lst" FOR INPUT AS 1
 DO UNTIL EOF(1)
  COLOR 7, 0: LOCATE 3
   FOR ListFile = 1 TO 18
     IF EOF(1) THEN EXIT FOR
    INPUT #1, ListFile$, SaveTime$, SaveDate$
    LOCATE , 1: PRINT USING " \          \ \          \ \          \ "; ListFile$; SaveTime$; SaveDate$
   NEXT ListFile
  COLOR 0, 7: LOCATE 23, 5: PRINT " Press any key to continue... "
  Key$ = INPUT$(1)
 LOOP
CLOSE 1
COLOR 7, 0: CLS
LOCATE 3, 5: PRINT " F1 = File List "
END SUB

SUB DisplayHelp
 DO
  TopicNr = 1
  Topic$(1) = " Keys           "
  Topic$(2) = " Pulldownmenus  "
  Topic$(3) = " Error Messages "
  Topic$(4) = " Back           "
  COLOR 7, 0: CLS : COLOR 0, 7: DrawBox 1, 1, 78, 21, 0: Center 1, "´ Help Ã"
   DO
    FOR Topic = 1 TO 4
      IF Topic = TopicNr THEN COLOR 7, 0 ELSE COLOR 0, 7
     LOCATE Topic + 5, 10: PRINT Topic$(Topic)
    NEXT Topic
    DO
     Key$ = INKEY$
    LOOP WHILE Key$ = ""
    IF Key$ = CHR$(0) + "H" THEN
     IF TopicNr = 1 THEN TopicNr = 4 ELSE TopicNr = TopicNr - 1
    ELSEIF Key$ = CHR$(0) + "P" THEN
     IF TopicNr = 4 THEN TopicNr = 1 ELSE TopicNr = TopicNr + 1
    ELSEIF Key$ = CHR$(13) THEN
      IF TopicNr = 4 THEN COLOR 7, 0: CLS : EXIT SUB
     DisplayHelpTopic TopicNr: EXIT DO
    ELSEIF Key$ = CHR$(27) THEN
     COLOR 7, 0: CLS : EXIT SUB
    END IF
   LOOP
 LOOP
END SUB

SUB DisplayHelpTopic (TopicNr)
ERASE ControlChar$, HelpText$, Topic$
HlpRowCnt = 1
COLOR 7, 0: CLS
COLOR 0, 7: DrawBox 1, 1, 78, 21, 0
Center 1, "´ Help Ã"
OPEN "CardFile.hlp" FOR INPUT AS 1
 DO UNTIL EOF(1) OR ControlChar$(HlpRowCnt) = "x"
  INPUT #1, HelpText$
  ControlChar$ = LEFT$(HelpText$, 1)
   IF VAL(ControlChar$) = TopicNr THEN
    DO UNTIL EOF(1)
     LINE INPUT #1, HelpText$
     ControlChar$(HlpRowCnt) = LEFT$(HelpText$, 1)
     HelpText$(HlpRowCnt) = MID$(HelpText$, 2)
      IF ControlChar$(HlpRowCnt) = "x" THEN EXIT DO
     HlpRowCnt = HlpRowCnt + 1
    LOOP
   END IF
 LOOP
CLOSE 1

HlpCurRow = 1
LOCATE 21, 1: PRINT "Ã"; STRING$(78, "Ä"); "´"
LOCATE 22, 21: PRINT "/ = Scroll   Control + P = Print Topic"
 DO
  LOCATE 2
   FOR Row = HlpCurRow TO HlpCurRow + 18
     IF ControlChar$(Row) = "*" THEN COLOR 7, 0
     IF ControlChar$(Row) = "-" THEN COLOR 0, 7
    LOCATE , 2: PRINT HelpText$(Row); SPACE$(70 - LEN(HelpText$(Row)))
   NEXT Row
  COLOR 7, 0
  LOCATE 22, 3: PRINT USING " Row: ### "; HlpCurRow
  COLOR 0, 7
   DO
    Key$ = INKEY$
   LOOP WHILE Key$ = ""
   IF Key$ = CHR$(0) + "H" THEN
    IF HlpCurRow > 1 THEN HlpCurRow = HlpCurRow - 1
   ELSEIF Key$ = CHR$(0) + "P" THEN
    IF HlpCurRow < 30 THEN HlpCurRow = HlpCurRow + 1
   ELSEIF Key$ = CHR$(27) THEN
    COLOR , 0: CLS : EXIT DO
   ELSEIF Key$ = CHR$(16) THEN
    FOR Row = 1 TO HlpRowCnt
     LPRINT HelpText$(Row)
    NEXT Row
   END IF
 LOOP
END SUB

SUB DisplayInformation
COLOR 0, 7
DrawBox 7, 30, 18, 3, -1
Center 7, "´ Information  Ã"
Center 0, "Cardfile, By: "
Center 0, "Peter Swinkels"
Center 0, "  ***1996***  "
Key$ = INPUT$(1)
END SUB

SUB DisplayPullDownMenus
MenuNr = 1: MenuCurX = 1: MenuY = 1
RESTORE PullDownMenuData
 FOR Menu = 1 TO 4
  READ MenuW(Menu), MenuH(Menu)
 NEXT Menu
MenuItem$(1, 1) = "New File"
MenuItem$(2, 1) = "Load File"
MenuItem$(3, 1) = "Save File"
MenuItem$(4, 1) = "Remove File"
MenuItem$(5, 1) = "Print Cards"
MenuItem$(6, 1) = "Quit"
MenuItem$(1, 2) = "Time = " + State$(DispTime)
MenuItem$(2, 2) = "Date = " + State$(DispDate)
MenuItem$(1, 3) = "Number of Cards"
MenuItem$(2, 3) = "Erase Card Text"
MenuItem$(3, 3) = "Card Caption"
MenuItem$(1, 4) = "Display Help"
MenuItem$(2, 4) = "Information"

 DO
  COLOR 0, 7
  LOCATE 1, 1: PRINT MenuBar$
  DrawBox 2, MenuY, MenuW(MenuNr), MenuH(MenuNr), -1
  COLOR 7, 0: LOCATE 1, MenuY: PRINT MID$(MenuBar$, MenuY, 10)
   FOR MenuItem = 1 TO MenuH(MenuNr)
     IF MenuItem = MenuCurX THEN COLOR 7, 0 ELSE COLOR 0, 7
    Menu = LEN(MenuItem$(MenuItem, MenuNr)) + 1
    LOCATE MenuItem + 2, MenuY + 1: PRINT " "; MenuItem$(MenuItem, MenuNr); SPACE$(MenuW(MenuNr) - Menu)
   NEXT MenuItem
   DO
    Key$ = INKEY$
   LOOP WHILE Key$ = ""
  COLOR 7, 0
   IF Key$ = CHR$(0) + "H" THEN
    IF MenuCurX = 1 THEN MenuCurX = MenuH(MenuNr) ELSE MenuCurX = MenuCurX - 1
   ELSEIF Key$ = CHR$(0) + "P" THEN
    IF MenuCurX = MenuH(MenuNr) THEN MenuCurX = 1 ELSE MenuCurX = MenuCurX + 1
   ELSEIF Key$ = CHR$(0) + "K" THEN
    LOCATE 2, 1: PRINT SPACE$(720): MenuCurX = 1: DisplayCards
     IF MenuY = 1 THEN MenuY = 31: MenuNr = 4 ELSE MenuY = MenuY - 10: MenuNr = MenuNr - 1
   ELSEIF Key$ = CHR$(0) + "M" THEN
    LOCATE 2, 1: PRINT SPACE$(720): MenuCurX = 1: DisplayCards
     IF MenuY = 31 THEN MenuY = 1: MenuNr = 1 ELSE MenuY = MenuY + 10: MenuNr = MenuNr + 1
   ELSEIF Key$ = CHR$(13) THEN
    ProcessChoice
   ELSEIF Key$ = CHR$(27) THEN
    EXIT DO
   END IF
 LOOP
END SUB

SUB DisplayTitle
OPEN "Title.dat" FOR INPUT AS 1
 DO UNTIL EOF(1)
  LINE INPUT #1, Title$
  Center 0, Title$
 LOOP
CLOSE 1
COLOR 0, 7
Center 12, " Cardfile, By: Peter Swinkels, ***1996*** "
Center 14, " Press any key to continue. "
Key$ = INPUT$(1)
END SUB

SUB DrawBox (x, y, Wdth, Height, Shadow)
LOCATE x, y: PRINT "Ú"; STRING$(Wdth, "Ä"); "¿"
 FOR BoxRow = 1 TO Height
  LOCATE , y: PRINT "³"; SPC(Wdth); "³";
   IF Shadow THEN PRINT "°°" ELSE PRINT
 NEXT BoxRow
LOCATE , y: PRINT "À"; STRING$(Wdth, "Ä"); "Ù";
 IF Shadow THEN PRINT "°°": LOCATE , y + 2: PRINT STRING$(Wdth + 2, "°");  ELSE PRINT
END SUB

FUNCTION FileExists (FileName$)
FileExists = 0
OPEN "Names.lst" FOR APPEND AS 1: CLOSE 1
OPEN "Names.lst" FOR INPUT AS 1
 DO UNTIL EOF(1)
  INPUT #1, ListFile$, SaveTime$, SaveDate$
   IF UCASE$(FileName$) = ListFile$ THEN FileExists = -1: EXIT DO
 LOOP
CLOSE 1
END FUNCTION

SUB InputBox (x, y, Prompt$, Text$, MaxLength, AllowFileList)
 DO
  COLOR 7, 0: LOCATE x, y: PRINT Prompt$; Text$; : COLOR 23: PRINT "_ "
   DO
    Key$ = INKEY$
   LOOP WHILE Key$ = ""
  l = LEN(Text$)
   IF Key$ = CHR$(8) THEN
    IF l > 0 THEN Text$ = LEFT$(Text$, l - 1)
   ELSEIF Key$ = CHR$(13) THEN
    EXIT DO
   ELSEIF Key$ = CHR$(27) THEN
    Text$ = "": EXIT DO
   ELSEIF Key$ = CHR$(0) + ";" THEN
    IF AllowFileList THEN DisplayFileList
   ELSEIF ASC(Key$) > 31 THEN
    IF l < MaxLength THEN Text$ = Text$ + Key$
   END IF
 LOOP
LOCATE x, y: PRINT SPACE$(LEN(Prompt$) + l + 2)
END SUB

SUB LoadFile
COLOR , 0: CLS
LOCATE 3, 5: PRINT " F1 = File List "
InputBox 4, 5, " Load File: ", Text$, 30, 1
 IF Text$ = "" THEN EXIT SUB
FileName$ = Text$

CardCnt = 10: CurCard = 1: CurRow = 1
ERASE CardCaption$, CardText$
OPEN FileName$ + ".crd" FOR INPUT AS 1: CLOSE 1
OPEN FileName$ + ".crd" FOR BINARY AS 1
 FOR Card = 1 TO 100
   IF LOC(1) = LOF(1) THEN EXIT FOR
  l = ASC(INPUT$(1, 1)): CardCaption$(Card) = INPUT$(l, 1)
   FOR Row = 1 TO 5
    l = ASC(INPUT$(1, 1)): CardText$(Row, Card) = INPUT$(l, 1)
   NEXT Row
 NEXT Card
CLOSE 1
CardCnt = Card - 1
END SUB

SUB Main
 DO
  COLOR 7, 0: CLS
  LOCATE 21, 1: PRINT STRING$(80, "Ä")
  DisplayCards
  COLOR 0, 7: LOCATE 1, 1: PRINT MenuBar$: COLOR 7, 0
   DO
    COLOR 0, 7
    LOCATE CurRow + 13, 24: PRINT CardText$(CurRow, CurCard); : COLOR 16: PRINT "_ "
    COLOR 7, 0
     DO
      LOCATE 22, 3: PRINT USING " Card: ###/###"; CurCard; CardCnt
       IF DispTime THEN LOCATE 23, 3: PRINT USING " Time: \            \ "; TIME$
       IF DispDate THEN LOCATE 23, 25: PRINT USING " Date: \            \ "; DATE$
      LOCATE 23, 58: PRINT USING " Name: \        \"; FileName$
      Key$ = INKEY$
     LOOP WHILE Key$ = ""
    l = LEN(CardText$(CurRow, CurCard))
    LOCATE CurRow + 13, 24 + l: PRINT "Û"
     IF Key$ = CHR$(0) + "H" THEN
      IF CurRow > 1 THEN CurRow = CurRow - 1
     ELSEIF Key$ = CHR$(0) + "P" THEN
      IF CurRow < 5 THEN CurRow = CurRow + 1
     ELSEIF Key$ = CHR$(0) + "K" THEN
       IF CurCard > 1 THEN CurCard = CurCard - 1: CurRow = 1
      DisplayCards
     ELSEIF Key$ = CHR$(0) + "M" THEN
       IF CurCard < CardCnt THEN CurCard = CurCard + 1: CurRow = 1
      DisplayCards
     ELSEIF Key$ = CHR$(0) + "S" THEN
      IF l > 0 THEN
       LOCATE CurRow + 13, 24: PRINT STRING$(22, "Û")
       CopiedData$ = CardText$(CurRow, CurCard): CardText$(CurRow, CurCard) = ""
      END IF
     ELSEIF Key$ = CHR$(3) THEN
      IF l > 0 THEN CopiedData$ = CardText$(CurRow, CurCard)
     ELSEIF Key$ = CHR$(0) + "R" THEN
      IF CardText$(CurRow, CurCard) = "" THEN CardText$(CurRow, CurCard) = CopiedData$
     ELSEIF Key$ = CHR$(8) THEN
      IF l > 0 THEN CardText$(CurRow, CurCard) = LEFT$(CardText$(CurRow, CurCard), l - 1)
     ELSEIF Key$ = CHR$(14) THEN
      InputBox 20, 5, " Card Caption: ", Text$, 15, 0
       IF NOT Text$ = "" THEN CardCaption$(CurCard) = Text$: Text$ = "": DisplayCards
     ELSEIF Key$ = CHR$(27) THEN
      DisplayPullDownMenus
      EXIT DO
     ELSEIF Key$ = CHR$(13) THEN
      IF CurRow < 5 THEN CurRow = CurRow + 1
     ELSEIF ASC(Key$) > 31 THEN
      IF l < 22 THEN CardText$(CurRow, CurCard) = CardText$(CurRow, CurCard) + Key$
     END IF
   LOOP
 LOOP
END SUB

SUB PrintCards
InputBox 20, 3, " How many cards do you want to print? ", Text$, 3, 0
PrintCnt = VAL(Text$)
 IF PrintCnt <= CardCnt THEN
  FOR Card = 1 TO PrintCnt
   LPRINT "Ú"; STRING$(17, "Ä"); "¿"
   LPRINT USING "³ \             \ ³"; CardCaption$(Card)
   LPRINT "Ã"; STRING$(17, "Ä"); "ÁÄÄÄÄÄÄÄ¿"
    FOR Row = 1 TO 5
     LPRINT USING "³ \                     \ ³"; CardText$(Row, Card)
    NEXT Row
   LPRINT "À"; STRING$(25, "Ä"); "Ù"
  NEXT Card
 END IF
END SUB

SUB ProcessChoice
 IF MenuNr = 1 THEN
  IF MenuCurX = 1 THEN
   Choose 20, 3, " Start with a new cardfile Y/N? ", Choice$, "YN"
    IF Choice$ = "Y" THEN
     CardCnt = 10: CurCard = 1: CurRow = 1: FileName$ = " None "
     ERASE CardText$, CardCaption$
     DisplayCards
    END IF
  ELSEIF MenuCurX = 2 THEN
   LoadFile
   COLOR 7, 0: CLS : DisplayCards: DisplayBackground
  ELSEIF MenuCurX = 3 THEN
   SaveFile
   COLOR 7, 0: CLS : DisplayCards: DisplayBackground
  ELSEIF MenuCurX = 4 THEN
   RemoveFile
   COLOR 7, 0: CLS :  DisplayCards: DisplayBackground
  ELSEIF MenuCurX = 5 THEN
   PrintCards
  ELSEIF MenuCurX = 6 THEN
   Choose 20, 3, " Quit Y/N? ", Choice$, "YN"
    IF Choice$ = "Y" THEN COLOR , 0: CLS : SYSTEM
  END IF
 ELSEIF MenuNr = 2 THEN
  IF MenuCurX = 1 THEN
    IF DispTime THEN DispTime = 0 ELSE DispTime = -1
   MenuItem$(1, 2) = "Time = " + State$(DispTime)
  ELSEIF MenuCurX = 2 THEN
    IF DispDate THEN DispDate = 0 ELSE DispDate = -1
   MenuItem$(2, 2) = "Date = " + State$(DispDate)
  END IF
 ELSEIF MenuNr = 3 THEN
  IF MenuCurX = 1 THEN
   InputBox 20, 3, " Number of Cards (10-100): ", Text$, 3, 0
    IF NOT Text$ = "" THEN NewCnt = VAL(Text$)
    IF NewCnt > 9 AND NewCnt < 101 THEN CardCnt = NewCnt
  ELSEIF MenuCurX = 2 THEN
   InputBox 20, 3, " Remove Card Number: ", Text$, 3, 0
   Card = VAL(Text$)
    IF Card > 0 AND Card < 101 THEN
     Choose 20, 3, " Remove card number " + STR$(Card) + " Y/N? ", Choice$, "YN"
      IF Choice$ = "Y" THEN
       CardCaption$(Card) = ""
        FOR Row = 1 TO 5
         CardText$(Row, Card) = ""
        NEXT Row
       DisplayCards
      END IF
    END IF
  ELSEIF MenuCurX = 3 THEN
   InputBox 20, 5, " Card Caption: ", Text$, 12, 0
    IF NOT Text$ = "" THEN CardCaption$(CurCard) = Text$: Text$ = "": DisplayCards
  END IF
 ELSEIF MenuNr = 4 THEN
  IF MenuCurX = 1 THEN
   DisplayHelp
   DisplayCards
   DisplayBackground
   COLOR 7, 0
  ELSEIF MenuCurX = 2 THEN
   DisplayInformation
   DisplayCards
  END IF
 END IF
END SUB

SUB RemoveFile
COLOR 7, 0: CLS
LOCATE 3, 5: PRINT " F1 = File List "
InputBox 4, 5, " Remove File: ", Text$, 30, 1
 IF Text$ = "" THEN EXIT SUB
DelFile$ = Text$
Choose 4, 5, "Remove: " + DelFile$ + " Y/N? ", Choice$, "YN"
 IF Choice$ = "N" THEN EXIT SUB
OPEN "Names.lst" FOR INPUT AS 1
OPEN "Names.tmp" FOR OUTPUT AS 2
 DO UNTIL EOF(1)
  INPUT #1, ListFile$, ListTime$, ListDate$
   IF NOT UCASE$(DelFile$) = ListFile$ THEN
    PRINT #2, ListFile$; ","; ListTime$; ","; ListDate$; ",";
   END IF
 LOOP
CLOSE 1, 2
KILL "Names.lst"
NAME "Names.tmp" AS "Names.lst"
KILL DelFile$ + ".crd"
END SUB

SUB SaveFile
COLOR 7, 0: CLS
LOCATE 3, 5: PRINT " F1 = File List "
InputBox 4, 5, " Save File As: ", Text$, 30, -1
 IF Text$ = "" THEN EXIT SUB
FileName$ = Text$

 IF FileExists(FileName$) THEN
  Choose 4, 5, FileName$ + " already exists, overwrite Y/N? ", Choice$, "YN"
   IF Choice$ = "N" THEN EXIT SUB
 ELSE
  OPEN "Names.lst" FOR APPEND AS 1
   PRINT #1, UCASE$(FileName$); ","; TIME$; ","; DATE$
  CLOSE 1
 END IF

OPEN FileName$ + ".crd" FOR OUTPUT AS 1
 FOR Card = 1 TO CardCnt
  PRINT #1, CHR$(LEN(CardCaption$(Card))); CardCaption$(Card);
   FOR Row = 1 TO 5
    PRINT #1, CHR$(LEN(CardText$(Row, Card))); CardText$(Row, Card);
   NEXT Row
 NEXT Card
CLOSE 1
END SUB

