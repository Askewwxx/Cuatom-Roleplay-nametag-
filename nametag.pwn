#include <a_samp>
#include <streamer>
#include <foreach>
#include <YSI_Coding\y_hooks>

#define NT_DISTANCE 15.0

new Text3D:cNametag[MAX_PLAYERS];

hook OnGameModeInit()
{
    ShowNameTags(0); // Matikan nametag default SA-MP
    return 1;
}

hook OnPlayerConnect(playerid)
{
    cNametag[playerid] = CreateDynamic3DTextLabel("Loading...", 0xFFFFFFFF, 0.0, 0.0, 0.4, NT_DISTANCE, .attachedplayer = playerid, .testlos = 0);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    RefreshNametag(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(IsValidDynamic3DTextLabel(cNametag[playerid]))
        DestroyDynamic3DTextLabel(cNametag[playerid]);
    return 1;
}

stock FixName(name[])
{
    for(new i = 0; name[i] != '\0'; i++)
    {
        if(name[i] == '_')
            name[i] = ' ';
    }
}

stock RefreshNametag(playerid)
{
    if(!IsPlayerConnected(playerid)) return;

    new nametag[128];

    if(pData[playerid][pMaskOn] == 1)
    {
        format(nametag, sizeof(nametag), "{FFFFFF}Mask #%d", pData[playerid][pMaskID]);
    }
    else
    {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        FixName(name);
        format(nametag, sizeof(nametag), "{%06x}%s (%d)", GetPlayerColor(playerid) >>> 8, name, playerid);
    }

    if(IsValidDynamic3DTextLabel(cNametag[playerid]))
    {
        UpdateDynamic3DTextLabelText(cNametag[playerid], 0xFFFFFFFF, nametag);
    }
}