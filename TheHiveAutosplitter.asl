state("TheHive_S1_102410"){
    int LevelNumber: 0x1AF2F8;
    /*
    Funktioniert zu 99,9% präzise, dank statischer Adresse
    Main Menu = 131
    Inventory = 93
    Intro = 133
    First Level / Start = 95
    Screen after first Level = 181
    Level-3 = 103
    */
    int HUD_Number: 0x18989C;
    //In-Game = 2

    double Door1: 0x1AF2F4, 0x80, 0x3B4, 0x0, 0x10;
    double Door2: 0x1AF2F4, 0x80, 0x3B4, 0x4, 0x10;
    //Double from 0 to 5 to 10 - Door1 Funktioniert so weit gut für LVL3 und LVL4, es waren aber noch andere Pointer vorhanden 

    double EndTimer: 0x1AF2F0, 0x2B0, 0x78, 0x508, 0x0, 0x10C, 0x4, 0x10;
    //Timer from 9 to 0 in double 
}
init{
    int splitnum;
}
start{
    //Starts Timer after 95 / First Level after intro. And to not start again after reset it checks a few things :D
    if(current.LevelNumber==95 && current.LevelNumber != old.LevelNumber && old.LevelNumber != 93 && old.LevelNumber != 181){vars.splitnum=0; return true;}
}
split{
    //Splits when opening Level 3 door
    if(vars.splitnum == 0 && current.LevelNumber==103 && current.Door1 > 0){vars.splitnum++; return true;}
    //Splits when opening Level 4 door
    if(vars.splitnum == 1 && current.LevelNumber==109 && current.Door1 > 0){vars.splitnum++; return true;}
    //Splits when opening Level 5 door
    if(vars.splitnum == 2 && current.LevelNumber==66 && current.Door2 > 0){vars.splitnum++; return true;}
    //Splits when entering Van Klaus room
    if(vars.splitnum == 3 && current.LevelNumber==172){vars.splitnum++; return true;}
    //Ends when timer is 0 / first frame of explotion
    if(vars.splitnum == 4 && current.EndTimer == 9 && current.LevelNumber == 172){vars.splitnum++; return true;}
}
reset{
    if(current.LevelNumber == 133){return true;}
}
/* Pause if in a HUD or Menu
isLoading{
    if(current.HUD_Number != 2){return true;}
    else{return false;}
}*/