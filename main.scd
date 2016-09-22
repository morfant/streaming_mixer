

(//slider 2D : 소리 크기와 속도를 조절하는 2D slider
var onebeat = 2.666666666666/4; // 4 * beat = 1 bar
var win, sli;
var timeMul = 1, ampMul = 100;


win = Window("Slider2D", Rect(100, 100, 600, 600));
sli = Slider2D(win, Rect(20, 20, 500, 500))
        .x_(1) // initial location of x
        .y_(0)   // initial location of y
        .action_({|sl|
            [\sliderX, sl.x, \sliderY, sl.y].postln;


        });
win.front;

a = Synth(\tak, [\susTime, 200, \amp, 30]);

)





