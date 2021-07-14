# Fast Orthogonal Serach (FOS) 

FOS is an algorithm used for system identification and spectral analysis. 

This project is a general implementaion of FOS to identify and produce a model of an unknown non-linear system. The user must provide time series of the input and output signals. The algorithm rapdily searchs through candidate model terms and adds significant terms to the system model which reduce model error. By default the system model will be a difference equation, although sinusoidal basis can be used instead for spectral analysis. The user can specify model accuracy and model order. 



