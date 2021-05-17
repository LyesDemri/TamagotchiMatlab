%Death from hunger (x)
%Death from boredom (x)
%Death from care misses (Hunger(x), happiness(x), lights (x), sickness(x), poop (x), discipline (x))
%Death from sickness (from poop (x))
%Sickness (from poop (x))
%Poop (x)
%Sleep (x)
%Care Misses (Hunger(x), happiness(x), lights (x), sickness(x), poop (x), discipline (x))
%Discipline (x)
%Death from old age (x)
%Evolution
tic;
HgHUC=4
HpHUC=4
CMUC=0
sickUC=false
dirtyUC=false
NDUC=false
sleepingUC=false
lightsOnUC=true
characterUC='Tongaritchi'
characterSleepHour=21;
hour=[2020 11 10 20 00 00];

HgHLP=80*60
HpHLP=80*60

TSHgC=randi(HgHLP)
TSHpC=randi(HpHLP)


DFHgP=6*3600
DFBP=6*3600
SFPP=3*3600
DFSP=4*3600

CMP=900

TUC=randi([65*60+48*3600,65*60+96*3600])
TUC=100000

if HgHUC~=0
  TTLHgH=TUC+HgHLP-TSHgC
else
  TTLHgH=Inf
end

if HpHUC~=0
  TTLHpH=TUC+HpHLP-TSHpC
else
  TTLHpH=Inf
end

%Poop
if dirtyUC
  TTP=Inf
  TSD=9500
  TFPCM=TUC+900-TSD
else
  TTP=TUC+7200
  TFPCM=TTP+CMP
end

%Death from hunger/boredom
TTDFHg=TUC+(HgHUC-1)*HgHLP+(HgHLP-TSHgC)+DFHgP
TTDFB=TUC+(HpHUC-1)*HpHLP+(HpHLP-TSHpC)+DFBP

%Sickness
if sickUC
  TSS=randi(DFSP)
  TTGS=Inf
  TTGSFP=Inf
  TTDFS=TUC+DFSP-TSS
  TFSCM=TUC+900-TSS
  if TFSCM<TUC
    TFSCM=Inf
  end
else
  TTGS=35500+TUC
  if dirtyUC
    TTGSFP=TUC+SFPP-TSD
  else
    TTGSFP=TUC+TTP+SFPP
  end
  TTGS=min(TTGS,TTGSFP)
  TTDFS=TTGS+DFSP
  TFSCM=TTGS+900
end


%Hunger/Happy Care Misses:
TFHgCM=TUC+(HgHUC-1)*HgHLP+(HgHLP-TSHgC)+CMP
if (TFHgCM<TUC)
  TFHgCM=Inf
end
TFBCM=TUC+(HpHUC-1)*HpHLP+(HpHLP-TSHpC)+CMP
if TFBCM<TUC
  TFBCM=Inf
end

%Discipline
if NDUC
  TSND=100
  TFDC=Inf
  TFDCM=TUC+900-TSND
else
  TFDC=TUC+12300
  TFDCM=TFDC+900
end

%Sleep
if ~sleepingUC
  TTS=TUC+1*3600
  if lightsOnUC
    TFLCM=TTS+900
  else
    TFLCM=Inf
  end
  TTW=TTS+12*3600
else
  TTW=TUC+4*3600
  TSA=1000;
  TTS=TTW+12*3600
  if lightsOnUC
    if TSA>900
      TFLCM=Inf
    else
      TFLCM=TUC+900-TSA
    end
  else
    TFLCM=Inf
  end
  TTLHgH=TTLHgH+TTW;
  TFHgCM=TFHgCM+TTW;
  TTDFHg=TTDFHg+TTW;
  TTLHpH=TTLHpH+TTW;
  TFBCM=TFBCM+TTW;
  TTDFB=TTDFB+TTW;
  TTGS=TTGS+TTW;
  TTDFS=TTDFS+TTW;
  if ~sickUC
    %TTDFS=TTDFS+SleepDuration;
    TFSCM=TFSCM+TTW;
  end
  TTP=TTP+TTW;
  if ~dirtyUC
    TFPCM=TFPCM+TTW;
  end
  TFDC=TFDC+TTW;
  if ~NDUC
    TFDCM=TFDCM+TTW;
  end
end

%Death from old age:
TTDFOA=25*24*3600

%Evolution:
TTE=TUC+13*3600;

alive=true;

HgH=HgHUC;
HpH=HpHUC;
CM=CMUC;
sick=sickUC;
dirty=dirtyUC;
needsDiscipline=NDUC;
character=characterUC;

