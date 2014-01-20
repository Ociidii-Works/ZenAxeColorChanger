///////////////////////////////////////////////////////////////////////////
//  CCNG - Color Changer Next Gen by Miguael Liamano
///////////////////////////////////////////////////////////////////////////
//    This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
///////////////////////////////////////////////////////////////////////////
//         For better readability,
// extend the size of the editor until this comment fits fully on one line.



/*  TODO
- Make it faster? D:
*/

// user preferences //
float glowAmount = 0.08;        // How much glow
integer colorRoot = 1;          // Needed for checking if we want to recolor the root prim
list foundPrims = [];           // Internal use, don't touch.

integer MessagesLevel = 0; /// Verbosity.

///////////////////////////////////////////////////////////////////
// internal variables, LEAVE THEM ALONE!! D:
vector color;                   // Internal use, don't touch.
vector ocolor;                  // original color of the prim
integer fp;                     // counter
integer isTyping;               // Typing indicator bit
integer x;                      // counter
integer listLen;                // Length of the prim list. used for checks

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


string GetLinkDesc(integer link)
{
    return (string)llGetObjectDetails(llGetLinkKey(link), (list)OBJECT_DESC);
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

colorit(string message)
{
    if(llToLower(message) == "glow red")
        doColor(llList2Vector(colorList,0));
    else if(llToLower(message) == "glow dkred")
        doColor(llList2Vector(colorList,1));
    else if(llToLower(message) == "glow orange")
        doColor(llList2Vector(colorList,2));
    else if(llToLower(message) == "glow ltorange")
        doColor(llList2Vector(colorList,3));
    else if(llToLower(message) == "glow dkorange")
        doColor(llList2Vector(colorList,4));
    else if(llToLower(message) == "glow pink")
        doColor(llList2Vector(colorList,5));
    else if(llToLower(message) == "glow blue")
        doColor(llList2Vector(colorList,6));
    else if(llToLower(message) == "glow ltblue")
        doColor(llList2Vector(colorList,7));
    else if(llToLower(message) == "glow dkblue")
        doColor(llList2Vector(colorList,8));
    else if(llToLower(message) == "glow yellow")
        doColor(llList2Vector(colorList,9));
    else if(llToLower(message) == "glow ltyellow")
        doColor(llList2Vector(colorList,10));
    else if(llToLower(message) == "glow dkyellow")
        doColor(llList2Vector(colorList,11));
    else if(llToLower(message) == "glow wjite")
        doColor(llList2Vector(colorList,12));
    else if(llToLower(message) == "glow purple")
        doColor(llList2Vector(colorList,13));
    else if(llToLower(message) == "glow ltpurple")
        doColor(llList2Vector(colorList,14));
    else if(llToLower(message) == "glow dkpurple")
        doColor(llList2Vector(colorList,15));
    else if(llToLower(message) == "glow green")
        doColor(llList2Vector(colorList,16));
    else if(llToLower(message) == "glow ltgreen")
        doColor(llList2Vector(colorList,17));
    else if(llToLower(message) == "glow dkgreen")
        doColor(llList2Vector(colorList,18));
    else if(llToLower(message) == "glow black")
        doColor(llList2Vector(colorList,19));
    else if(llToLower(message) == "glow ltgray")
        doColor(llList2Vector(colorList,20));
    else if(llToLower(message) == "glow gray")
        doColor(llList2Vector(colorList,21));
    else if(llToLower(message) == "glow dkgray")
        doColor(llList2Vector(colorList,22));
    else if(llToLower(message) == "glow reactor")
        doColor(llList2Vector(colorList,23));
    else if(llToLower(message) == "glow tron")
        doColor(llList2Vector(colorList,24));
    else if(llToLower(message) == "glow corrupt")
        doColor(llList2Vector(colorList,25));
    else if(llToLower(message) == "glow viral")
        doColor(llList2Vector(colorList,26));
    else if (llToLower(message) == "glow violet")
        doColor(llList2Vector(colorList,27));
    else if (llToLower(message) == "glow singularity")
        doColor(llList2Vector(colorList,28));
    else if (llToLower(message) == "glow smoothblue")
        doColor(llList2Vector(colorList,29));
    else if (llToLower(message) == "glow arc")
        doColor(llList2Vector(colorList,30));
    else if (llToLower(message) == "glow hotpink")
        doColor(llList2Vector(colorList,31));
    else if (llToLower(message) == "glow redhead")
        doColor(llList2Vector(colorList,32));
    // end of list
    else if(llToLower(message) == "glow random")
            doColor(<llFrand(1.0),llFrand(1.0),llFrand(1.0)>);
    else
    {
        doColor(llGetColor(0));
    }
    if(llGetFreeMemory() < 1000)
    {
        llOwnerSay("Running out of memory!\nResetting!");
        llResetScript();
    }
}

listPrims()
{
    if(llGetListLength(foundPrims) < 1)
    {
        for(fp = 1; fp <= llGetNumberOfPrims(); fp ++)
        {
            if(llToLower(llGetLinkName(fp)) == "colorprim")
            {
                foundPrims += fp;
            }
        }
    }
}
doColor(vector dcolor)
{
     DebugMessage((string)dcolor);
    integer i;
    for(i = 0; i <listLen; i ++)
    {
        // Set color
        llSetLinkPrimitiveParamsFast(llList2Integer(foundPrims, i),
            [PRIM_COLOR,ALL_SIDES,dcolor,1.0,
            PRIM_GLOW,ALL_SIDES,glowAmount
            ]);
    }

    //  we do this to color the root prim if it contains
    // the name in the description
    if( llToLower(llGetObjectDesc()) == "colorprim")
    {
        llSetColor(dcolor, ALL_SIDES);
    }
}


/////////////////////////// Script Starts Here ///////////////////////////
default
{
    state_entry()
    {
        listPrims();
        listLen = llGetListLength(foundPrims);
        llListen(9,"",llGetOwner(),"");
//      llSetMemoryLimit(llGetUsedMemory() + 4096);
        llSetTimerEvent(0.5);
    }
    // We re-use the listener system from what we are replacing,
    listen(integer channel, string name, key is, string message)
    {
        colorit(message);
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
        DebugMessage((string)ocolor);
        llSetTimerEvent(0.5);
        }
    }
}
state typing
{
    state_entry()
    {
            ocolor = llList2Vector(llGetLinkPrimitiveParams(
                    llList2Integer(foundPrims,0),[PRIM_COLOR,ALL_SIDES]),0);
        llSetTimerEvent(0.2);
    }
    timer()
    {
        isTyping = 1;
        while((llGetAgentInfo(llGetOwner())&AGENT_TYPING))
        {
            vector ncolor = <llFrand(1.0),llFrand(1.0),llFrand(1.0)>;
            doColor(ncolor);
        }
        if(isTyping)
        {
            isTyping = 0;
            llSleep(0.01);
            doColor(ocolor);
            state default;
        } // end
    }
}
