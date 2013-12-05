/*         For better readability, extend the size of the editor until this comment fits fully on one line.    */
/*  TODO
-Fix weird child prim lag when restoring ocolor.
- Make it faster? D: */
integer colorRoot = 1; // Needed for checking if we want to recolor the root prim
list foundPrims = []; // Internal use, don't touch.
vector color;       // Internal use, don't touch.
vector ocolor;
integer fp;         // Internal use, don't touch.
integer isTyping;   // Typing indicator bit
integer x;
string GetLinkDesc(integer link){
    return (string)llGetObjectDetails(llGetLinkKey(link), (list)OBJECT_DESC);}


blink(){
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.03);
            doColor(ocolor);
            llSleep(0.03);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.03);
            doColor(ocolor);
            llSleep(0.01);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.01);
            doColor(ocolor);
            llSleep(0.05);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.7);
            doColor(ocolor);
            llSleep(0.4);
            doColor(<1, 1, 1>);
            llSleep(0.08);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.05);
            doColor(ocolor);
            llSleep(0.01);
            doColor(<0, 0, 0>);
            llSleep(1);
            doColor(<1.00000, 0.25098, 0.00000>);
            llSleep(1);
            doColor(<0, 0, 0>);
            llSleep(1);
            doColor(<1.00000, 0.25098, 0.00000>);
            llSleep(1);
            doColor(<0, 0, 0>);
            llSleep(1);
            doColor(<1.00000, 0.25098, 0.00000>);
            llSleep(1);
            doColor(<0.60784, 0.97255, 1.00000>);
            llSleep(0.03);
            doColor(<0, 0, 0>);
            llSleep(0.1);
            doColor(<0.60784, 0.97255, 1.00000>);
            llSleep(0.05);
            doColor(<0, 0, 0>);
            llSleep(0.1);
            doColor(<0.60784, 0.97255, 1.00000>);
            llSleep(0.08);
            doColor(<0, 0, 0>);
            llSleep(2.5);
/*            doColor(ocolor);
            llSleep(0.2);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.1);
            doColor(ocolor);
            llSleep(0.15);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.1);
            doColor(ocolor);
            llSleep(0.12);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.1);
            doColor(ocolor);
            llSleep(0.1);
            doColor(<0.75294, 1.00000, 0.00000>);
            llSleep(0.1);
            doColor(ocolor);
            llSleep(0.08); */
            doColor(ocolor);
           x=0;
}
list colorList = [
    <1.00000, 0.00000, 0.00000>,
    <0.31373, 0.00000, 0.00000>,
    <1.00000, 0.50196, 0.00000>,
    <1.00000, 0.80000, 0.40000>,
    <0.70588, 0.25098, 0.00000>,
    <1.00000, 0.40000, 0.40000>,
    <0.00000, 0.00000, 1.00000>,
    <0.40000, 1.00000, 1.00000>,
    <0.00000, 0.00000, 0.31373>,
    <1.00000, 0.81961, 0.00000>,
    <1.00000, 1.00000, 0.40000>,
    <0.84314, 0.84314, 0.00000>,
    <1.00000, 1.00000, 1.00000>,
    <0.50196, 0.00000, 0.50196>,
    <0.80000, 0.40000, 1.00000>,
    <0.25098, 0.00000, 0.50196>,
    <0.00000, 1.00000, 0.00000>,
    <0.50196, 1.00000, 0.00000>,
    <0.00000, 0.50196, 0.00000>,
    <0.00000, 0.00000, 0.00000>,
    <0.60000, 0.60000, 0.60000>,
    <0.40000, 0.40000, 0.40000>,
    <0.20000, 0.20000, 0.20000>,
    <0.65490, 0.96863, 0.24314>,
    <0.60784, 0.97255, 1.00000>,
    <1.00000, 0.25098, 0.00000>,
    <0.75294, 1.00000, 0.00000>,
    <0.58431, 0.52549, 0.86667>,
    <1, 0.4705882352941176, 0.2980392156862745>
    ]
}
            }
