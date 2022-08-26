/*********************************************
 * OPL 20.1.0.0 Model
 * Author: user
 * Creation Date: 7 Apr 2021 at 4:12:23 pm
 *********************************************/

{string} Products=...;
{string} Factory=...;
{string} Warehouse=...;
{string} Customers=...;
{string}DC=...;

// Fixed Cost
float FixedCost_F[Factory] =...;
float FixedCost_W [Warehouse]=...; 
float FixedCost_DC [DC]=...;

// Variable cost
float VA[Factory]=...;
float VB [Warehouse]=...;
float VC [Customers]=...;
float VD [DC]=...;
float VR [Factory]=...;
// Transportation cost

float TC_FW [Factory][Warehouse]=...;
float TC_WC [Warehouse][Customers]=...;
float TC_CD [Customers][DC]=...;
float TC_DF [DC][Factory]=...;

// capacity
float HA[Factory]=...;
float HB [Warehouse]=...;
float HD [DC]=...;
float HR [Factory]=...;

// Demand
float Demand[Customers]=...;
float QR =...;
float QD =...;



//variables

dvar boolean Open[Factory];
dvar boolean Start[Warehouse];
dvar boolean Prior[DC];
dvar float+ YA[Factory][Warehouse];
dvar float+ YB[Warehouse][Customers];
dvar float+ YC[Customers][DC];
dvar float+ YD[DC][Factory];

dexpr float FixedCost = sum(f in Factory)FixedCost_F[f]*Open[f] + 
                          sum(w in Warehouse)FixedCost_W[w]*Start[w] +
                          sum(i in DC)FixedCost_DC[i]*Prior[i];
dexpr float VariableCost = sum(f in Factory)VA[f]*sum(w in Warehouse)YA[f][w]+
                           sum(w in Warehouse)VB[w]* sum(c in Customers)YB[w][c]+
                           sum(c in Customers)VC[c]*sum(i in DC)YC[c][i]+
                           sum(i in DC)VD[i]* sum(c in Customers)YC[c][i]+
                           sum(f in Factory)VR[f]*sum(i in DC)YD[i][f];
                           

dexpr float TransportCost = sum(f in Factory, w in Warehouse)TC_FW[f][w]*YA[f][w]+
                            sum(w in Warehouse, c in Customers)TC_WC[w][c]*YB[w][c]+
                            sum(c in Customers,i in DC)TC_CD[c][i]*YC[c][i]+
                            sum(i in DC, f in Factory)TC_DF[i][f]*YD[i][f];



minimize FixedCost+ VariableCost+ TransportCost;

subject to {
  forall(f in Factory){
    sum(w in Warehouse)YA[f][w] <=  HA[f]*Open[f];
  }
  
  forall(w in Warehouse){
    sum(f in Factory) YA[f][w] <= HB[w]*Start[w]  ;
  }
  
  forall(w in Warehouse){
    sum(c in Customers) YB[w][c]<= sum(f in Factory)YA[f][w];
  }    
  
  forall(c in Customers){
    sum(w in Warehouse)YB[w][c] >= Demand[c];
  }
  
  forall(c in Customers){
    sum(i in DC) YC[c][i] <= Demand[c];
  }
  
  forall (i in DC){
    sum(c in Customers) YC[c][i] <= HD[i]*Prior[i];
  }
  
  forall (i in DC){
    sum(f in Factory) YD[i][f] >= QR *sum(c in Customers)YC[c][i];
  }
  forall(c in Customers){
    sum(i in DC) YC[c][i] >= QD* Demand[c];
  }
  
  forall(f in Factory){
    sum(i in DC) YD[i][f] <= HR[f]* Open[f];    
  }
  
  forall(f in Factory , w in Warehouse){
    YA[f][w] >=0;
  }
  forall(w in Warehouse, c in Customers){
    YB[w][c] >=0;
  }
  forall(c in Customers,i in DC){
    YC[c][i] >= 0;
  }
  
  forall(i in DC, f in Factory){
    YD[i][f] >= 0;
  }        
      
 }
  
  
