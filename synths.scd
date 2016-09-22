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
    Out.ar(100, sig);
}).add;

)