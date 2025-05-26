state("TheHive_S1_102410"){ //Memory addresses
    int LevelNumber: 0x1AF2F8;
    /*
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

    double Move: 0x001AF2F4, 0x80, 0x1C, 0x0, 0x10C, 0x4, 0xB0;
    //0x001AF2F4, 0x5C, 0xB4, 0x0, 0x10C, 0x4, 0xB0;
    //0x001AF2F4, 0x60, 0x6C, 0x0, 0x10C, 0x4, 0xB0;
    //0x001AF2F4, 0x78, 0x1C, 0x0, 0x10C, 0x4, 0xB0;

    double Jump: 0x001AF2F4, 0x78, 0x1C, 0x0, 0x10C, 0x4, 0x218;
    //0x001AF2F4, 0x78, 0x1C, 0x0, 0x10C, 0x4, 0x218;
    //0x001AF2F4, 0x80, 0x1C, 0x0, 0x10C, 0x4, 0x218;    
    //Jump counts from 0 up and is delayed
}
init{ //vars
    int splitnum;
    refreshRate = 70;
}
startup{ // Settings
    //Start-Trigger
    settings.Add("Start-Trigger", true, "Start-Trigger");
    settings.Add("Level 1+2", true, "Level 1+2", "Start-Trigger");
    settings.Add("FirstMove", false, "First Move", "Start-Trigger");
    settings.Add("OpenDoor", false, "Open Door", "Start-Trigger");

    //Split-Trigger
    settings.Add("Split-Trigger", true, "Split-Trigger");
    settings.Add("Level3Door", true, "Level 3 Door", "Split-Trigger");
    settings.Add("Level4Door", true, "Level 4 Door", "Split-Trigger");
    settings.Add("Level5Door", true, "Level 5 Door", "Split-Trigger");
    settings.Add("Level6Door", false, "Level 6 Door", "Split-Trigger");
    settings.Add("Level7Door", false, "Level 7 Door", "Split-Trigger");
    settings.Add("VanKlaus", true, "Van Klaus", "Split-Trigger");
    settings.Add("End", true, "End", "Split-Trigger");
    
    //Reset-Trigger
    settings.Add("Reset-Trigger", true, "Reset-Trigger");
    settings.Add("NewGame", true, "New Game", "Reset-Trigger");
    settings.Add("MainMenu", false, "Main Menu", "Reset-Trigger");
}
start{
    //Starts Timer after 95 / First Level after intro. And to not start again after reset it checks a few things :D
    if (settings["Level 1+2"]) { 
        if(current.LevelNumber==95 && current.LevelNumber != old.LevelNumber && old.LevelNumber != 93 && old.LevelNumber != 181){vars.splitnum=0; return true;}
    }
    //Starts Timer after Walking Double is not 0 - Walking is +3/-3, Sneaking is +-1, Jumping is +-5
    if (settings["FirstMove"]) { 
        if(current.Move != 0){vars.splitnum=0; return true;}
    }
    if (settings["OpenDoor"]) {
        if(current.Door1 != 0 || current.Door2 != 0){vars.splitnum=0; return true;}
    }
}
split{
    //Splits when opening Level 3 door
    if(vars.splitnum == 0 && settings["Level3Door"] && current.LevelNumber==103 && current.Door1 > 0){vars.splitnum++; return true;}
    if(vars.splitnum == 0 && settings["Level3Door"] == false){vars.splitnum++;}

    //Splits when opening Level 4 door
    if(vars.splitnum == 1 && settings["Level4Door"] && current.LevelNumber==109 && current.Door1 > 0){vars.splitnum++; return true;}
    if(vars.splitnum == 1 && settings["Level4Door"] == false){vars.splitnum++;}

    //Splits when opening Level 5 door
    if(vars.splitnum == 2 && settings["Level5Door"] && current.LevelNumber==66 && current.Door2 > 0){vars.splitnum++; return true;}
    if(vars.splitnum == 2 && settings["Level5Door"] == false){vars.splitnum++;}

    //Splits when opening Level 6 door
    if(vars.splitnum == 3 && settings["Level6Door"] && current.LevelNumber==89 && current.Door1 > 0){vars.splitnum++; return true;}
    if(vars.splitnum == 3 && settings["Level6Door"] == false){vars.splitnum++;}
    
    //Splits when opening Level 7 door
    if(vars.splitnum == 4 && current.LevelNumber==80 && current.Door1 > 0){vars.splitnum++; return true;}
    //Alternative for Skipping Level 7 Door
    if(vars.splitnum == 4 && settings["Level7Door"] && current.LevelNumber==170){vars.splitnum++; return true;}
    if(vars.splitnum == 4 && settings["Level7Door"] == false){vars.splitnum++;}

    //Splits when entering Van Klaus room
    if(vars.splitnum == 5 && settings["VanKlaus"] && current.LevelNumber==172){vars.splitnum++; return true;}
    if(vars.splitnum == 5 && settings["VanKlaus"] == false){vars.splitnum++;}

    //Split when timer is 9 before explotion
    if(vars.splitnum == 6 && settings["End"] && current.EndTimer == 9 && current.LevelNumber == 172){vars.splitnum++; return true;}
    if(vars.splitnum == 6 && settings["End"] == false){vars.splitnum++;}
}
reset{
    //Reset on New Game
    if(settings["NewGame"]){if(current.LevelNumber == 133){return true;}}
    //Reset on Main Menu
    if(settings["MainMenu"]){if(current.LevelNumber == 131){return true;}}
}
/* Pause if in a HUD or Menu
isLoading{
    if(current.HUD_Number != 2){return true;}
    else{return false;}
}*/
