clear;clc;close all;
HgHUC=3;
HpHUC=4;
TSHgC=100;
TSHpC=200;
TSD=00;
TSS=0;
TSND=0;
CMUC=0;
sleeping=false;
dirty=false;
is_alive = true;
sick = false;
character = 'Tongaritchi';
needsDiscipline = false;
TUC=100000;
eventsList={'HgHL',101000;
            'HpHL',101500;
            'Poop',102000;
            'DC',102500;
            'CMFP',109000;
            'Sickness',110000;
            'HgHL',111000
            'Sleep',113000;
            %'WakeUp',108000;
            };
TUO=115000;

HgH=HgHUC;
HpH=HpHUC;
CM=CMUC;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('debut de la boucle')
for k=1:size(eventsList,1)
    if TUO<eventsList{k,2}
        break;
    end
    %Mise a jour de tout
    if k>1
        lastEventTime=eventsList{k-1,2};
    else
        lastEventTime=TUC;
    end
    if ~sleeping
        TSHgC=TSHgC+eventsList{k,2}-lastEventTime;
        TSHpC=TSHpC+eventsList{k,2}-lastEventTime;
        if dirty
            TSD = TSD + eventsList{k,2}-lastEventTime;
        end
        if sick
            TSS = TSS + eventsList{k,2} - lastEventTime;
        end
        if needsDiscipline
            TSND = TSND + eventsList{k,2}-lastEventTime;
        end
    end
    %{'HgHL','HpHL','DFHg','DFB','CMFHg','CMFB','Poop','DFS','Sickness','CMFP',...
    %    'CMFS','DC','CMFD','Sleep','WakeUp','LCM','DFOA','Evolution'};
    %Application de l'événement
    if strcmp(eventsList{k,1},'HgHL')
        HgH=HgH-1;
        TSHgC=0;
    elseif strcmp(eventsList{k,1},'CMFHg')
        CM = CM+1;
    elseif strcmp(eventsList{k,1},'DFHg')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'HpHL')
        HpH=HpH-1;
        TSHpC=0;
    elseif strcmp(eventsList{k,1},'CMFB')
        CM=CM+1;
    elseif strcmp(eventsList{k,1},'DFB')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'Sleep')
        sleeping=true;
    elseif strcmp(eventsList{k,1},'WakeUp')
        sleeping=false;
    elseif strcmp(eventsList{k,1},'LCM')
        CM = CM+1;
    elseif strcmp(eventsList{k,1},'Sickness')
        sick=true;
        TSS = 0;
    elseif strcmp(eventsList{k,1},'CMFS')
        CM = CM+1;
    elseif strcmp(eventsList{k,1},'DFS')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'DC')
        needsDiscipline = true;
        TSND=0;
    elseif strcmp(eventsList{k,1},'CMFD')
        CM = CM+1;
        needsDiscipline = false;
        TSND=0;
    elseif strcmp(eventsList{k,1},'Evolution')
        predict_evolution;
    elseif strcmp(eventsList{k,1},'DFOA')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'Poop')
        dirty=true;
        TSD = 0;
    elseif strcmp(eventsList{k,1},'CMFP')
        CM = CM+1;
    end
end

HgH
HpH
if ~sleeping
    TSHgC=TSHgC+TUO-eventsList{k,2};
    TSHpC=TSHpC+TUO-eventsList{k,2};
    if dirty
        TSD = TSD+TUO-eventsList{k,2};
    end
    if sick
        TSS = TSS+TUO-eventsList{k,2};
    end
    if needsDiscipline
        TSND = TSND + TUO-eventsList{k,2};
    end
end
disp(['TSHgC: ' num2str(TSHgC)])
disp(['TSHpC: ' num2str(TSHpC)])
disp(['TSD: ' num2str(TSD)])
disp(['TSS: ' num2str(TSS)])
disp(['TSND: ' num2str(TSND)])
disp(['dirty: ' num2str(dirty)])
disp(['sick: ' num2str(sick)])
disp(['needsDiscipline: ' num2str(needsDiscipline)])
