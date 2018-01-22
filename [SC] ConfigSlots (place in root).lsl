//list slot_name=["Description","bounciness","friction","density",];
// description contains param in this specific order [wheellock,gas,breaks,mouse/key,transmission,clickshift,perms]
// https://github.com/ShanaPearson/SC-config-slot

list slot1 =["1,10,10,0,0,0,1",0.0,0.800,2000.0];
list slot2 =["6,10,10,1,0,1,1",0.0,0.800,2000.0];
list slot3 =["5,1,1,0,0,0,1",0.0,0.800,2000.0];
list slot4 =["10,10,8,1,0,1,1",0.0,0.800,2000.0];

//==================================================================

integer listen_handler;
list buttons_main = ["Load","Get Config","Close"];
list buttons_slots = ["Slot1","Slot2","Slot3","Slot4","Close"];

integer menu_handler;
integer menu_channel;

// float to string from http://wiki.secondlife.com/wiki/Float2String
string Float2String ( float num, integer places, integer rnd) { 
//allows string output of a float in a tidy text format
//rnd (rounding) should be set to TRUE for rounding, FALSE for no rounding
 
    if (rnd) {
        float f = llPow( 10.0, places );
        integer i = llRound(llFabs(num) * f);
        string s = "00000" + (string)i; // number of 0s is (value of max places - 1 )
        if(num < 0.0)
            return "-" + (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
        return (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
    }
    if (!places)
        return (string)((integer)num );
    if ( (places = (places - 7 - (places < 1) ) ) & 0x80000000)
        return llGetSubString((string)num, 0, places);
    return (string)num;
}

menu(key user,string title,list buttons) {
    llListenRemove(menu_handler);
    menu_channel = (integer)(llFrand(99999.0) * -1);
    menu_handler = llListen(menu_channel,"","","");
    llDialog(user,title,buttons,menu_channel);
    llSetTimerEvent(60);    
}

load(list config)
{
    llSetLinkPrimitiveParamsFast(LINK_ROOT, [PRIM_DESC,llList2String(config,0)]);
    llSetPhysicsMaterial(RESTITUTION | FRICTION | DENSITY, 
                        1.0,
                        llList2Float(config,1),
                        llList2Float(config,2),
                        llList2Float(config,3)
                        );
                        
    llOwnerSay("config loaded");
}

dump()
{
 list tmp = llGetLinkPrimitiveParams(LINK_ROOT, [PRIM_DESC]);
 list phy = llGetPhysicsMaterial( );
 llOwnerSay("slotn=[\""+(string)tmp+"\","+Float2String(llList2Float(phy,1),3, FALSE)+","
                                        +Float2String(llList2Float(phy,2),3, FALSE)+","
                                        +Float2String(llList2Float(phy,3),3, FALSE)+","
                                        +Float2String(llList2Float(phy,4),3, FALSE)+"];"
                                        );
}

default
{
    
    state_entry()
    { 
     listen_handler = llListen(8200,"","","");   
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
            llResetScript();
    }
   
    timer() {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handler);    
    }
   
    listen(integer channel,string name,key id,string message) {
        
        if ((llGetOwner()==id) || (llDetectedKey(0)==llGetKey())) {
            
            if(message=="config")
            {
                menu(llGetOwner(),"[SC] config menu
                                   \n Load = load a preset from saved slot lists.
                                   \n Get Congif = Prints out the current config of the car.
                                   \n Close = Close the menu",buttons_main); 
            }
             if (message == "Load") {
                menu(llGetOwner(),"Select slot",buttons_slots);
                return;
            }   
            if (message == "Get Config") {
                dump();
                return;
            }   
            if (message == "Slot1") {
                llOwnerSay("loading Slot1");
                load(slot1);
                return;
            } 
            if (message == "Slot2") {
                llOwnerSay("loading Slot2");
                load(slot2);
                return;
            } 
            if (message == "Slot3") {
                llOwnerSay("loading Slot3");
                load(slot3);
                return;
            }   
            if (message == "Slot4") {
                llOwnerSay("loading Slot4");
                load(slot4);
                return;
            }       
            
        }
}
}
