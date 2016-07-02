_place   =   _this select 0; 
_points =   _this select 1;
_markername = _this select 2;
_markername2 = _this select 3;
_triggerPos = _this select 4;

amount_zones_captured = amount_zones_captured + 1;
publicVariable "amount_zones_captured";
["us_takencontrol",[_place]] call bis_fnc_showNotification;

// TELL THE ZONE IS UNDER BLU CONTROL
WARCOM_zones_controled_by_BLUFOR = WARCOM_zones_controled_by_BLUFOR + [_triggerPos];

// REMOVE A ZONE FROM OPFOR CONTROL
_index = 0;
{
    if ((_x select 0 == _triggerPos select 0) && (_x select 1 == _triggerPos select 1) && (_x select 2 == _triggerPos select 2)) exitWith {
        WARCOM_zones_controled_by_OPFOR set [_index,-1];
        WARCOM_zones_controled_by_OPFOR = WARCOM_zones_controled_by_OPFOR - [-1];
    }; 
    _index = _index + 1;
} forEach WARCOM_zones_controled_by_OPFOR;

// ADD POINTS
if (isServer) then {
    _points = round(_points/3);
    commandpointsblu1 = commandpointsblu1 + _points;
    publicVariable "commandpointsblu1";
};

// ADD NUMBER OF CONTROLLED ZONES
zoneundercontrolblu = zoneundercontrolblu + 1;
publicVariable "zoneundercontrolblu";

// MODIFY ARMY POWER
WARCOM_opfor_ap = WARCOM_opfor_ap + _points;
WARCOM_blufor_ap = WARCOM_blufor_ap + _points;
publicVariable "WARCOM_blufor_ap";

// ADD PERSISTENT STAT
_addzone = [] execVM "persistent\persistent_stats_zones_add.sqf";

// MODIFY MARKER ICON
str(_markername) setMarkerColor "ColorGreen";

// MODIFY MARKER ELLIPSE
str(_markername2) setMarkerColor "ColorGreen";

sleep 2;

["cpadded",[_points]] call bis_fnc_showNotification;

private "_trg";
// RECALL VARNAME FOR ZONE TRIGGER --> use the pos of the trigger
call compile format["_trg = trigger%1%2",round (_triggerPos select 0),round (_triggerPos select 1)];

//// MAKE THE TRIGGER CAPTURABLE FOR OPFOR
_trg setTriggerActivation["EAST SEIZED","PRESENT",true];
_trg setTriggerStatements["this", format["[""%1"",%2,""%3"",""%4"",%5] execvm 'zonescap\opfor_cap.sqf'",_place,_points,_markername,_markername2,_triggerPos], ""];