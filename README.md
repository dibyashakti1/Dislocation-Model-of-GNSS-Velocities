# Okada-Dislocation-Model-of-GPS-Velocities

Dibyashakti Panda, January 2023

**The matlab codes help to model the observed velocities from GPS stations of both strike-slip and thrust faults by analyzing misfit between the Slip rate & Locking Depth (Based on methods by Okada 1992)**

**Matlab Files**: Dip_slip_Okada_Error and Strike_slip_Okada_Error


1. First Section: Visualizes horizontal geodetic motion at surface

2. Second Section: Generates the Okada dislocation model curve (or the slip rate deficit curve)

3. Third Section: Misfit analysis between the observed and modelled GPS velocities for dip-slip or strike-slip faults (Variable: Slip rate & Locking Depth ; Constant: Dip & Vertical Offset uY)

4. How to Run (Inputs)

   Load the GPS horizontal velocity file (At least contain Local distance from fault trace (in km), Fault normal/parallel velocity (in mm), and Error values) 
   
   Make sure to normalize the "Fault normal/parallel velocity" from zero.
   
   Input the number of observation points
   
   Dip of the fault plane (Prior knowledge is needed)
   
5. Run the code to obtain the output files (Two files containing the RMSE values and Okada Locking curve)





**The matlab codes help to model the observed velocities from GPS stations of both strike-slip and thrust faults by analyzing misfit between the Slip rate, Locking Depth, Fault Dip, and Vertical offset (Based on methods by Okada 1992)**

**Matlab Files**: Dip_slip_Okada_Error2 and Strike_slip_Okada_Error2

1. First Section: Same as previous set of routines

2. Second Section: Same as previous set of routines

3. Third Section: Misfit analysis between the observed and modelled GPS velocities for dip-slip or strike-slip faults (Variable: Slip rate, Locking Depth, Fault Dip & Vertical Offset uY)

4. How to Run (Inputs)

   Load the GPS horizontal velocity file (At least contain Local distance from fault trace (in km), Fault normal/parallel velocity (in mm), and Error values) 
   
   Make sure to normalize the "Fault normal/parallel velocity" from zero.
   
   Input the number of observation points
   


