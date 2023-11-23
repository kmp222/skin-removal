function propagated_mask = propagateHard(predictedTernaria, otsuBin, r, c)

%Estraggo come "layer" dalla maschera ternaria i valori grigi.
grey = (predictedTernaria == 0.5);

%chiudo eventuali buchi nella regione dei grigi
%grey = imclose(grey, se);
grey = grey(:);

%chiudo eventuali buchi nelle regioni bianche della maschera
%predictedTernaria = imclose(predictedTernaria, s);  

tmpTernaria = predictedTernaria(:);
tmpOtsu = otsuBin(:);

for k = 1:length(tmpTernaria)
     if tmpOtsu(k) == 0
         tmpTernaria(k) = 0;
     else
        if(tmpTernaria(k) ~=1  && tmpOtsu(k) == 1 && grey(k) == 1)
        tmpTernaria(k) = 1;
        end
     end
end
    propagated_mask = reshape(tmpTernaria, r,c);
    propagated_mask = (propagated_mask == 1);
    propagated_mask = imclose(propagated_mask, strel("disk", 7));
end
function [outputArg1,outputArg2] = untitled2(inputArg1,inputArg2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end