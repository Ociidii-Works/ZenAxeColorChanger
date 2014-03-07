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
list primsToRecolor = [];       // Internal use, don't touch.

integer MessagesLevel = 0; /// Verbosity.

///////////////////////////////////////////////////////////////////
// internal variables, LEAVE THEM ALONE!! D:
key owner;                      // Owner, set in state_entry
integer primListLen;            // Length of the prim list. used for checks
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

vector random_color() { return <llFrand(1.0),llFrand(1.0),llFrand(1.0)>; }

translateColor(string message)
{
    message = llToLower(message);
    vector color;
    if(message == "glow red")
        color = <1.00000, 0.00000, 0.00000>;
    else if(message == "glow dkred")
        color = <0.31373, 0.00000, 0.00000>;
    else if(message == "glow orange")
        color = <1.00000, 0.50196, 0.00000>;
    else if(message == "glow ltorange")
        color = <1.00000, 0.80000, 0.40000>;
    else if(message == "glow dkorange")
        color = <0.70588, 0.25098, 0.00000>;
    else if(message == "glow pink")
        color = <1.00000, 0.40000, 0.40000>;
    else if(message == "glow blue")
        color = <0.00000, 0.00000, 1.00000>;
    else if(message == "glow ltblue")
        color = <0.40000, 1.00000, 1.00000>;
    else if(message == "glow dkblue")
        color = <0.00000, 0.00000, 0.31373>;
    else if(message == "glow yellow")
        color = <1.00000, 0.81961, 0.00000>;
    else if(message == "glow ltyellow")
        color = <1.00000, 1.00000, 0.40000>;
    else if(message == "glow dkyellow")
        color = <0.84314, 0.84314, 0.00000>;
    else if(message == "glow white")
        color = <1.00000, 1.00000, 1.00000>;
    else if(message == "glow purple")
        color = <0.50196, 0.00000, 0.50196>;
    else if(message == "glow ltpurple")
        color = <0.80000, 0.40000, 1.00000>;
    else if(message == "glow dkpurple")
        color = <0.25098, 0.00000, 0.50196>;
    else if(message == "glow green")
        color = <0.00000, 1.00000, 0.00000>;
    else if(message == "glow ltgreen")
        color = <0.50196, 1.00000, 0.00000>;
    else if(message == "glow dkgreen")
        color = <0.00000, 0.50196, 0.00000>;
    else if(message == "glow black")
        color = <0.00000, 0.00000, 0.00000>;
    else if(message == "glow ltgray")
        color = <0.60000, 0.60000, 0.60000>;
    else if(message == "glow gray")
        color = <0.40000, 0.40000, 0.40000>;
    else if(message == "glow dkgray")
        color = <0.20000, 0.20000, 0.20000>;
    else if(message == "glow reactor")
        color = <0.65490, 0.96863, 0.24314>;
    else if(message == "glow tron")
        color = <0.60784, 0.97255, 1.00000>;
    else if(message == "glow corrupt")
        color = <1.00000, 0.25098, 0.00000>;
    else if(message == "glow viral")
        color = <0.75294, 1.00000, 0.00000>;
    else if (message == "glow violet")
        color = <0.58431, 0.52549, 0.86667>;
    else if (message == "glow singularity")
        color = <1, 0.4705882352941176, 0.280392156862745>; // singularity
    else if (message == "glow smoothblue")
        color = <0.1803921568627451,0.3333333333333333,0.8823529411764706>; // smoothblue
    else if (message == "glow arc")
        color = <0.607843137254902,0.972549019607843,1>; // arc
    else if (message == "glow hotpink")
        color = <0.9803921568627451,0.3019607843137255,0.6862745098039216>; //hot pink
    else if (message == "glow redhead")
        color = <0.7725490196078431,0.3568627450980392,0.1725490196078431>; // redhead
    else if (message == "glow random")
        color = random_color();
    else
    {
        llOwnerSay("Wrong color, or script is outdated! \n"+ "Get the latest version and usage information at https://github.com/Ociidii-Works/ZenAxeColorChanger !");
        return;
    }
    setColor(color);

    if(llGetFreeMemory() < 1000)
    {
        llOwnerSay("Running out of memory!\nResetting!");
        llResetScript();
    }
}

listPrims()
{
    // Liru Note: Commented out code in this function has been optimized out, as this function is now called to refresh prim count
    primListLen = 0; //llGetListLength(primsToRecolor);
    //if (primListLen < 1)
    {
        integer fp = 0;                     // counter
        for(; fp <= llGetNumberOfPrims(); ++fp)
        {
            if(llToLower(llGetLinkName(fp)) == "colorprim") // Liru Note: Optimize out the llToLower call by naming in lowercase
            {
                primsToRecolor += fp;
                ++primListLen;
            }
        }
        //primListLen = llGetListLength(primsToRecolor);
    }
    InfoMessage("List Length: "+ (string)primListLen);
}
setColor(vector color)
{
    string stringcolor = (string)color;
    DebugMessage("setColor received "+ stringcolor);
    if(colorRoot == 1)
    {
        InfoMessage("Setting Root Color to: "+ stringcolor);
        llSetColor(color, ALL_SIDES);
        /* Liru Note: If we want the glow on the root, we could:
        llSetLinkPrimitiveParamsFast(LINK_ROOT, [PRIM_COLOR,ALL_SIDES,color,1.0, PRIM_GLOW,ALL_SIDES,glowAmount]);
        */
    }
    integer i = 0;
    for(; i < primListLen; ++i)
    {
        // Set color
        /* Liru Note: if glowAmount was 0, we could just:
            llSetLinkColor(llList2Integer(primsToRecolor, i), color, ALL_SIDES);
        */
        llSetLinkPrimitiveParamsFast(llList2Integer(primsToRecolor, i),
            [PRIM_COLOR,ALL_SIDES,color,1.0,
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
        translateColor(message);
        InfoMessage(message);
    }

    changed(integer change) { if (change & CHANGED_LINK) listPrims(); }

    timer()
    {
        if(llGetAgentInfo(owner) & AGENT_TYPING)
        {
            vector originalColor = llList2Vector(llGetLinkPrimitiveParams(llList2Integer(primsToRecolor,0),[PRIM_COLOR,2]),0);
            llSetTimerEvent(0.2);
            do
            {
                // we don't use the translateColor() function here because it's too expansive
                setColor(random_color());
                llSleep(0.01); // Liru Note: Should we even bother, Forced Delay from above call could be enough
            } while(llGetAgentInfo(owner) & AGENT_TYPING)
            setColor(originalColor);
        }
        else
        {
            //DebugMessage((string)originalColor); // Liru Note: We no longer hold onto original color, if it's really so important, get it here...
            llSetTimerEvent(0.5);
        }
    }
}
