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
	        // audioTTL, -1 to disable (does not expire the visual)
	        // canPreempt,
	        // acknowledgeMode,
	        // reservesAudio (optional, defaults to false)
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
	            A producer reports a discrete occurrence.
	            ACKNOWLEDGE removes its visual; playback alone does not.
	
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
		"NONE",
		true
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
		true,
		"NONE",
		true
	],

	[
		"ALTITUDE",
		70,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_ALTITUDE", true]
		],
		-1,
		-1,
		false,
		"SILENCE"
	],

	[
		"SPEED",
		80,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_SPEED", true]
		],
		2.0,
		0,
		false,
		"SILENCE"
	],

	[
		"TOO_LOW_GEAR",
		75,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_TOO_LOW_GEAR", true]
		],
		-1,
		-1,
		false,
		"SILENCE"
	],

	[
		"SINK_RATE",
		85,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_SINK_RATE", true]
		],
		-1,
		-1,
		false,
		"SILENCE"
	],

	[
		"STALL",
		85,
		"WARNING",
		"STATE",
		[
			["ITC_AIR_FWS_STALL", true]
		],
		-1,
		-1,
		false,
		"SILENCE"
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
		"STATE",
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
	    //     // audioTTL,
	    //     // canPreempt,
	    //     // acknowledgeMode
	    // ]
]
