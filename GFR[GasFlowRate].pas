// PARAMS
//  - ORIFICE [inch]
//  - SPECIFIC GRAVITY [air=1]
//  - temperatrureERATERUE [f]
//  - PRESSURE [psig]
//  - DIFF [diff]
//  - CONSTANT1 - constant1 => 4.026
//  - CONSTANT2 - constant2 => 24

function ART_GASFLOWRATE(orifice, specific_gravity, temperature, pressure, diff, constant1 ,constant2 : real):real;
var
  sqr : real ;
  e, g1, g3, g5, g7 : real;
  fb, fg, ftf, y2, fpv, c, gfr : real;
  fpv1, fpv2, fpv3, fpv4, fpv5, fpv6, fpv7 : real;

begin

  // Get SQR
  if not (diff = 0) then
  begin
    sqr := exp(0.5 * ln((diff * pressure)));
  end;

  if not (orifice = 0) then
  begin // Start Orifice
    //  # Basic Orifice Factor #

    // Get E
    e := orifice*(830-5000*orifice/constant1+9000*exp(2 * ln(orifice/constant1))-4200*exp(3 * ln(orifice/constant1))+530/exp(0.5 * ln(constant1)));

    // Get G1
    g1 := 0.5993+0.007/constant1+(0.364+0.076/exp(0.5 * ln(constant1)))*exp(4 * ln(orifice/constant1));

    // Get G3
    g3 := 0;
    if((0.07+0.5/constant1-orifice/constant1) > 0) then
    begin
      g3 := 0.4*exp(0.5 * ln(1.6-1/constant1))*exp(2.5 * ln(0.07+0.5/constant1-orifice/constant1));
    end;

    // Get G5
    g5 := 0;
    if ((0.5-orifice/constant1) > 0) then
    begin
      g5 := (0.009+0.034/constant1)*(exp(1.5 * ln(0.5-orifice/constant1)));
    end;

    // Get G7
    g7 := 0;
    if ((orifice/constant1-0.7) > 0) then
    begin
      g7 :=(65/exp(2 * ln(constant1))+3)*exp(2.5 * ln(orifice/constant1-0.7));
    end;

    // # End of Basic Orifice Factor #

    // Get FB
    fb := 338.17*exp(2 * ln(orifice))*(g1+g3-g5+g7)/(1+15*e/(1000000*orifice));

    // Get FG
    if not (specific_gravity = 0) then
    begin
      fg := 1/exp(0.5 * ln(specific_gravity));
    end;

    // Get FTF
    if not (temperature = 0) then
    begin
      ftf := exp(0.5 * ln(520/(temperature+460)));
    end;

    // Get Y2
    if not (pressure = 0) then
    begin
      y2 := exp(0.5 * ln((1+diff/(pressure*27.7)))) - (0.41+(0.35 * (exp(4 * ln(orifice/constant1))))) * diff/(pressure*27.7) / (1.3*(exp(0.5 * ln((1+diff/(pressure*27.7))))));
    end;

    // Get FPV
    if not (pressure = 0) then
    begin
      fpv1 :=(temperature+460)/(170.491+307.344*specific_gravity);
      fpv2 :=(pressure+0.3)/(709.604-58.718*specific_gravity);
      fpv3 :=(0.27*fpv2)/(fpv1/0.99);
      fpv4 :=1+(0.2356+(-1.0467/fpv1)+(-0.5783/exp(3 * ln(fpv1))))*fpv3;
      fpv5 :=fpv4+(0.5353+(-0.6123/fpv1)+(0.6815/exp(3 *ln(fpv1))))*exp(2 * ln(fpv3));
      fpv6 :=1/fpv5;
      fpv7 := exp(0.5 * ln(fpv6));
      fpv := fpv7;
    end;

    // Get C
    if not (pressure = 0) then
    begin
      c := fb*fg*ftf*y2*fpv*(constant2/1000);
    end;

    // Get GFR [Gas Flow Rate]
    if not (pressure = 0) then
    begin
      gfr := sqr*c/1000;
    end;

  end; // end orifice

  // result GFR
  ART_GASFLOWRATE := gfr;

end;
