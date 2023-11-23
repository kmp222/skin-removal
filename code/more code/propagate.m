function propagated_mask = propagate(predictedTernaria, otsuBin, r, c)

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
    if(tmpTernaria(k) ~=1  && tmpOtsu(k) == 1 && grey(k) == 1)
        tmpTernaria(k) = 1;
    end
end
    propagated_mask = reshape(tmpTernaria, r,c);
    propagated_mask = (propagated_mask == 1);
    propagated_mask = imclose(propagated_mask, strel("disk", 7));
end
