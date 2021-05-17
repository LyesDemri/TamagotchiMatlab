disp('Predicting future...')
tic;
%On commence par charger toutes les variables d'état dans des variables
%locales qui ont des noms plus courts
HgHUC=UserData.stomach;
HpHUC=UserData.happy;
CMUC=UserData.care_misses;
%booléens
sickUC=UserData.sick;
dirtyUC=UserData.dirty;
NDUC=UserData.needs_discipline;
sleepingUC=UserData.sleeping;
lightsOnUC=UserData.lights_on;
egg = UserData.egg;
%Le nom du personnage actuel:
characterUC=UserData.character;

%Périodes de pertes de coeurs
HgHLP=UserData.time_to_lose_stomach_heart;
HpHLP=UserData.time_to_lose_happy_heart;

%Périodes d'appels de discipline:
DCP=(UserData.discipline+1)*3600;

%Times since Hungry/Happy changed
TSHgC=UserData.time_since_hungry_changed;
TSHpC=UserData.time_since_happy_changed;

TSLDC=UserData.time_since_last_discipline_call;

%Evolution:
TTE=UserData.time_to_evolve;

%Various parametric periods
DFHgP=6*3600;
DFBP=6*3600;
SFPP=2*3600;
DFSP=12*3600;
CMP=900;

%Time upon closing app
TUC=UserData.t;

%On calcule l'heure de mort et de perte de prochain coeur Hungry pour le
%personnage actuel (on ne tient compte d'aucun autre évènement pour le
%moment).
if HgHUC~=0
  TTLHgH=TUC+HgHLP-TSHgC;
  TTDFHg=TUC+(HgHUC-1)*HgHLP+(HgHLP-TSHgC)+DFHgP;
else
  TTLHgH=Inf;
  TTDFHg=TUC+DFHgP-UserData.time_since_hungry;
end

%Même chose pour les coeurs Happy
if HpHUC~=0
  TTLHpH=TUC+HpHLP-TSHpC;
  TTDFB=TUC+(HpHUC-1)*HpHLP+(HpHLP-TSHpC)+DFBP;
else
  TTLHpH=Inf;
  TTDFB=TUC+DFBP-UserData.time_since_unhappy;
end

%Poop
%Si l'utilisateur a fermé l'appli tandis que le tamagotchi avait déjà sali,
%on peut mettre Time to Poop à Inf et ne plus s'en soucier. On initialise
%Time Since Dirty à partir de UserData et on calcule l'heure du Care Miss.
if dirtyUC
  TTP=Inf;
  TSD=UserData.time_since_dirty;
  TFPCM=TUC+CMP-TSD;
  %Normalement si on trouve TFPCM inférieur à TUC on met TFPCM=Inf (il y a
  %déjà eu un care miss)
  if TFPCM<=TUC
      TFPCM=Inf;
  end
else
    %Si le tamagotchi n'avait pas encore sali, il faut calculer l'heure du
    %prochain caca, ce qui se fait différemment selon qu'on a un Babytchi
    %ou d'autres personnages
    %disp('Le TMGC est propre')
    if strcmp(characterUC,'Babytchi')
%         disp('on a pas affaire à Babytchi')
        %Pour Babytchi on doit juste placer le prochain poop selon la
        %valeur actuelle de t
        if TUC<1200+300
            TTP=1200+300;
        elseif TUC < 3010+300
            TTP=3010+300;
        else
            TTP=TTE+180*60;
        end
    else
        %Pour les autres personnages on doit calculer combien de temps il
        %restait avant de chier et l'ajouter au t actuel.
%         disp('on n''a pas affaire à Babytchi');
        TTP=TUC+UserData.time_to_poop-UserData.time_since_last_pooped;
        if TTP<TUC
%             disp('Something was wrong');
%             disp(['time to poop:' UserData.time_to_poop]);
%             disp(['time since last pooped:' UserData.time_since_last_pooped]);
        end
    end
    %L'heure du prochain care miss est évidente
    TFPCM=TTP+CMP;
end

%Sickness
if sickUC
  TSS=UserData.time_since_sick;
  TTGS=Inf;
  TTGSFP=Inf;
  TTDFS=TUC+DFSP-TSS;
  TFSCM=TUC+CMP-TSS;
  if TFSCM<TUC
    TFSCM=Inf;
  end
