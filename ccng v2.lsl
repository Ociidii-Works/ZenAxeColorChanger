/*           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.

*/
//         For better readability, extend the size of the editor until this comment fits fully on one line.

//////// How to use ///////////

// See https://github.com/Ociidii-Works/ZenAxeColorChanger/blob/master/README.md

// user preferences //
float glowAmount = 0.08;        // How much glow
integer doColorRoot = 1;          // Needed for checking if we want to recolor the root prim
list primsToRecolor = [];           // Internal use, don't touch.

integer MessagesLevel = 0; /// Verbosity.

///////////////////////////////////////////////////////////////////
// internal variables, LEAVE THEM ALONE!! D:
vector color;                   // Internal use, don't touch.
vector originalColor;                  // original color of the prim
integer fp;                     // counter
integer isTyping;               // Typing indicator bit
integer x;                      // counter
integer primListLen;                // Length of the prim list. used for checks
integer cCheckID;               // color change bug fix for single prim
///////////////////////////////////////////////////////////////////


////////////////////// Custom Functions /////////////////////////


////// Debug system /////////
ErrorMessage(string message)
{
    if(MessagesLevel >= 1)
        llOwnerSay("E: " + message);
}
InfoMessage(string message)
{
    if(MessagesLevel >= 2)
        llOwnerSay("I: " + message);
}
DebugMessage(string message)
{
    if(MessagesLevel >= 3)
        llOwnerSay("D: " + message);
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
    <1, 0.4705882352941176, 0.2980392156862745>, // singularity
    <0.1803921568627451,0.3333333333333333,0.8823529411764706>, // smoothblue
    <0.607843137254902,0.972549019607843,1>, // arc
    <0.9803921568627451,0.3019607843137255,0.6862745098039216>, //hot pink
    <0.7725490196078431,0.3568627450980392,0.1725490196078431> // redhead
    ];

translateColor(string message)
{
    if(llToLower(message) == "glow red")
        runColorLoop(llList2Vector(colorList,0));
    else if(llToLower(message) == "glow dkred")
        runColorLoop(llList2Vector(colorList,1));
    else if(llToLower(message) == "glow orange")
        runColorLoop(llList2Vector(colorList,2));
    else if(llToLower(message) == "glow ltorange")
        runColorLoop(llList2Vector(colorList,3));
    else if(llToLower(message) == "glow dkorange")
        runColorLoop(llList2Vector(colorList,4));
    else if(llToLower(message) == "glow pink")
        runColorLoop(llList2Vector(colorList,5));
    else if(llToLower(message) == "glow blue")
        runColorLoop(llList2Vector(colorList,6));
    else if(llToLower(message) == "glow ltblue")
        runColorLoop(llList2Vector(colorList,7));
    else if(llToLower(message) == "glow dkblue")
        runColorLoop(llList2Vector(colorList,8));
    else if(llToLower(message) == "glow yellow")
        runColorLoop(llList2Vector(colorList,9));
    else if(llToLower(message) == "glow ltyellow")
        runColorLoop(llList2Vector(colorList,10));
    else if(llToLower(message) == "glow dkyellow")
        runColorLoop(llList2Vector(colorList,11));
    else if(llToLower(message) == "glow wjite")
        runColorLoop(llList2Vector(colorList,12));
    else if(llToLower(message) == "glow purple")
        runColorLoop(llList2Vector(colorList,13));
    else if(llToLower(message) == "glow ltpurple")
        runColorLoop(llList2Vector(colorList,14));
    else if(llToLower(message) == "glow dkpurple")
        runColorLoop(llList2Vector(colorList,15));
    else if(llToLower(message) == "glow green")
        runColorLoop(llList2Vector(colorList,16));
    else if(llToLower(message) == "glow ltgreen")
        runColorLoop(llList2Vector(colorList,17));
    else if(llToLower(message) == "glow dkgreen")
        runColorLoop(llList2Vector(colorList,18));
    else if(llToLower(message) == "glow black")
        runColorLoop(llList2Vector(colorList,19));
    else if(llToLower(message) == "glow ltgray")
        runColorLoop(llList2Vector(colorList,20));
    else if(llToLower(message) == "glow gray")
        runColorLoop(llList2Vector(colorList,21));
    else if(llToLower(message) == "glow dkgray")
        runColorLoop(llList2Vector(colorList,22));
    else if(llToLower(message) == "glow reactor")
        runColorLoop(llList2Vector(colorList,23));
    else if(llToLower(message) == "glow tron")
        runColorLoop(llList2Vector(colorList,24));
    else if(llToLower(message) == "glow corrupt")
        runColorLoop(llList2Vector(colorList,25));
    else if(llToLower(message) == "glow viral")
        runColorLoop(llList2Vector(colorList,26));
    else if (llToLower(message) == "glow violet")
        runColorLoop(llList2Vector(colorList,27));
    else if (llToLower(message) == "glow singularity")
        runColorLoop(llList2Vector(colorList,28));
    else if (llToLower(message) == "glow smoothblue")
        runColorLoop(llList2Vector(colorList,29));
    else if (llToLower(message) == "glow arc")
        runColorLoop(llList2Vector(colorList,30));
    else if (llToLower(message) == "glow hotpink")
        runColorLoop(llList2Vector(colorList,31));
    else if (llToLower(message) == "glow redhead")
        runColorLoop(llList2Vector(colorList,32));
    // end of list
    else if(llToLower(message) == "glow random")
            runColorLoop(<llFrand(1.0),llFrand(1.0),llFrand(1.0)>);
    else
    {
        llOwnerSay("Wrong color, or script is outdated! \n"+ "Get the latest version and usage information at https://github.com/Ociidii-Works/ZenAxeColorChanger !");
    }
    if(llGetFreeMemory() < 1000)
    {
        llOwnerSay("Running out of memory!\nResetting!");
        llResetScript();
    }
}

