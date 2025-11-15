# UCI-HAR SLP Quantization and Memristor Verilog Framework
This is the repository for executing the memristor model in verilog using HAR dataset after taking the weights of the trained SLP model. there 561 feature from which 94 important feature are taken which has 6 class namely  
WALKING as 0
WALKING_UPSTAIRS as 1
WALKING_DOWNSTAIRS as 2
SITTING as 3
STANDING as 4
LAYING as 5


In this program i have used human activity recognition(HAR) dataset, in previously i have used same dataset to find the important feature from the same dataset where i have used SHAP XAI technique where i have by increased and decred the feature and got different accuracy so have used 95 feature where accuracy is near to by using all 561 feature.
i have used this reference paper "An FPGA-based memristor emulator for artificial neural network" where they used a MNIST dataset, 
step 1: used MNIST dataset trained and tested using single layer perceptron(SLP). 
step 2: used the weights of SLP and quantized between (0-2) with step size = 0.25 with 8-valued memristor. then converted to fixed point number which can be used in verilog when running descrete memristor model. 
step 3: the features are scaled between (-4, 4) then converted to fixed point number where input and weights can be expressed in 4 digits for integer, 2 digits for decimal and 1 digit for sign.

i have replicated the same paper i have 1st used the same dataset and same procedure later chnaged the dataset to HAR used 95 feature instead 561 feature. then trained and tested using single layer perceptron (SLP) saved the best model and their weights later followed above step 1, 2 and 3. converted to .txt file so that can be uploaded while writing a program for memrristor model.
memristor model: as mentioned in the paper if consider MNIST dataset there are 784 inputs (28x28 image pixel) and there are 10 handwritten digit so 784*10=7840 weights and each pixel has one memristor so there are 7840 memristor module.
mow in this i have used HAR dataset in that 95 feature so there are 95 inputs and there are 6 class (0-5) so 95*6=570 memristor module.





Download Data-set from here : Reyes-Ortiz, J., Anguita, D., Ghio, A., Oneto, L., & Parra, X. (2013). Human Activity Recognition Using Smartphones [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C54S4K. 