else
    if strcmp(characterUC,'Babytchi')
        if TUC<2280+300
            TTGS=2280+300;
        else
            TTGS=Inf;   %On arrangera ça à l'évolution
        end
        TTDFS=Inf;
        TFSCM=Inf;
    else
      TTGS=UserData.time_to_get_sick_due_to_age;
      if dirtyUC
        TTGSFP=TUC+SFPP-TSD;
      else
        TTGSFP=TTP+SFPP;
      end
      TTGS=min(TTGS,TTGSFP);
      TTDFS=TTGS+DFSP;
      TFSCM=TTGS+CMP;
    end
end

%Hunger/Happy Care Misses:
TFHgCM=TUC+(HgHUC-1)*HgHLP+(HgHLP-TSHgC)+CMP;
if (TFHgCM<TUC)
  TFHgCM=Inf;
end
TFBCM=TUC+(HpHUC-1)*HpHLP+(HpHLP-TSHpC)+CMP;
if TFBCM<TUC
  TFBCM=Inf;
end

%Discipline
if NDUC
  %        <---------DCP---------->
  %        <-TSND->
  %--------|------|---------------|--------------------
  %        DC     TUC             TFDC
  TSND=UserData.time_since_needs_discipline;
  TFDC=TUC-TSND+DCP;
else
    if UserData.discipline < 4
        %si c'est un babytchi, on fixe le premier DC à 1h après son évolution
        if strcmp(characterUC,'Babytchi')
            TFDC=70*60+3600;
        else
            %      <---------------DCP---------><-CMP->
            %      <-TSLDC->
            %------|-------|-------------------|------|-----
            %      LDC     TUC                 TFDC   TFDCM
            TFDC=TUC-TSLDC+DCP;
        end
    else
        TFDC=Inf;
    end
end
TFDCM=TFDC+CMP;

current_hour=clock;
%Sleep
if ~sleepingUC
    sleeping_date=current_hour(1:3);
    sleeping_date(4:6)=[UserData.sleeping_hour,0,0];
    TTS=TUC+etime(sleeping_date,current_hour);
    if lightsOnUC
        TFLCM=TTS+900;
    else
        TFLCM=Inf;
    end
    sleep_duration = etime([0 0 1 UserData.waking_hour 0 0],[0 0 0 UserData.sleeping_hour 0 0]);
    TTW=TTS+sleep_duration;
    %Ya3ni je n'aime pas trop l'idée d'écraser ce calcul qui est
    %parfaitement valide à ce niveau.
    if strcmp(characterUC,'Babytchi')
        if TUC<2700
            TTS=2700;
            TTW=3000;
        end
    end
else
  %on récupère l'heure de réveil et on la met dans un jour fictif
  waking_hour=UserData.waking_hour;
  waking_date = [0 0 1 waking_hour 0 0];
  %on récupère l'heure de sommeil (ça a l'air faux)
  %(exemple: 05/12/20 23h32)
  closing_date = clock;
  %on constitue une heure fictive
  working_closing_date=closing_date;
  if closing_date(4)>12
    working_closing_date(1:3)=[0 0 0];
    %[0 0 0 23 32 00]
  else
    working_closing_date(1:3)=[0 0 1];
    %[0 0 1 23 32 00]
  end
  %Calcul de l'instant de réveil
  TTW = TUC+etime(waking_date,working_closing_date);
  
  %Calcul de la durée depuis laquelle le tmgc dort
  TSA=etime(working_closing_date,[0 0 0 UserData.sleeping_hour 0 0]);
  %Calcul de l'instant du prochain endormissement
  TTS = TTW+etime([0 0 1 UserData.sleeping_hour,0,0],[0 0 1 UserData.waking_hour 0 0]);
  %Si on a affaire à Babytchi les instants sont recalculés
  if strcmp(characterUC,'Babytchi')
      %Si on est avant l'instant de réveil de Babytchi:
      if TUC<3000
          %On met le prochain instant de réveil
          TTW = 3000;
          %Pour l'endormissement ça sera réglé par predict_evolution
          TTS=Inf;
      end
  end
  %Si la lumière était allumée quand l'utilisateur a fermé
  if lightsOnUC
      %si le tamagotchi dort depuis plus de 15 minutes
    if TSA>CMP
        %Il a déja eu son Light Care Miss donc pas la peine d'en placer un
        %nouveau
      TFLCM=Inf;
    else
        %Si le tamagotchi n'a pas encore eu son Light Care Miss on le
        %planifie
      TFLCM=TUC+CMP-TSA;
    end
  else
      %Si la lumière est éteinte on n'aura jamais de Light Care miss
    TFLCM=Inf;
  end
  
  SleepDuration = etime(waking_date,working_closing_date);
  TTLHgH=TTLHgH+SleepDuration;
  TFHgCM=TFHgCM+SleepDuration;
  TTDFHg=TTDFHg+SleepDuration;
  TTLHpH=TTLHpH+SleepDuration;
  TFBCM=TFBCM+SleepDuration;
  TTDFB=TTDFB+SleepDuration;
  TTGS=TTGS+SleepDuration;
  TTDFS=TTDFS+SleepDuration;
  if ~sickUC
    %TTDFS=TTDFS+SleepDuration;
    TFSCM=TFSCM+SleepDuration;
  end
  TTP=TTP+SleepDuration;
  if ~dirtyUC
    TFPCM=TFPCM+SleepDuration;
  end
  TFDC=TFDC+SleepDuration;
  TFDCM=TFDCM+SleepDuration;
