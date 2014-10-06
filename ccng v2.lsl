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
// https://github.com/Ociidii-Works/ZenAxeColorChanger/blob/master/README.md
// user preferences //
float g_glowAmount = 0.08;            // How much glow?
integer g_colorRoot = TRUE;           // Recolor root prim?
integer g_idleRandom = FALSE;         // Color cycles randomly at idle
integer g_idlePulse = TRUE;          // Pulse color at idle
list g_recolorNames = ["ColorPrim"];  // Prims to recolor. Case matters
float g_glow=0;
float g_inc=0.01;
// PREFERENCES END | DO NOT EDIT UNDER THIS UNLESS YOU KNOW WTF YOU'RE DOING
// internal variables //
integer g_primListLen = 0; // Length of the prim list.
key g_owner;
list g_originalColors = [];
list g_primsToRecolor = [];
integer has_controls = 0;
// Debug system //
integer g_MessagesLevel = 0;        // Verbosity.
ErrorMessage(string dm) { if (g_MessagesLevel >= 1) llOwnerSay("E: " + dm); }
InfoMessage(string dm)  { if (g_MessagesLevel >= 2) llOwnerSay("I: " + dm); }
DebugMessage(string dm) { if (g_MessagesLevel >= 3) llOwnerSay("D: " + dm); }
// Custom Functions //
vector random_color() { return <llFrand(1.0), llFrand(1.0), llFrand(1.0)>; }
vector translateColor(string m1)
{
    vector color=<9.0,9.0,9.0>;
    if (m1 == "red")
        color=<1.00000, 0.00000, 0.00000>;
    if (m1 == "dkred")
        color=<0.31373, 0.00000, 0.00000>;
    if (m1 == "orange")
        color=<1.00000, 0.50196, 0.00000>;
    if (m1 == "ltorange")
        color=<1.00000, 0.80000, 0.40000>;
    if (m1 == "dkorange")
        color=<0.70588, 0.25098, 0.00000>;
    if (m1 == "pink")
        color=<1.00000, 0.40000, 0.40000>;
    if (m1 == "blue")
        color=<0.00000, 0.00000, 1.00000>;
    if (m1 == "ltblue")
        color=<0.40000, 1.00000, 1.00000>;
    if (m1 == "dkblue")
        color=<0.00000, 0.00000, 0.31373>;
    if (m1 == "yellow")
        color=<1.00000, 0.81961, 0.00000>;
    if (m1 == "ltyellow")
        color=<1.00000, 1.00000, 0.40000>;
    if (m1 == "dkyellow")
        color=<0.84314, 0.84314, 0.00000>;
    if (m1 == "white")
        color=<1.00000, 1.00000, 1.00000>;
    if (m1 == "purple")
        color=<0.50196, 0.00000, 0.50196>;
    if (m1 == "ltpurple")
        color=<0.80000, 0.40000, 1.00000>;
    if (m1 == "dkpurple")
        color=<0.25098, 0.00000, 0.50196>;
    if (m1 == "green")
        color=<0.00000, 1.00000, 0.00000>;
    if (m1 == "ltgreen")
        color=<0.50196, 1.00000, 0.00000>;
    if (m1 == "dkgreen")
        color=<0.00000, 0.50196, 0.00000>;
    if (m1 == "black")
        color=<0.00000, 0.00000, 0.00000>;
    if (m1 == "ltgray")
        color=<0.60000, 0.60000, 0.60000>;
    if (m1 == "gray")
        color=<0.40000, 0.40000, 0.40000>;
    if (m1 == "dkgray")
        color=<0.20000, 0.20000, 0.20000>;
    if (m1 == "reactor")
        color=<0.65490, 0.96863, 0.24314>;
    if (m1 == "tron")
        color=<0.60784, 0.97255, 1.00000>;
    if (m1 == "corrupt")
        color=<1.00000, 0.25098, 0.00000>;
    if (m1 == "viral")
        color=<0.75294, 1.00000, 0.00000>;
    if (m1 == "violet")
        color=<0.58431, 0.52549, 0.86667>;
    if (m1 == "singularity")
        color=<1, 0.4705882352941176, 0.280392156862745>;
    if (m1 == "smoothblue")
        color=<0.1803921568627451,0.3333333333333333,0.8823529411764706>;
    if (m1 == "arc")
        color=<0.607843137254902,0.972549019607843,1>;
    if (m1 == "hotpink")
        color=<0.9803921568627451,0.3019607843137255,0.6862745098039216>;
    if (m1 == "redhead")
        color=<0.7725490196078431,0.3568627450980392,0.1725490196078431>;
    if (m1 == "polarity")
        color=<0.318, 0.514, 0.110>;
    if (m1 == "random")
        color=random_color();
    return color;
}
key_mode(integer on)
{
    if (on)
    {
        InfoMessage("Taking controls!");
         llRequestPermissions(g_owner, PERMISSION_TAKE_CONTROLS);
         has_controls = TRUE;
    }
    else
    {
        InfoMessage("Releasing controls!");
        llReleaseControls();
        has_controls = FALSE;
    }
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
    DebugMessage("Creating Original color list...");
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
        originalData = [];
    }
}
setGlow(float glow)
{
    list params = [];
    integer i = 0;
    for(; i < g_primListLen; ++i)
    {
        integer link = llList2Integer(g_primsToRecolor, i);
        params += [ PRIM_LINK_TARGET, link, PRIM_GLOW, ALL_SIDES, glow];
    }
    llSetLinkPrimitiveParamsFast(LINK_SET, params);
    params = [];
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
    params = [];
}
// Self Upgrading Script by Cron Stardust based upon work by Markov Brodsky and Jippen Faddoul.  
// If this code is used, these header lines MUST be kept.
upgrade() {
    //Get the name of the script
    string self = llGetScriptName();
    string basename = self;
    llOwnerSay("Index of space = "+(string)llSubStringIndex(self, " "));
    // If there is a space in the name, find out if it's a copy number and correct the basename.
    if (llSubStringIndex(self, " ") >= 0) {
        InfoMessage("Attempting Upgrade...");
        // Get the section of the string that would match this RegEx: /[ ][0-9]+$/
        integer start = 2; // If there IS a version tail it will have a minimum of 2 characters.
        string tail = llGetSubString(self, llStringLength(self) - start, -1);
        while (llGetSubString(tail, 0, 0) != " ") {
            start++;
            tail = llGetSubString(self, llStringLength(self) - start, -1);
        }
        // If the tail is a positive, non-zero number then it's a version code to be removed from the basename.
        if ((integer)tail > 0) {
            basename = llGetSubString(self, 0, -llStringLength(tail) - 1);
        }
    }
    // Remove all other like named scripts.
    integer n = llGetInventoryNumber(INVENTORY_SCRIPT);
    while (n-- > 0) {
        string item = llGetInventoryName(INVENTORY_SCRIPT, n);
        // Remove scripts with same name (except myself, of course)
        if (item != self && 0 == llSubStringIndex(item, basename)) {
            llRemoveInventory(item);
        }
    }
}
/////////////////////////// Script Starts Here ///////////////////////////
default
{
    state_entry()
    {
        DebugMessage("Entering state_entry");
        llSetText("", ZERO_VECTOR, 0.0);
        g_owner = llGetOwner();
        createPrimList();
        createOriginalColorList();
        llListen(9, "", g_owner, "");
        llSetTimerEvent(0.1);
        // llSetMemoryLimit(19096);
    }
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        createPrimList();
        if (change & CHANGED_OWNER)
        {
            llInstantMessage(llGetOwner(), "Owner changed! Restarting...");
            llResetScript();
        }
    }
    control(key id, integer level, integer edge)
    {
        DebugMessage("LEVEL = "+(string)level + " EDGE = "+(string)edge);
        if(edge > 0 | level > 0)
        {
            // Only do something if we press something. Paranoia.
            if(level == 1) // UP|W
            {
                setColor(translateColor("white"));
            }
            else if(level == 256) // LEFT|A
            {
                setColor(translateColor("red"));
            }
            else if(level == 2) // DOWN|S
            {
                setColor(translateColor("tron"));
            }
            else if(level == 512) // RIGHT|DS
            {
                setColor(translateColor("singularity"));
            }
            else if (level == 0 && edge > 0) // released all keys
            {
                setColor(translateColor("black"));
            }
        }
    }
    // We re-use the listener system from what we are replacing,
    listen(integer c, string s, key k, string m)
    {
        m = llToLower(m);
        if (llGetSubString(m, 0, 4) == "glow ")
        {
            m = llGetSubString(m, 5, -1);
            setColor(translateColor(m));
        }
        else
        {
            if (m == "take")
                key_mode(1);
            if (m == "release")
                key_mode(0);
        }
        InfoMessage(m);
    }
    timer()
    {
        DebugMessage("Entering timer event");
        llSetTimerEvent(0.0);
        if(llGetAgentInfo(g_owner) & AGENT_TYPING)
        {
            createOriginalColorList();
            while(llGetAgentInfo(g_owner) & AGENT_TYPING)
            {
                // Typing
                setColor(random_color());
                if(g_MessagesLevel > 0)llSetText("Typing::"+(string)llGetUsedMemory()+" bytes used", <1,0.6,0.6>, 1.0);
            }
            if(!(llGetAgentInfo(g_owner) & AGENT_TYPING))
            {
                llSetLinkPrimitiveParamsFast(LINK_SET, g_originalColors);
            }
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
            setGlow(g_glow);
        }
        if(g_MessagesLevel > 0)
        {
            if(has_controls)
                llSetText("KeyMode::"+(string)llGetUsedMemory()+" bytes used",
                <1,0.8,0.2>, 1.0);
            else llSetText("Idle::"+(string)llGetUsedMemory()+" bytes used",
                <1,1,1>, 1.0);
        }
        llSetTimerEvent(0.1);
    }
}
