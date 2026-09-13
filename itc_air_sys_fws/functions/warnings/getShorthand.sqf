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

    case "TOO_LOW_GEAR": {
        "GEAR"
    };

    case "SINK_RATE": {
        "SINK"
    };

    case "STALL": {
        "STALL"
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
