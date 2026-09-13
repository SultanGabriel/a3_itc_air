params [
    "_key",
    "_dir",
    "_long"
];

private _plane =
    vehicle player;

private _weapon =
    _plane getVariable [
        "itc_air_gbu15_activeWeapon",
        objNull
    ];

if (isNull _weapon) exitWith {};


/*
 * TMS
 */

if (_key isEqualTo "TMS") then {

    switch (_dir) do {

        /*
         * TMS UP short:
         * attempt TV lock.
         */

        case "UP":
        {
            if (!_long) then {
                call itc_air_gbu15_fnc_attemptLock;
            };
        };


        /*
         * TMS DOWN short:
         * MAN <-> GSTAB
         * LOCK -> GSTAB
         */

        case "DOWN":
        {
            if (!_long) then {
                call itc_air_gbu15_fnc_stabilise;
            };
        };
    };
};


/*
 * DMS
 */

if (_key isEqualTo "DMS") then {

    switch (_dir) do {

        /*
         * Narrow FOV.
         */

        case "UP":
        {
            _weapon setVariable [
                "itc_air_gbu15_fov",
                0.02
            ];
        };


        /*
         * Wide FOV.
         */

        case "DOWN":
        {
            _weapon setVariable [
                "itc_air_gbu15_fov",
                0.1
            ];
        };


        /*
         * Cycle slew rate.
         *
         * Same basic 5 -> 3 -> 1 -> 5
         * behavior as Maverick.
         */

        case "LEFT":
        {
            private _speed =
                _weapon getVariable [
                    "itc_air_gbu15_slewSpeed",
                    5
                ];

            _speed =
                if (_speed < 2) then {
                    5
                } else {
                    _speed - 2
                };

            _weapon setVariable [
                "itc_air_gbu15_slewSpeed",
                _speed
            ];
        };
    };
};