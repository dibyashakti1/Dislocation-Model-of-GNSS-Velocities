# Okada-Dislocation-Model-of-GPS-Velocities

Dibyashakti Panda, January 2023

**The matlab codes help to model the observed velocities from GPS stations of both strike-slip and thrust faults by analyzing misfit between the Slip rate & Locking Depth (Based on methods by Okada 1992)**

**Examples are for a synthetic data of a dip slip fault**

**Matlab Files**: Dip_slip_Okada_Error and Strike_slip_Okada_Error


**1. First Section: Visualizes horizontal geodetic motion at surface**

**Horizontal geodetic motion at surface for a Dip slip fault**
![1](https://user-images.githubusercontent.com/123026357/234672044-90b6a743-19da-4df8-aa35-60ea0d9a7d6c.jpg)


**2. Second Section: Generates the Okada dislocation model curve (or the slip rate deficit curve)**

**Okada dislocation model curve (for fixed dip and slip rate)**
![2](https://user-images.githubusercontent.com/123026357/234673192-cc876352-d163-4ead-b83b-ebc04086b9a4.jpg)


**3. Third Section: Misfit analysis between the observed and modelled GPS velocities for dip-slip or strike-slip faults (Variable: Slip rate & Locking Depth ; Constant: Dip & Vertical Offset uY)**

**Misfit between Slip rate and Locking Depth**
![3](https://user-images.githubusercontent.com/123026357/234674028-24081cfe-8104-4de6-ab78-9888b6f62a17.jpg)

**Best fit Okada model (Fixed Dip and Varying Slip rate, Locking Depth)**
![5](https://user-images.githubusercontent.com/123026357/234674703-3cf85c7d-ef76-4e0b-9ce9-e8d34e32fb58.jpg)



**4. How to Run (Inputs)**

   Load the GPS horizontal velocity file (At least contain Local distance from fault trace (in km), Fault normal/parallel velocity (in mm), and Error values) 
   
   Make sure to normalize the "Fault normal/parallel velocity" from zero.
   
   Input the number of observation points
   
   Dip of the fault plane (Prior knowledge is needed)
   
**5. Run the code to obtain the output files (Two files containing the RMSE values and Okada Locking curve)**





**The matlab codes help to model the observed velocities from GPS stations of both strike-slip and thrust faults by analyzing misfit between the Slip rate, Locking Depth, Fault Dip, and Vertical offset (Based on methods by Okada 1992)**

**Matlab Files**: Dip_slip_Okada_Error2 and Strike_slip_Okada_Error2

**1. First Section: Same as previous set of routines**

**2. Second Section: Same as previous set of routines**

**3. Third Section: Misfit analysis between the observed and modelled GPS velocities for dip-slip or strike-slip faults (Variable: Slip rate, Locking Depth, Fault Dip & Vertical Offset uY)**

**4. How to Run (Inputs)**

   Load the GPS horizontal velocity file (At least contain Local distance from fault trace (in km), Fault normal/parallel velocity (in mm), and Error values) 
   
   Make sure to normalize the "Fault normal/parallel velocity" from zero.
   
   Input the number of observation points
   