colorit(string message){
        if(llToLower(message) == "glow red")
            llList2Vector(colorList,1);
        else if(llToLower(message) == "glow dkred")
            llList2Vector(colorList,2);
        else if(llToLower(message) == "glow orange")
            llList2Vector(colorList,3);
        else if(llToLower(message) == "glow ltorange")
            llList2Vector(colorList,4);
        else if(llToLower(message) == "glow dkorange")
            llList2Vector(colorList,5);
        else if(llToLower(message) == "glow pink")
            llList2Vector(colorList,6);
        else if(llToLower(message) == "glow blue")
            llList2Vector(colorList,7);
        else if(llToLower(message) == "glow ltblue")
            llList2Vector(colorList,8);
        else if(llToLower(message) == "glow dkblue")
            llList2Vector(colorList,9);
        else if(llToLower(message) == "glow yellow")
            llList2Vector(colorList,10);
        else if(llToLower(message) == "glow ltyellow")
            llList2Vector(colorList,11);
        else if(llToLower(message) == "glow dkyellow")
            llList2Vector(colorList,12);
        else if(llToLower(message) == "glow white")
            llList2Vector(colorList,13);
        else if(llToLower(message) == "glow purple")
            llList2Vector(colorList,14);
        else if(llToLower(message) == "glow ltpurple")
            llList2Vector(colorList,15);
        else if(llToLower(message) == "glow dkpurple")
            llList2Vector(colorList,16);
        else if(llToLower(message) == "glow green")
            llList2Vector(colorList,17);
        else if(llToLower(message) == "glow ltgreen")
            llList2Vector(colorList,18);
        else if(llToLower(message) == "glow dkgreen")
            llList2Vector(colorList,19);
        else if(llToLower(message) == "glow black")
            llList2Vector(colorList,20);
        else if(llToLower(message) == "glow ltgray")
            llList2Vector(colorList,21);
        else if(llToLower(message) == "glow gray")
            llList2Vector(colorList,22);
        else if(llToLower(message) == "glow dkgray")
            llList2Vector(colorList,23);
        else if(llToLower(message) == "glow reactor")
            llList2Vector(colorList,24);
        else if(llToLower(message) == "glow tron")
            llList2Vector(colorList,25);
        else if(llToLower(message) == "glow corrupt")
            llList2Vector(colorList,26);
        else if(llToLower(message) == "glow viral")
            llList2Vector(colorList,27);
        else if (llToLower(message) == "glow violet")
            llList2Vector(colorList,28);
        else if (llToLower(message) == "glow singularity")
            llList2Vector(colorList,29);
        else if(llToLower(message) == "glow random")
                color = <llFrand(1.0),llFrand(1.0),llFrand(1.0)>;

        else{
            color = llGetColor(0);}
        
//        llOwnerSay((string)color);
        doColor(color);
        if(llGetFreeMemory() < 1000){
            llOwnerSay("Running out of memory!\nResetting!");
            llResetScript();
        }
}

doColor(vector dcolor)
{
//    llOwnerSay((string)dcolor);
    integer i;
    for(i = 0; i < llGetListLength(foundPrims); i ++){
        // Set color
        llSetLinkColor(llList2Integer(foundPrims, i),dcolor, ALL_SIDES); }
        //  we do this to color the root prim if it contains
        // the name in the description
    if (colorRoot){
            llSetColor(dcolor, ALL_SIDES); }
}
default{
    state_entry(){
    if(llGetListLength(foundPrims) < 1){
        for(fp = 1; fp <= llGetNumberOfPrims(); fp ++){
            if(llGetLinkName(fp) == "ColorPrim"){
                foundPrims += fp;}
        }
    }
    llListen(9,"",llGetOwner(),"");
    llListen(9,"cycler","","");

    llSetMemoryLimit(llGetUsedMemory() + 4096);
    llSetTimerEvent(0.5);}
    // We re-use the listener system from what we are replacing,
    listen(integer channel, string name, key is, string message){
        if(message == "blink"){
            blink();
        }
    colorit(message);
    }
    timer(){
            llSetTimerEvent(0);
            if((llGetAgentInfo(llGetOwner())&AGENT_TYPING)){
                isTyping = 1;
                state typing;
            } // endif
        else{
            isTyping = 0;
            ocolor = llGetColor(0);}
            llSetTimerEvent(0.5);        
    } // end of timer
}
state typing{
    state_entry(){llSetTimerEvent(0.2);}
    timer(){
            ocolor = llGetColor(0);
                isTyping = 1;
                while((llGetAgentInfo(llGetOwner())&AGENT_TYPING)){
                    vector ncolor = <llFrand(1.0),llFrand(1.0),llFrand(1.0)>;
                    llSetColor(ncolor,ALL_SIDES);
                    llSleep(0.031);
                    integer i;
                    for(i = 0; i < llGetListLength(foundPrims); i ++){
                          // Set color
                        llSetLinkColor(
                            llList2Integer(foundPrims,i),
                            ncolor, ALL_SIDES);
                            llSleep(0.001);         }
                    }
             if(isTyping){
        isTyping = 0;
                llSetColor(ocolor,ALL_SIDES);
                integer i;
                for(i = 0; i < llGetListLength(foundPrims); i ++){
                    // Set color
//                    llSetColor(ocolor,ALL_SIDES);
                    llSetLinkColor(
                        llList2Integer(foundPrims,i),
                        ocolor, ALL_SIDES);
                } // end for
                state default;
            } // endif
        } // end
}