possibleEvents={'HgHL','HpHL','DFHg','DFB','CMFHg','CMFB','Poop','DFS','Sickness','CMFP','CMFS','DC','CMFD','Sleep','WakeUp','LCM','DFOA','Evolution'};
eventTimes=[TTLHgH,TTLHpH,TTDFHg,TTDFB,TFHgCM,TFBCM,TTP,TTDFS,TTGS,TFPCM,TFSCM,TFDC,TFDCM,TTS,TTW,TFLCM,TTDFOA,TTE];
eventsList={0,0};
k=0;
disp('debut de creation de la liste')
while alive && k<10
  [nextEventTime,i]=min(eventTimes);
  nextEvent=possibleEvents{i};
  eventsList=[eventsList;nextEvent,nextEventTime];
  if strcmp(nextEvent,'HgHL')
    HgH=HgH-1;
    if HgH==0
      TTLHgH=Inf;
    else
      TTLHgH=TTLHgH+HgHLP;
    end
  elseif strcmp(nextEvent,'DFHg')
    alive=false;
  elseif strcmp(nextEvent,'HpHL')
    HpH=HpH-1;
    if HpH==0
      TTLHpH=Inf;
    else
      TTLHpH=TTLHpH+HpHLP;
    end
  elseif strcmp(nextEvent,'DFB')
    alive=false;
  elseif strcmp(nextEvent,'CMFHg')
    CM=CM+1;
    TFHgCM=Inf;
    if CM==25
      alive=false;
    end
  elseif strcmp(nextEvent,'CMFB')
    CM=CM+1;
    TFBCM=Inf;
    if CM==25
      alive=false;
    end
  elseif strcmp(nextEvent,'Poop')
    dirty=true;
    TTP=Inf;
  elseif strcmp(nextEvent,'Sickness')
    sick=true;
    TTGSFP=Inf;
    TTGS=Inf;
  elseif strcmp(nextEvent,'DFS')
    alive=false;
  elseif strcmp(nextEvent,'CMFP')
    CM=CM+1;
    TFPCM=Inf;
    if CM==25
      alive=false;
    end
  elseif strcmp(nextEvent,'CMFS')
    CM=CM+1;
    TFSCM=Inf;
    if CM==25
      alive=false;
    end
  elseif strcmp(nextEvent,'DC')
    needsDiscipline=true;
    TFDC=Inf
  elseif strcmp(nextEvent,'CMFD')
    needsDiscipline=false;
    CM=CM+1;
    if TFDC~=Inf
      TFDC=TFDC+12*3600;
      TFDCM=TFDCM+12*3600;
    else
      TFDC=TFDCM-900+12*3600;
      TFDCM=TFDC+900;
    end
    if CM==25
      alive=false;
    end
  elseif strcmp(nextEvent,'Sleep')
    SleepDuration=TTW-TTS;
    sleeping=true;
    TTLHgH=TTLHgH+SleepDuration;
    TFHgCM=TFHgCM+SleepDuration;
    TTDFHg=TTDFHg+SleepDuration;
    TTLHpH=TTLHpH+SleepDuration;
    TFBCM=TFBCM+SleepDuration;
    TTDFB=TTDFB+SleepDuration;
    TTGS=TTGS+SleepDuration;
    TTDFS=TTDFS+SleepDuration;
    if ~sick
      %TTDFS=TTDFS+SleepDuration;
      TFSCM=TFSCM+SleepDuration;
    end
    TTP=TTP+SleepDuration;
    if ~dirty
      TFPCM=TFPCM+SleepDuration;
    end
    TFDC=TFDC+SleepDuration;
    if ~needsDiscipline
      TFDCM=TFDCM+SleepDuration;
    end
    TTS=TTS+24*3600;
  elseif strcmp(nextEvent,'WakeUp')
    TTW=TTW+24*3600;
  elseif strcmp(nextEvent,'LCM')
    CM=CM+1;
    TFLCM=TFLCM+24*3600;
    if CM==25
      alive=false;
    end
  elseif strcmp(nextEvent,'DFOA')
    alive=false
  elseif strcmp(nextEvent,'Evolution')
    evolve
  end
  %k=k+1
eventTimes=[TTLHgH,TTLHpH,TTDFHg,TTDFB,TFHgCM,TFBCM,TTP,TTDFS,TTGS,TFPCM,TFSCM,TFDC,TFDCM,TTS,TTW,TFLCM,TTDFOA,TTE];
end
eventsList=eventsList(2:end,:)
disp('done!')
disp('tmgc va mourir dans:')
(eventsList{end,2}-TUC)/3600
toc