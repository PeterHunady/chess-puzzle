Autor:
Peter Huňady (xhunadp00)

Štruktúra projektu:


/boardController/ → Priečinok pre controller šachovnice
	/board.dart → Hlavný controller pre šachovnicu, (xkaletk00)


/controller/ → Priečinok pre controlleri na prácu s databázou
	/class_controller.dart → Controller na správu tried (xhunadp00)
    /classUser_controller.dart → Controller na správu užívateľov v triedach (xhunadp00)
    /invitation_controller.dart → Controller na správu pozvánok od tried pre užívateľov (xhunadp00)
    /pendingInvitations_controller.dart → Controller na správu pozvánok od užívateľov pre triedy (xhunadp00)
    /puzzle_controller.dart → Controller na správu puzzle v triedach (xkaletk00)
    /user_controller.dart → Controller na správu užívateľov (xhunadp00)
    /userPuzzle_controller.dart → Controller na správu štatistík puzzle pre užívateľov triedy (xkaletk00)


/customWidgets/ → Priečinok pre vlastné widgety využívané v priečinku /subpages/ a /obx_widget/
	/customBoxWithText_widget.dart → Box s textom pre štatistiky (priemerný čas, priemerný počet pokusov..) (xhunadp00)
	/customButton_widget.dart → Opakovane použiteľný widget tlačidla s vlastným odsadením, orámovaním a farbou pozadia (xhunadp00)
	/customButtonWithIcon_widget.dart → Tlačidlo s ikonou vo vnútri (xhunadp00)
	/customChessBoard_widget.dart → Widget šachovnicovej plochy (xkaletk00)
	/customChessMovesBox_widget.dart → Widget na zobrazenie ťahov bielych a čiernych figuriek (xhunadp00)
	/customClassNavbar_widget.dart → Widget navbar s ikonou triedy a názvom (xhunadp00)
	/customDefaultNavbar_widget.dart → Widget Navbar s ikonou aplikácie ChessUp (xhunadp00)
	/customFooter_widget.dart →Pätička s položkami (domov, trieda, menu) na navigáciu na inú podstránku (xhunadp00)
	/customIconWithText_widget.dart → Widget ikony v kruhu s textom vedľa nej  (xhunadp00)
	/customPuzzlePreviewCard_widget.dart → Karta puzzle so štatistikami na pravej strane (xkaletk00)
	/customRoundedIcon_widget.dart → Widget ikony v kruhu (xhunadp00)
	/customTextField_widget.dart → Widget textového poľa pre vstupy (xhunadp00)


/models/ → Priečinok s modelmi
	/class_model.dart → Model triedy (xhunadp00)
	/classUser_model.dart → Model užívateľov v triedach (xhunadp00)
	/invitations_model.dart → Model pozvánok od tried pre užívateľov (xhunadp00)
	/pendingInvitations_model.dart → Model pozvánok od užívateľov pre triedy (xhunadp00)
	/puzzle_model.dart →  Model puzzle (xkaletk00)
	/user_model.dart → Model užívateľov (xhunadp00)
	/userPuzzle_model.dart → Model štatistík puzzle pre užívateľov triedy (xkaletk00)


/obx_widgets/ → Pričinok pre widgety, ktoré sledujú a automaticky aktualizujú používateľské rozhranie pri zmene dát
	/invitations_widget.dart → Widget zoznamu pozvánok pre používateľa (xhunadp00)
	/memberPuzzleGrid_widget.dart → Widget zoznamu štatistík každého puzzle vybraného študenta (xhunadp00)
	/membersGrid_widget.dart → Widget zoznamu všetkých študentov v triede (xhunadp00)
	/pendingInvitations_widget.dart → Widget zoznamu všetkých nevybavených pozvánok pre triedu (xhunadp00)
	/puzzleGrid_widget.dart → Widget zoznamu všetkých hlavolamov v triede (xhunadp00)
	/statisticOfPuzzleGrid_widget.dart → Widget zoznamu štatistík každého puzzle triede (xhunadp00)
	/statisticsGrid_widget.dart → Widget zoznamu štatistík každého študenta v triede (xhunadp00)
	/userClassesGrid_widget.dart → Widget zoznamu všetkých tried používateľa (xhunadp00)

/pieces/ → Priečinok pre triedy šachových figúrok, ktoré využívajú dedičnosť
	/bishop.dart → Trieda pre strelca (xkaletk00)
	/king.dart → Trieda pre kráľa (xkaletk00)
	/knight.dart → Trieda pre koňa (xkaletk00)
	/pawn.dart → Trieda pre pešiaka (xkaletk00)
	/piece.dart → Rodičovská trieda všetkých figúrok (xkaletk00)
	/queen.dart → Trieda pre kráľovnu (xkaletk00)
	/rook.dart → Trieda pre vežu  (xkaletk00)


/subpages/ → Jednotlivé podstránky aplikácie
	/allPuzzles_page.dart → Podstránka všetkých puzzle v triede (xkaletk00)
	/classHome_page.dart → Podstránka na zobrazenie triedy (xhunadp00)
	/classStatistics_page.dart → Podstránka na zobrazenie štatistík triedy a ich členov (xhunadp00)
	/createClass_page.dart → Podstránka na vytvorenie novej triedy (xhunadp00)
	/createMoves_page.dart → Podstránka na nahrávanie krokov v puzzle (xkaletk00)
	/createPuzzle_page.dart → Podstránka na nahratie začiatočnej pozície v puzzle (xkaletk00)
	/home_page.dart → Hlavná stránka (xhunadp00)
	/invitations_page.dart → Podstránka zoznamu všetkých pozvánok od tried pre užívateľa (xhunadp00)
	/members_page.dart → Podstránka so zoznamom všetkých užívateľov v triede (xhunadp00)
	/memberStatistic_page.dart → Podstránka štatistík užívateľa v triede (xhunadp00)
	/menu_page.dart → Podstránka hlavného menu (xhunadp00)
	/playChessPuzzle_page.dart → Podstránka na hranie puzzle (xkaletk00)
	/puzzle_page.dart → Podstránka na zobrazenie štatistík daného puzzle (xhunadp00)
	/signIn_page.dart → Podstránka na prihlásenie do aplikácie (xhunadp00)
	/signUp_page.dart → Podstránka na registráciu do aplikácie (xhunadp00)


/firebase_options.dart  → Nastavenia firebase databázy (vygenerovaný)
/main.dart → Hlavná časť programu pre spustenie aplikácie (xhunadp00)
/navigationAndToasts.dart → Funkcie na navigáciu (prepínanie) medzi jednotlivými podstránkami a “toast” správ. (xhunadp00)