listPrims()
{
    if(llGetListLength(primsToRecolor) < 1)
    {
        for(fp = 0; fp <= llGetNumberOfPrims(); fp ++)
        {
            if(llToLower(llGetLinkName(fp)) == "colorprim")
            {
                primsToRecolor += fp;
            }
        }
    }
}
runColorLoop(vector runColor)
{
    DebugMessage("runColorLoop received "+ (string)runColor);
    if(doColorRoot == 1)
    {
        InfoMessage("Setting Root Color to: "+ (string)runColor);
        llSetColor(runColor,ALL_SIDES);
    }
    if(primListLen > 0)
    {
        integer i;
        for(i = 0; i <primListLen;)
        {
            // Set color
            llSetLinkPrimitiveParamsFast(llList2Integer(primsToRecolor, i),
                [PRIM_COLOR,ALL_SIDES,runColor,1.0,
                PRIM_GLOW,ALL_SIDES,glowAmount
                ]);
             i++;
        }
    }
}

/////////////////////////// Script Starts Here ///////////////////////////
default
{
    state_entry()
    {
        listPrims();
        primListLen = llGetListLength(primsToRecolor);
        InfoMessage("List Lenght: "+ (string)primListLen);
        llListen(9,"",llGetOwner(),"");
//      llSetMemoryLimit(llGetUsedMemory() + 4096);
        llSetTimerEvent(0.5);
    }
    // We re-use the listener system from what we are replacing,
    listen(integer channel, string name, key is, string message)
    {
        translateColor(message);
        InfoMessage(message);
    }
    timer()
    {
        llSetTimerEvent(0);
        if((llGetAgentInfo(llGetOwner())&AGENT_TYPING))
        {
            isTyping = 1;
            state typing;
        }
        else
        {
        isTyping = 0;
        DebugMessage((string)originalColor);
        llSetTimerEvent(0.5);
        }
    }
}
state typing
{
    state_entry()
    {
        originalColor = llList2Vector(llGetLinkPrimitiveParams(
        llList2Integer(primsToRecolor,0),[PRIM_COLOR,2]),0);
        llSetTimerEvent(0.2);
    }
    timer()
    {
        isTyping = 1;
        while((llGetAgentInfo(llGetOwner())&AGENT_TYPING))
        {
            // we don't use the translateColor() function here because it's too expansive
            vector newColor = <llFrand(1.0),llFrand(1.0),llFrand(1.0)>;
            runColorLoop(newColor);
        }
        if(isTyping)
        {
            isTyping = 0;
            llSleep(0.01);
            runColorLoop(originalColor);
            state default;
        } // end
    }
}
