float[] IKControl(float x, float y, float l1, float l2, float l ) {
  // Angle Variables
  float A;            //distance between end and root
  float B;            //upp arm length
  float gamma;        //offset angle of upp arm
  float phi;          //end point angle
  float alpha;        
  float beta;       
  float[] servoIKPos = new float[2];  
  


  
  A = sq(x)+sq(y);
  B = sq(l1)+sq(l);
  gamma = degrees(atan(l/l1));
  phi = degrees(atan( abs(y)/abs(x) ));
  alpha = degrees(acos( (A+B-sq(l2)) / (2*sqrt(A)*sqrt(B)) ));
  beta = degrees(acos( (B+sq(l2)-A) / (2*sqrt(B)*l2) ));

  //First Quadrant
  if (x >= 0 && y >= 0) {
    servoIKPos[0] = phi+gamma+alpha;  
    servoIKPos[1] = beta - 90 - alpha; 
    
   //Second Quadrant
  } else if (x < 0 && y >=0) {
    servoIKPos[0] = 180-(phi - alpha - gamma);
    servoIKPos[1] = beta - 90 - alpha;
  }
  
  
  return servoIKPos;
  
}


void IKDraw() {
  //x = x0 - cx; y = cy - y0
  //x0 = x+cx ; y0 = cy-y
  // x0 y0 is original axes, x y is offset axes
  //x0 = x+cx ; y0 = y+cy
  //x = x0-cx ; y = y0-cy
  upp.set(mouseX-orignal.x, orignal.y-mouseY);
  //println("up is "+upp);
  
  //End Point Drawing
  ellipse(mouseX, mouseY, ellipseR, ellipseR);
  servoAngle = IKControl(upp.x, upp.y, uppLength, downLength,mdLength);
  //printArray(servoAngle);
  down.x = downLength*cos(radians(servoAngle[0]));
  down.y = downLength*sin(radians(servoAngle[0]));
  line(orignal.x, orignal.y, down.x+orignal.x, orignal.y-down.y);
  line(mouseX, mouseY, down.x+orignal.x, orignal.y-down.y);
  //println("down is "+down);
  
  //Middle Point Drawing
  ellipse(down.x+orignal.x, orignal.y-down.y, ellipseR, ellipseR);
}


int[] angleMap(float [] ikAngle, int zAngle) {
  int[] dynaAngle = initState;
  //printArray(initState) ;
  dynaAngle[0] = int(map(ikAngle[0], -150, 150, 1023, 0));
  dynaAngle[1] = int(map(ikAngle[1], -150, 150, 0, 1023));
  dynaAngle[2] = zAngle;
  dynaAngle[3] = zAngle; 
  return dynaAngle;
}





