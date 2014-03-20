//             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//                     Version 2, December 2004
//
//  Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
//
//  Everyone is permitted to copy and distribute verbatim or modified
//  copies of this license document, and changing it is allowed as long
//  as the name is changed.
//
//             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//   0. You just DO WHAT THE FUCK YOU WANT TO.

// How to use //

// See https://github.com/Ociidii-Works/ZenAxeColorChanger/blob/master/README.md

// user preferences //
float g_glowAmount = 0.08;          // How much glow, negative for no change
integer g_colorRoot = TRUE;         // Needed for checking if we want to recolor the root prim
integer g_idleRandom = FALSE;        // Color cycles randomly at idle
integer g_idlePulse = FALSE;        // Pulse color at idle
integer g_MessagesLevel = 0;        // Verbosity.
list g_recolorNames = ["ColorPrim"];  // Name all recolorable prims here, case sensitive!
float g_count = 0;
float g_glow=0;
float g_inc=0.01;

// PREFERENCES ENDS HERE. DO NOT EDIT THE FOLLOWING SHIT UNLESS YOU KNOW WHAT THE FUCK YOU'RE DOING O.O //

// Conditional variables //


// internal variables //
integer g_primListLen = 0; // Length of the prim list.
key g_owner;
list g_originalColors = [];
list g_primsToRecolor = [];

// Debug system //
ErrorMessage(string message) { if (g_MessagesLevel >= 1) llOwnerSay("E: " + message); }
InfoMessage(string message)  { if (g_MessagesLevel >= 2) llOwnerSay("I: " + message); }
DebugMessage(string message) { if (g_MessagesLevel >= 3) llOwnerSay("D: " + message); }

// Custom Functions //

vector random_color() { return <llFrand(1.0), llFrand(1.0), llFrand(1.0)>; }

vector translateColor(string message)
{
    message = llToLower(message);
    if (llGetSubString(message, 0, 4) != "glow ") // Invalid message, only way to abort is to give bad color vector.
        jump end;
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
    @end;
    return <9.0, 9.0, 9.0>;
}

createPrimList()
{
    g_primsToRecolor = [];
    g_primListLen = 0;
    integer len = llGetNumberOfPrims();
    if (len == 1)
    {
        // one prim linksets use link number 0 for root
        if (g_colorRoot)
        {
            g_primsToRecolor += 0;
            g_primListLen = 1;
        }
    }
    else
    {
        // multi prim linksets use link number 1 for root
        integer fp = 1; // counter
        for(; fp <= len; ++fp)
        {
            // if link has a name we want add to recolor
            if (~llListFindList(g_recolorNames, [llGetLinkName(fp)]))
            {
                g_primsToRecolor += fp;
                ++g_primListLen;
            }
        }
        // fix this up when preprocessor is ready
        // LINK_ROOT is defined as 1
        if (g_colorRoot && !~llListFindList(g_primsToRecolor, [LINK_ROOT])) // User wants root
        {
            g_primsToRecolor += LINK_ROOT;
            ++g_primListLen;
        }
    }
    InfoMessage("List Length: " + (string)g_primListLen);
}

createOriginalColorList()
{
    g_originalColors = [];
    integer i = 0;
    for(; i < g_primListLen; i++)
    {
        integer link = llList2Integer(g_primsToRecolor, i);
        list originalData = llGetLinkPrimitiveParams(link, [PRIM_COLOR, ALL_SIDES, PRIM_GLOW, ALL_SIDES]);
        integer sides = llGetLinkNumberOfSides(link);
        integer j = 0;
        integer len = llGetListLength(originalData)/2;
        g_originalColors += [ PRIM_LINK_TARGET, link ];
        for(; j < sides; j++)
        {
            g_originalColors += [ PRIM_COLOR, j ] + llList2List(originalData, j*2, j*2+1);
            if (g_glowAmount >= 0.0)
                g_originalColors += [ PRIM_GLOW, j ] + llList2List(originalData, sides*2 + j, sides*2 + j);
        }
    }
}

setColor(vector color)
{
    if (color == <9.0,9.0,9.0>) return; // Minor hack
    list params = [];
    integer i = 0;
    for(; i < g_primListLen; ++i)
    {
        integer link = llList2Integer(g_primsToRecolor, i);
        params += [ PRIM_LINK_TARGET, link, PRIM_COLOR, ALL_SIDES, color, 1.0 ];
        if (g_glowAmount >= 0.0)
            params += [ PRIM_GLOW, ALL_SIDES, g_glowAmount ];
    }
    llSetLinkPrimitiveParamsFast(LINK_SET, params);
}

/////////////////////////// Script Starts Here ///////////////////////////
default
{
    state_entry()
    {
        llSetText("", ZERO_VECTOR, 0.0);
        g_owner = llGetOwner();
        createPrimList();
        createOriginalColorList();
        state idle;
    }
}

state idle
{
    state_entry()
    {
        llListen(9, "", g_owner, "");
        llSetTimerEvent(0.1);
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
            createPrimList();

        if (change & CHANGED_OWNER)
            llResetScript();
    }

    timer()
    {
        if (llGetAgentInfo(g_owner) & AGENT_TYPING)
        {
            state typing;
        }
        if (g_idleRandom)
            setColor(random_color());
        if (g_idlePulse)
        {
            g_glow+=g_inc;
                if ((g_glow>0.2)||(g_glow<0.01))
                {
                    g_inc=-g_inc;
                }
                llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_GLOW,ALL_SIDES,g_glow]);
        }
        if(g_MessagesLevel > 0)llSetText("Idle::"+(string)llGetUsedMemory()+" bytes used", <1,1,1>, 1.0);
    }
}

state typing
{
    state_entry()
    {
        createOriginalColorList();
        llSetTimerEvent(0.05);
    }

    timer()
    {
        if(g_MessagesLevel > 0)llSetText("Typing::"+(string)llGetUsedMemory()+" bytes used", <1,0.6,0.6>, 1.0);
        setColor(random_color());
        if(!(llGetAgentInfo(g_owner) & AGENT_TYPING))
        {
            llSetLinkPrimitiveParamsFast(LINK_SET, g_originalColors);
            state default;
        }
        if(g_MessagesLevel > 0)llSetText("Typing::"+(string)llGetUsedMemory()+" bytes used", <1,0.6,0.6>, 1.0);
    }
}