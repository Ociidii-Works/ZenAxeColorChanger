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
float glowAmount = 0.08;        // How much glow, negative for no change
integer colorRoot = TRUE;       // Needed for checking if we want to recolor the root prim
integer MessagesLevel = 0;      // Verbosity.

///////////////////////////////////////////////////////////////////
// internal variables, LEAVE THEM ALONE!! D:
key owner;                      // Owner, set in state_entry
list primsToRecolor = [];       // Internal use, don't touch.
integer primListLen;            // Length of the prim list. used for checks
///////////////////////////////////////////////////////////////////


////////////////////// Custom Functions /////////////////////////


////// Debug system /////////
ErrorMessage(string message) { if (MessagesLevel >= 1) llOwnerSay("E: " + message); }
InfoMessage(string message)  { if (MessagesLevel >= 2) llOwnerSay("I: " + message); }
DebugMessage(string message) { if (MessagesLevel >= 3) llOwnerSay("D: " + message); }

vector random_color() { return <llFrand(1.0), llFrand(1.0), llFrand(1.0)>; }

vector translateColor(string message)
{
    message = llToLower(message);
    if (llGetSubString(message, 0, 4) != "glow ") // Invalid message, only way to abort is to give bad color vector.
        return <9,9,9>;
    if (message == "glow red")
        return <1.00000, 0.00000, 0.00000>;
    if (message == "glow dkred")
        return <0.31373, 0.00000, 0.00000>;
    if (message == "glow orange")
        return <1.00000, 0.50196, 0.00000>;
    if (message == "glow ltorange")
        return <1.00000, 0.80000, 0.40000>;
    if (message == "glow dkorange")
        return <0.70588, 0.25098, 0.00000>;
    if (message == "glow pink")
        return <1.00000, 0.40000, 0.40000>;
    if (message == "glow blue")
        return <0.00000, 0.00000, 1.00000>;
    if (message == "glow ltblue")
        return <0.40000, 1.00000, 1.00000>;
    if (message == "glow dkblue")
        return <0.00000, 0.00000, 0.31373>;
    if (message == "glow yellow")
        return <1.00000, 0.81961, 0.00000>;
    if (message == "glow ltyellow")
        return <1.00000, 1.00000, 0.40000>;
    if (message == "glow dkyellow")
        return <0.84314, 0.84314, 0.00000>;
    if (message == "glow white")
        return <1.00000, 1.00000, 1.00000>;
    if (message == "glow purple")
        return <0.50196, 0.00000, 0.50196>;
    if (message == "glow ltpurple")
        return <0.80000, 0.40000, 1.00000>;
    if (message == "glow dkpurple")
        return <0.25098, 0.00000, 0.50196>;
    if (message == "glow green")
        return <0.00000, 1.00000, 0.00000>;
    if (message == "glow ltgreen")
        return <0.50196, 1.00000, 0.00000>;
    if (message == "glow dkgreen")
        return <0.00000, 0.50196, 0.00000>;
    if (message == "glow black")
        return <0.00000, 0.00000, 0.00000>;
    if (message == "glow ltgray")
        return <0.60000, 0.60000, 0.60000>;
    if (message == "glow gray")
        return <0.40000, 0.40000, 0.40000>;
    if (message == "glow dkgray")
        return <0.20000, 0.20000, 0.20000>;
    if (message == "glow reactor")
        return <0.65490, 0.96863, 0.24314>;
    if (message == "glow tron")
        return <0.60784, 0.97255, 1.00000>;
    if (message == "glow corrupt")
        return <1.00000, 0.25098, 0.00000>;
    if (message == "glow viral")
        return <0.75294, 1.00000, 0.00000>;
    if (message == "glow violet")
        return <0.58431, 0.52549, 0.86667>;
    if (message == "glow singularity")
        return <1, 0.4705882352941176, 0.280392156862745>;
    if (message == "glow smoothblue")
        return <0.1803921568627451,0.3333333333333333,0.8823529411764706>;
    if (message == "glow arc")
        return <0.607843137254902,0.972549019607843,1>;
    if (message == "glow hotpink")
        return <0.9803921568627451,0.3019607843137255,0.6862745098039216>;
    if (message == "glow redhead")
        return <0.7725490196078431,0.3568627450980392,0.1725490196078431>;
    if (message == "glow random")
        return random_color();
    return <9, 9, 9>;
}

listPrims()
{
    primListLen = 0;
    list recolorNames = ["colorprim"];  // Name all recolorable prims here, case sensitive!
    integer fp = 0;                     // counter
    for(; fp <= llGetNumberOfPrims(); ++fp)
    {
        if (llListFindList(recolorNames, [llGetLinkName(fp)]) != -1)
        {
            primsToRecolor += fp;
            ++primListLen;
        }
    }
    if (colorRoot && llListFindList(primsToRecolor, [LINK_ROOT]) == -1) // User wants root, but not in the list
        primsToRecolor += LINK_ROOT;
    InfoMessage("List Length: " + (string)primListLen);
}

setColor(vector color)
{
    if (color == <9,9,9>) return; // Minor hack
    integer i = 0;
    for(; i < primListLen; ++i)
    {
        integer link = llList2Integer(primsToRecolor, i);
        // Set color
        if (link == LINK_ROOT || glowAmount < 0) // Don't glow root, negative glow is no change
        {
            if (link == LINK_ROOT) InfoMessage("Setting Root Color to: " + (string)color);
            llSetLinkColor(link, color, ALL_SIDES);
        }
        else
        {
            llSetLinkPrimitiveParamsFast(link,
                [PRIM_COLOR,ALL_SIDES,color,1.0,
                PRIM_GLOW,ALL_SIDES,glowAmount
                ]);
        }
    }
}

/////////////////////////// Script Starts Here ///////////////////////////
default
{
    state_entry()
    {
        owner = llGetOwner();
        listPrims();
        llListen(9, "", owner, "");
//      llSetMemoryLimit(llGetUsedMemory() + 4096);
        llSetTimerEvent(0.5);
    }

    // We re-use the listener system from what we are replacing,
    listen(integer channel, string name, key is, string message)
    {
        setColor(translateColor(message));
        InfoMessage(message);
    }

    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            primsToRecolor = [];
            listPrims();
        }
    }

    timer()
    {
        if (llGetAgentInfo(owner) & AGENT_TYPING)
        {
            list originalColors;
            integer i = 0;
            for (; i < primListLen; ++i)
            {
                list mew = llGetLinkPrimitiveParams(llList2Integer(primsToRecolor, i), [PRIM_COLOR,ALL_SIDES]);
                integer mewlen = llGetListLength(mew);
                integer j = 0;
                for (; j < mewlen; j+=2) // mew is strided by two
                    originalColors += [PRIM_COLOR, j] + llList2List(mew, j, j+1);
                originalColors += "RawR"; // Delimiter
            }
            do
            {
                setColor(random_color());
                llSleep(0.01); // Liru Note: Should we even bother, Forced Delay from above call could be enough
            } while(llGetAgentInfo(owner) & AGENT_TYPING);
            DebugMessage(llDumpList2String(originalColors, "  |  "));
            for (i = 0; i < primListLen; ++i)
            {
                integer j = llListFindList(originalColors, ["RawR"]);
                llSetLinkPrimitiveParamsFast(llList2Integer(primsToRecolor, i), llList2List(originalColors, 0, j - 1));
                originalColors = llDeleteSubList(originalColors, 0, j);
            }
        }
    }
}
