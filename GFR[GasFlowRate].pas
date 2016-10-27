//  reseter
      presure :=0;
      temp := 0;
      h2o := 0;
      orf := 0;
      gfr := 0;
    // :: [ART] new modify ::
      // :: Gas Flow Rate Added ::

         presure := strtofloat(UniStringGrid1.Cells[1,i]);
         temp := strtofloat(UniStringGrid1.Cells[2,i]);
         h2o := strtofloat(UniStringGrid1.Cells[3,i]);

        // var for testing
//        presure := 36.00;
//        temp := 65.0;
//        h2o := 22;

        // oriface
//        orf := 1.875;
        orf := strtofloat(UniStringGrid1.Cells[4,i]);

        // var $Q$9 and $Q10 value constant from excel
        q9 := 4.026;
        q10 := 24.000;

        // var S.G value from excel
        sg := 0.7550;

        // Get SQR
        if not (h2o=0) then
        begin
          sqr := exp(0.5 * ln((h2o * presure)));
        end;

        if not (orf=0) then
        begin
          // Basic Oriface Factor
            // E Value
//            ea1 := exp(2 * ln((orf/q9)));
//            ea := 830-5000*orf/q9+9000*ea1;
//            eb1 := exp(3 * ln((orf/q9)));
//            eb := ea - 4200*eb1;
//            ec1 := exp(0.5 * ln(q9));
//            ec := eb + 530 / ec1;
//            e := orf * ec;
            e := orf*(830-5000*orf/q9+9000*exp(2 * ln(orf/q9))-4200*exp(3 * ln(orf/q9))+530/exp(0.5 * ln(q9)));

            // G1 Value
            g1 := 0.5993+0.007/q9+(0.364+0.076/exp(0.5 * ln(q9)))*exp(4 * ln(orf/q9));

            // G3 Value
            g3 := 0;
            if((0.07+0.5/q9-orf/q9)>0) then
            begin
              g3 := 0.4*exp(0.5 * ln(1.6-1/q9))*exp(2.5 * ln(0.07+0.5/q9-orf/q9));
            end;

            // G5 Value
            g5 := 0;
            if ((0.5-orf/q9)>0) then
            begin
              g5 := (0.009+0.034/q9)*(exp(1.5 * ln(0.5-orf/q9)));
            end;

            // G7
            g7 := 0;
            if ((orf/q9-0.7)>0) then
            begin
              g7 :=(65/exp(2 * ln(q9))+3)*exp(2.5 * ln(orf/q9-0.7));
            end;
          // End of Basic Oriface Factor

          g1f:= strtofloat(formatFloat('0.00', g1));
          g3f:= strtofloat(formatFloat('0.00', g3));
          g5f:= strtofloat(formatFloat('0.00', g5));
          g7f:= strtofloat(formatFloat('0.00', g7));
          ef:= strtofloat(formatFloat('0.00', e));

          // FB Value
          fb := 338.17*exp(2 * ln(orf))*(g1+g3-g5+g7)/(1+15*e/(1000000*orf));
          fbf := strtofloat(formatFloat('0.0000', fb));
          //unilabel1.Caption := floattostr(g1)+'-'+floattostr(g3)+'-'+floattostr(g5)+'-'+floattostr(g7)+'-'+floattostr(e)+'-'+floattostr(fb);

          // FG Value
          if not (sg=0) then
          begin
            fg := 1/exp(0.5 * ln(sg));
          end;

          // FTF Value
          if not (temp=0) then
          begin
            ftf := exp(0.5 * ln(520/(temp+460)));
          end;

          // Y2 Value
          if not (presure = 0) then
          begin
            y2a := h2o/(presure*27.7);
            y2b := orf/q9;
//            y2c := exp(0.5 * ln((1+y2a)))-((0.41+(0.35*exp(4 * ln(y2b))))*y2)/(1.3*exp(0.5 * ln((1+y2a))));
            //y2c := exp(0.5 * ln((1+y2a))) - ( (0.41+(0.35 * exp(4 * ln(y2b)) ) ) * y2) / (1.3*exp(0.5 * ln((1+y2a))));
            y21 := exp(0.5 * ln((1+y2a)));
            //=(0.41+(0.35*(BR16^4)))*BQ16
            y22 :=  (0.41+(0.35 * (exp(4 * ln(y2b)))) ) * y2a;
            y23 := (1.3*(exp(0.5 * ln((1+y2a)))));

            y2c := y21 - y22 / y23;
            unilabel1.Caption := floattostr(y21)+'-'+floattostr(y22)+'-'+floattostr(y23)+'-'+floattostr(y2c);

            y2 := y2c;
          end;

          // FPV Value
          if not (presure = 0) then
          begin
            fpv1 :=(temp+460)/(170.491+307.344*sg);
            fpv2 :=(presure+0.3)/(709.604-58.718*sg);
            fpv3 :=(0.27*fpv2)/(fpv1/0.99);
            fpv4 :=1+(0.2356+(-1.0467/fpv1)+(-0.5783/exp(3 * ln(fpv1))))*fpv3;
            fpv5 :=fpv4+(0.5353+(-0.6123/fpv1)+(0.6815/exp(3 *ln(fpv1))))*exp(2 * ln(fpv3));
            fpv6 :=1/fpv5;
            fpv7 := exp(0.5 * ln(fpv6));
            fpv := fpv7;
          end;

          // C Value
          if not (presure = 0) then
          begin
          fbFormat := strtofloat(formatFloat('0.####', fb));
//          unilabel1.Caption := floattostr(fbFormat);
            c := fb*fg*ftf*y2*fpv*(q10/1000);
          end;

          // GFR [Gas Flow Rate] Value
          if not (presure = 0) then
          begin
            gfr := sqr*c/1000;
          end;

//          unilabel1.Caption := floattostr(fb)+'-'+floattostr(fg)+'-'+floattostr(ftf)+'-'+floattostr(y2)+'-'+floattostr(fpv)+'-'+floattostr(c);


        end;

      // :: [ART] End of modify ::
      UniStringGrid1.Cells[5,i]:=floattostr(gfr);
