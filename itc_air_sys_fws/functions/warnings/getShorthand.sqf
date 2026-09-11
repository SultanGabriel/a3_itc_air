params ["_id"];

private _defaultText =
    toUpper (
        (_id splitString "_")
            joinString " "
    );

switch (_id) do {
    case "PULL_UP": {
        "PULL UP"
    };

    case "TERRAIN": {
        "TERR"
    };

    case "ALTITUDE": {
        "ALT"
    };

    case "CHECK_GEAR": {
        "GEAR"
    };

    case "FUEL_BINGO": {
        "BINGO"
    };

    case "FUEL_LOW": {
        "FUEL"
    };

    case "AP_DISC": {
        "AP"
    };

    default {
        _defaultText select [
            0,
            5
        ]
    };
};