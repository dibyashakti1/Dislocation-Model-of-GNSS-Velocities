# Dislocation-Model-of-GNSS-Velocities

Dibyashakti Panda, January 24, 2025

**The Matlab codes help to model the observed velocities from GNSS stations of both strike-slip and dip-slip faults by analyzing the misfit between the observed fault slip rate & fault locking depth (Based on methods by Okada 1992)**


**Matlab Files**: Dip_slip_Dislocation_model and Strike_slip_Dislocation_model

**Examples are for synthetic data of a Dip slip fault**

**1. First Section: Locate the input file**

**Observed Displacement**
![1](https://github.com/user-attachments/assets/e2475de6-16a2-4771-96b7-6892064d246d)


**2. Second Section: Exclusion of one or more points from the observed data**
![2](https://github.com/user-attachments/assets/425f686a-741f-4fd3-bfa8-54c96d623213)


**3. Third Section: Final displacement and RMSE misfit**
![3](https://github.com/user-attachments/assets/69f49c1b-3e92-4a8c-8095-233bdcac533b)


**4. Fourth Section: Plot the outputs**
![5](https://github.com/user-attachments/assets/4e503900-49c0-49cb-9908-c84640b77e25)

![6](https://github.com/user-attachments/assets/72990820-71b3-4465-86c3-c1d8d574f10a)


**5. Fifth Section: Save the outputs**
Two files containing the RMSE values and Okada Locking curve

**6. How to Run (Inputs)**

   Load the GPS horizontal velocity file (At least contain Local distance from fault trace (in km), Fault normal/parallel velocity (in mm), and Error-values) 
   
   Dip of the fault plane (Prior knowledge is needed)


**Run: Dip_slip_Dislocation_model2.m**

**The Matlab codes help to model the observed velocities from GNSS stations of both strike-slip and dip-slip faults by analyzing the misfits between the fault slip rate, fault locking Depth, Dip, and Vertical offset (Based on methods by Okada 1992)**

**Matlab Files**: Dip_slip_Dislocation_model2 and Strike_slip_Dislocation_model2

**Similar process as earlier, need to provide a few hard-coded parameters**

