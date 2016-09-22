(
SynthDef(\micin, {
    | out = 60, amp = 0, gate = 1,
    ths = 0.3, slB = 1, slA = 0.7, clpTime = 0.01, relTime = 0.1 |
    var sig, compSig;
    sig = SoundIn.ar(0);
    compSig = Compander.ar(
        in: sig,
        thresh: ths,
        slopeBelow: slB,
        slopeAbove: slA,
        clampTime: clpTime,
        relaxTime: relTime
    );
    Out.ar(out, Pan2.ar(compSig, 0, amp));
}).add;



SynthDef(\mixer, {
    | out = 0, gate = 1, amp = 0.8, pan = 0,
    amp0 = 1, amp1 = 1, amp2 = 1, amp3 = 1, amp4 = 1, amp5 = 1, amp6 = 1,
    pan0 = 0, pan1 = 0, pan2 = 0, pan3 = 0, pan4 = 0, pan5 = 0, pan6 = 0,
    ths = 0.5, slB = 1, slA = 1, clpTime = 0.01, relTime = 0.1 |

	var sig0, sig1, sig2, sig3, sig4, sig5, sig6, sumSig, compSig, env;
    sig0 = Pan2.ar(In.ar(98, 2), pan0, amp0);
    sig1 = Pan2.ar(In.ar(100, 2), pan1, amp1);
    sig2 = Pan2.ar(In.ar(102, 2), pan2, amp2);
    sig3 = Pan2.ar(In.ar(104, 2), pan3, amp3);
    sig4 = Pan2.ar(In.ar(106, 2), pan4, amp4);
    sig5 = Pan2.ar(In.ar(108, 2), pan5, amp5);
    sig6 = Pan2.ar(In.ar(110, 2), pan6, amp6);

    env = EnvGen.kr(Env.asr(0.01, 1, 1), gate, doneAction: 2);
    sumSig = Mix.ar([sig0, sig1, sig2, sig3, sig4, sig5, sig6]);
    compSig = Compander.ar(
        in: sumSig,
        thresh: ths,
        slopeBelow: slB,
        slopeAbove: slA,
        clampTime: clpTime,
        relaxTime: relTime
    );
    Out.ar(out, Pan2.ar(compSig*env, pan, amp));
}).add;



SynthDef("urlRead", { |bufnum = 0|
    var sig, wibble;
    sig = DiskIn.ar(2, bufnum);
    //     wibble = LFPar.kr(0.1).range(0.5, 2.0);
    //     son = PitchShift.ar(son, pitchRatio: wibble);
    Out.ar(0, sig);
}).add;

)



//GUI
(
var win, urlText, strObjs, strBufs, strSyn, buttons,
trackNum = 8,
lineInterval = 60,
func_strConnect, func_strDisConnect;

urlText = Array.newClear(trackNum);
buttons = Array.newClear(trackNum);
strObjs = Array.newClear(trackNum);
strBufs = Array.newClear(trackNum);
strSyn = Array.newClear(trackNum);

win = Window("stream mixer", Rect(100, 100, 600, 600));


// Functions
func_strConnect = {|idx, url, isOgg|
    idx.postln;
    url.postln;
    isOgg.postln;

    if (isOgg == true, {
        strObjs[idx] = MP3(url, \readurl, \ogg);
    }, {
        strObjs[idx] = MP3(url, \readurl, \mp3);
    });

    strObjs[idx].start;

    strBufs[idx] = Buffer.cueSoundFile(s, strObjs[idx].fifo, 0, 2);
    strSyn[idx] = Synth("urlRead", [\bufnum, strBufs[idx].bufnum], addAction:\addToTail);

};


func_strDisConnect = {|idx|

    strObjs[idx].stop;
    strSyn[idx].free;
    strBufs[idx].close;strBufs[idx].free;
    strObjs[idx].finish;

};

// URL textfield
trackNum .do{| i |
    urlText[ i ] = TextField(win, Rect(10, 10 + (i * lineInterval), 400, 20));
    urlText[ i ].action = {| content |
        content.value.postln;
    };
};

// On/off Button
trackNum .do{| i |
    buttons[ i ] = Button(win, Rect(420, 10 + (i * lineInterval), 30, 20));
    buttons[ i ].states_([
            ["off", Color.white, Color.black],
            ["on", Color.black, Color.red]
        ])
        .action_({ arg butt;


        var isOgg, splitedArr;

        if (butt.value == 1, {

            // turn ON
            "turn ON".postln;
            splitedArr = urlText[i].value.split($.);

            isOgg = false;
            if (splitedArr[splitedArr.size-1] == "ogg", {isOgg = true});

            func_strConnect.value(i, urlText[ i ].value, isOgg);

        }, {
            // turn OFF
            "turn OFF".postln;
            func_strDisConnect.value(i);
        });



        });
};


// Initialize
urlText[0].value = "http://weatherreport.kr:8000/weatherreport_test.ogg";

urlText[1].value = "http://locus.creacast.com:9001/wave_farm_pond_station_new_york.mp3";


win.front;

)





