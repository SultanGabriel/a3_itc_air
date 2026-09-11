/*
	    ITC AIR Flight Warning System
	    Warning definitions.
	
	    Definition layout:
	    [
	        // id,
	        // priority,
	        // class,
	        // mode,
	        // audioSequence,
	        // repeatDelay,
	        // eventTTL, -1 to disable
	        // canPreempt,
	        // acknowledgeMode
	    ]
	
	    class:
	        "WARNING"
	        "CAUTION"
	        "ADVISORY"
	
	    mode:
	        "STATE"
	            The producer owns the warning lifetime.
	            The producer must clear the warning.
	
	        "EVENT"
	            The warning is temporary.
	            FWS removes it after playback, acknowledgement, or timeout.
	
	    acknowledgeMode:
	        "NONE"
	            ACK has no effect.
	
	        "SILENCE"
	            Warning stays active and displayed.
	            Audio is silenced until the warning condition clears.
	
	        "ACKNOWLEDGE"
	            Warning is acknowledged and no longer shown to the pilot.
	            STATE warnings remain internally active until the producer clears them.
	            EVENT warnings can be removed immediately.
*/

[
	[
		"PULL_UP",
		100,
		"WARNING",
		"STATE",
		[
			// ["ITC_AIR_FWS_250HZ", true],
			// ["ITC_AIR_FWS_250HZ", true],
			["ITC_AIR_FWS_PULL_UP_IMMEDIATE", true]
		],
		0.25,
		0,
		true,
		"NONE"
	],

	[
		"TERRAIN",
		90,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_CAUTION", true],
			["ITC_AIR_FWS_TOO_LOW_TERRAIN", true]
		],
		1.5,
		0,
		false,
		"NONE"
	],

	[
		"ALTITUDE",
		70,
		"WARNING",
		"EVENT",
		[
			["ITC_AIR_FWS_ALTITUDE", true]
		],
		-1,
		4.00,
		false,
		"ACKNOWLEDGE"
	],

	[
		"CHECK_GEAR",
		60,
		"CAUTION",
		"STATE",
		[
			["ITC_AIR_FWS_LANDING_GEAR", true]
		],
		-1,
		0,
		false,
		"SILENCE"
	],

	[
		"FUEL_BINGO",
		65,
		"CAUTION",
		"EVENT",
		[
			["ITC_AIR_FWS_BINGO_FUEL", true]
		],
		-1,
		-1,
		false,
		"SILENCE"
	],
	[
		"FUEL_LOW",
		75,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_FUEL_LOW", true]
		],
		-1,
		-1,
		false,
		"SILENCE"
	],

	[
		    "AP_DISC", 
		    55, 
		    "CAUTION", 
		    "EVENT", 
		    [                              
			["ITC_AIR_FWS_AP_DISC", true]
		],
		    -1, 
		    -1, 
		    false, 
		    "ACKNOWLEDGE"                   
	]
	    // Definition layout:
	    // [
	    //     // id,
	    //     // priority,
	    //     // class,
	    //     // mode,
	    //     // audioSequence,
	    //     // repeatDelay,
	    //     // eventTTL,
	    //     // canPreempt,
	    //     // acknowledgeMode
	    // ]
	
	    // [
		    //     "STALL"
	    // ] FIXME add stall too :3

	    // Advisory 

	    // [
		    //     "AIR_BRAKE",
		    //     30,
		    //     "ADVISORY",
		    //     "STATE",
		    //     [],
		    //     -1,
		    //     0,
		    //     false,
		    //     "NONE"
	    // ]
]