end

%Death from old age:
TTDFOA=25*24*3600;

alive=true;

HgH=HgHUC;
HpH=HpHUC;
CM=CMUC;
sick=sickUC;
dirty=dirtyUC;
needsDiscipline=NDUC;
character=characterUC;
lightsOn=lightsOnUC;
sleeping=sleepingUC;

eventsList={0,0};
k=1;
if UserData.egg
    hatching_time=300;
    eventsList={'Hatch',hatching_time};
    TFHgCM = CMP+hatching_time;
    TFBCM = CMP+hatching_time;
    TFDC = hatching_time+65*60+3600;
    TFDCM = TFDC+CMP;
    TTP = hatching_time+1500;
    TFPCM = TTP+CMP;
    TTGS = hatching_time+2280;
    CMFS = TTGS + CMP;
    k=k+1;
end

possibleEvents={'HgHL','HpHL','DFHg','DFB','CMFHg','CMFB','Poop','DFS','Sickness','CMFP','CMFS','DC','CMFD','Sleep','WakeUp','LCM','DFOA','Evolution'};
eventTimes=[TTLHgH,TTLHpH,TTDFHg,TTDFB,TFHgCM,TFBCM,TTP,TTDFS,TTGS,TFPCM,TFSCM,TFDC,TFDCM,TTS,TTW,TFLCM,TTDFOA,TTE];


while alive && k<100
    %On voit quel est l'évènement le plus proche dans le futur
    [nextEventTime,i]=min(eventTimes);
    %On récupère le nom de l'évènement
    nextEvent=possibleEvents{i};
    %On le stocke dans la liste d'évènements avec son instant
    eventsList{k,1}=nextEvent;
    eventsList{k,2}=nextEventTime;
    %On applique les modifications nécessaires 
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
        TFDC=TFDC+DCP;
        TSLDC=0;
    elseif strcmp(nextEvent,'CMFD')
        needsDiscipline=false;
        CM=CM+1;
        TFDC=TFDCM-CMP+DCP;
        TFDCM=TFDC+CMP;
        if CM==25
          alive=false;
        end
    elseif strcmp(nextEvent,'Sleep')
        %disp('Le tamagotchi va s''endormir')
        SleepDuration=TTW-TTS;
        TFLCM=TTS+CMP;
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
        TFDCM=TFDCM+SleepDuration;
        TTS=TTS+24*3600;
    elseif strcmp(nextEvent,'WakeUp')
        %disp('TMGC va se réveiller')
        sleeping=false;
        TTW=TTW+24*3600;
        lightsOn=true;
        TFLCM=Inf;
    elseif strcmp(nextEvent,'LCM')
        CM=CM+1;
        TFLCM=TFLCM+24*3600;
        TFLCM=Inf;
        if CM==25
          alive=false;
        end
    elseif strcmp(nextEvent,'DFOA')
        alive=false;
    elseif strcmp(nextEvent,'Evolution')
        predict_evolution;
    elseif strcmp(nextEvent,'Hatch')
        egg=false;
    end
    k=k+1;
    eventTimes=[TTLHgH,TTLHpH,TTDFHg,TTDFB,TFHgCM,TFBCM,TTP,TTDFS,TTGS,TFPCM,TFSCM,TFDC,TFDCM,TTS,TTW,TFLCM,TTDFOA,TTE];
end
UserData.eventsList=eventsList;
%eventsList

disp('Done predicting future.')
%toc