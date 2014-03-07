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
integer colorRoot = 1;          // Needed for checking if we want to recolor the root prim
list foundPrims = [];           // Internal use, don't touch.

integer MessagesLevel = 0; /// Verbosity.

///////////////////////////////////////////////////////////////////
// internal variables, LEAVE THEM ALONE!! D:
key owner;                      // Owner, set in state_entry
integer listLen;                // Length of the prim list. used for checks
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


string GetLinkDesc(integer link)
{
    return (string)llGetObjectDetails(llGetLinkKey(link), [OBJECT_DESC]);
}

// Liru Note: This list is only used by colorit(), it can be optimized out by hardcoding the colors inside there.
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

vector random_color() { return <llFrand(1.0),llFrand(1.0),llFrand(1.0)>; }

colorit(string message)
{
    message = llToLower(message);
    if(message == "glow red")
        doColor(llList2Vector(colorList,0));
    else if(message == "glow dkred")
        doColor(llList2Vector(colorList,1));
    else if(message == "glow orange")
        doColor(llList2Vector(colorList,2));
    else if(message == "glow ltorange")
        doColor(llList2Vector(colorList,3));
    else if(message == "glow dkorange")
        doColor(llList2Vector(colorList,4));
    else if(message == "glow pink")
        doColor(llList2Vector(colorList,5));
    else if(message == "glow blue")
        doColor(llList2Vector(colorList,6));
    else if(message == "glow ltblue")
        doColor(llList2Vector(colorList,7));
    else if(message == "glow dkblue")
        doColor(llList2Vector(colorList,8));
    else if(message == "glow yellow")
        doColor(llList2Vector(colorList,9));
    else if(message == "glow ltyellow")
        doColor(llList2Vector(colorList,10));
    else if(message == "glow dkyellow")
        doColor(llList2Vector(colorList,11));
    else if(message == "glow wjite")
        doColor(llList2Vector(colorList,12));
    else if(message == "glow purple")
        doColor(llList2Vector(colorList,13));
    else if(message == "glow ltpurple")
        doColor(llList2Vector(colorList,14));
    else if(message == "glow dkpurple")
        doColor(llList2Vector(colorList,15));
    else if(message == "glow green")
        doColor(llList2Vector(colorList,16));
    else if(message == "glow ltgreen")
        doColor(llList2Vector(colorList,17));
    else if(message == "glow dkgreen")
        doColor(llList2Vector(colorList,18));
    else if(message == "glow black")
        doColor(llList2Vector(colorList,19));
    else if(message == "glow ltgray")
        doColor(llList2Vector(colorList,20));
    else if(message == "glow gray")
        doColor(llList2Vector(colorList,21));
    else if(message == "glow dkgray")
        doColor(llList2Vector(colorList,22));
    else if(message == "glow reactor")
        doColor(llList2Vector(colorList,23));
    else if(message == "glow tron")
        doColor(llList2Vector(colorList,24));
    else if(message == "glow corrupt")
        doColor(llList2Vector(colorList,25));
    else if(message == "glow viral")
        doColor(llList2Vector(colorList,26));
    else if (message == "glow violet")
        doColor(llList2Vector(colorList,27));
    else if (message == "glow singularity")
        doColor(llList2Vector(colorList,28));
    else if (message == "glow smoothblue")
        doColor(llList2Vector(colorList,29));
    else if (message == "glow arc")
        doColor(llList2Vector(colorList,30));
    else if (message == "glow hotpink")
        doColor(llList2Vector(colorList,31));
    else if (message == "glow redhead")
        doColor(llList2Vector(colorList,32));
    // end of list
    else if (message == "glow random")
            doColor(random_color());
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
    // Liru Note: Commented out code in this function has been optimized out, as this function is now called to refresh prim count
    listLen = 0; //llGetListLength(foundPrims);
    //if (listLen < 1)
    {
        integer fp = 0;                     // counter
        for(; fp <= llGetNumberOfPrims(); ++fp)
        {
            if(llToLower(llGetLinkName(fp)) == "colorprim") // Liru Note: Optimize out the llToLower call by naming in lowercase
            {
                foundPrims += fp;
                ++listLen;
            }
        }
        //listLen = llGetListLength(foundPrims);
    }
    InfoMessage("List Length: "+ (string)listLen);
}
doColor(vector dcolor)
{
    string stringdcolor = (string)dcolor;
    DebugMessage("doColor "+ stringdcolor);
    if(colorRoot == 1)
    {
        InfoMessage("Setting Root Color to: "+ stringdcolor);
        llSetColor(dcolor,ALL_SIDES);
        /* Liru Note: If we want the glow on the root, we could:
        llSetLinkPrimitiveParamsFast(LINK_ROOT, [PRIM_COLOR,ALL_SIDES,dcolor,1.0, PRIM_GLOW,ALL_SIDES,glowAmount]);
        */
    }
    integer i = 0;
    for(; i < listLen; ++i)
    {
        // Set color
        /* Liru Note: if glowAmount was 0, we could just:
            llSetLinkColor(llList2Integer(foundPrims, i), dcolor, ALL_SIDES);
        */
        llSetLinkPrimitiveParamsFast(llList2Integer(foundPrims, i),
            [PRIM_COLOR,ALL_SIDES,dcolor,1.0,
            PRIM_GLOW,ALL_SIDES,glowAmount
            ]);
    }
}

/////////////////////////// Script Starts Here ///////////////////////////
default
{
    state_entry()
    {
        owner = llGetOwner();
        listPrims();
        llListen(9,"",owner,"");
//      llSetMemoryLimit(llGetUsedMemory() + 4096);
        llSetTimerEvent(0.5);
    }
    // We re-use the listener system from what we are replacing,
    listen(integer channel, string name, key is, string message)
    {
        colorit(message);
        InfoMessage(message);
    }

    changed(integer change) { if (change & CHANGED_LINK) listPrims(); }

    timer()
    {
        if(llGetAgentInfo(owner) & AGENT_TYPING)
        {
            vector ocolor = llList2Vector(llGetLinkPrimitiveParams(llList2Integer(foundPrims,0),[PRIM_COLOR,2]),0);
            llSetTimerEvent(0.2);
            do
            {
                // we don't use the colorit() function here because it's too expansive
                doColor(random_color());
                llSleep(0.01); // Liru Note: Should we even bother, Forced Delay from above call could be enough
            } while(llGetAgentInfo(owner) & AGENT_TYPING)
            doColor(ocolor);
        }
        else
        {
            //DebugMessage((string)ocolor); // Liru Note: We no longer hold onto original color, if it's really so important, get it here...
            llSetTimerEvent(0.5);
        }
    }
}
