disp('-------------')
disp('Catching up to the current time...')
tic;
HgHUC=UserData.stomach;
HpHUC=UserData.happy;
TSHgC=UserData.time_since_hungry_changed;
TSHpC=UserData.time_since_happy_changed;
TSD=UserData.time_since_dirty;
TSS=UserData.time_since_sick;
TSND=UserData.time_since_needs_discipline;
TSLP=UserData.time_since_last_pooped;
TSLDC=UserData.time_since_last_discipline_call;
%%%Il faut mettre à jour time since hungry et time since unhappy pour que
%%%l'icône attention s'éteigne
TSH = UserData.time_since_hungry;
TSU = UserData.time_since_unhappy;

TTE=UserData.time_to_evolve;

DFHgP=6*3600;
DFBP=6*3600;
SFPP=2*3600;
DFSP=12*3600;
CMP=900;

CMUC=UserData.care_misses;
sleeping=UserData.sleeping;
dirty=UserData.dirty;
is_alive = UserData.is_alive;
sick = UserData.sick;
character = UserData.character;
needsDiscipline = UserData.needs_discipline;
lightsOn = UserData.lights_on;
egg=UserData.egg;
TUC=UserData.t;
eventsList = UserData.eventsList;
%eventsList
TUO=UserData.t+seconds_passed;

HgH=HgHUC;
HpH=HpHUC;
CM=CMUC;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Here''s what you''ve missed:')
for k=1:size(eventsList,1)
    if TUO<eventsList{k,2}
        %disp('No more events to simulate')
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
        TSLDC=TSLDC+eventsList{k,2}-lastEventTime;
        if HgH==0
            TSH=TSH+eventsList{k,2}-lastEventTime;
        end
        if HpH==0
            TSU=TSU+eventsList{k,2}-lastEventTime;
        end
        if dirty
            TSD = TSD + eventsList{k,2}-lastEventTime;
        else
            TSLP = TSLP+eventsList{k,2}-lastEventTime;
        end
        
        if sick
            TSS = TSS + eventsList{k,2} - lastEventTime;
        end
        if needsDiscipline
            TSND = TSND + eventsList{k,2}-lastEventTime;
        end
    end
    
    %Application de l'événement
    if strcmp(eventsList{k,1},'HgHL')
        %disp('Hunger heart loss')
        HgH=HgH-1;
        TSHgC=0;
    elseif strcmp(eventsList{k,1},'CMFHg')
        %disp('Care Miss from Hunger')
        CM = CM+1;
    elseif strcmp(eventsList{k,1},'DFHg')
        disp('Tamagotchi died of hunger')
        disp('Sorry for your loss...')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'HpHL')
        %disp('Happy heart loss')
        HpH=HpH-1;
        TSHpC=0;
    elseif strcmp(eventsList{k,1},'CMFB')
        %disp('Care miss from boredom')
        CM=CM+1;
    elseif strcmp(eventsList{k,1},'DFB')
        disp('Tamagotchi died of boredom')
        disp('Sorry for your loss...')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'Sleep')
        disp('Tamagotchi fell asleep')
        sleeping=true;
    elseif strcmp(eventsList{k,1},'WakeUp')
        disp('Tamagotchi woke up')
        sleeping=false;
        lightsOn=true;
    elseif strcmp(eventsList{k,1},'LCM')
        %disp('Lights Care Miss')
        CM = CM+1;
    elseif strcmp(eventsList{k,1},'Sickness')
        disp('Tamagotchi became sick')
        sick=true;
        TSS = 0;
    elseif strcmp(eventsList{k,1},'CMFS')
        %disp('Care miss from sickness')
        CM=CM+1;
    elseif strcmp(eventsList{k,1},'DFS')
        disp('Death from sickness')
        is_alive = false;
    elseif strcmp(eventsList{k,1},'DC')
        disp('Tamagotchi called for nothing')
        needsDiscipline = true;
        TSND=0;
        TSLDC=0;
    elseif strcmp(eventsList{k,1},'CMFD')
        %disp('Care miss from Discipline')
        CM=CM+1;
        needsDiscipline = false;
        TSND=0;
        TSLDC=CMP;
    elseif strcmp(eventsList{k,1},'Evolution')
        disp('Tamagotchi evolved')
        predict_evolution_for_catchup;
    elseif strcmp(eventsList{k,1},'DFOA')
        disp('Tamagotchi died from old age')
        disp('Sorry for your loss...')
        is_alive=false;
    elseif strcmp(eventsList{k,1},'Poop')
        disp('Tamagotchi pooped')
        dirty=true;
        TSD=0;
        TSLP=0;
    elseif strcmp(eventsList{k,1},'CMFP')
        %disp('Care miss from poop')
        CM = CM+1;
    elseif strcmp(eventsList{k,1},'Hatch')
        disp('Egg hatched')
        egg=false;
    end
end

if ~sleeping
    if k>1
        lastEventTime=eventsList{k-1,2};
    else
        %disp('Nothing happened')
        lastEventTime=TUC;
    end
    TSHgC=TSHgC+TUO-lastEventTime;
    TSHpC=TSHpC+TUO-lastEventTime;
    TSLDC=TSLDC+TUO-lastEventTime;
    
    if HgH==0
        TSH=TSH+TUO-lastEventTime;
    end
    if HpH==0
        TSU=TSU+TUO-lastEventTime;
    end
    if dirty
        TSD=TSD+TUO-lastEventTime;
    else
        TSLP=TSLP+TUO-lastEventTime;
    end
    if sick
        TSS=TSS+TUO-lastEventTime;
    end
    if needsDiscipline
        TSND=TSND + TUO-lastEventTime;
    end
end

UserData.stomach = HgH;
UserData.happy = HpH;
UserData.time_since_hungry_changed = TSHgC;
UserData.time_since_happy_changed = TSHpC;
UserData.time_since_dirty = TSD;
UserData.time_since_needs_discipline = TSND;
UserData.time_since_sick = TSS;
UserData.time_since_last_pooped = TSLP;
UserData.time_since_last_discipline_call = TSLDC;
UserData.time_since_hungry=TSH;
UserData.time_since_unhappy=TSU;
UserData.time_to_evolve=TTE;
UserData.care_misses=CM;

UserData.sleeping=sleeping;
UserData.dirty=dirty;
UserData.is_alive=is_alive;
UserData.sick=sick;
UserData.character=character;
UserData.egg=egg;
load_character;
UserData.needs_discipline=needsDiscipline;
UserData.lights_on=lightsOn;
UserData.t = TUO;

closing_date=UserData.last_closed_date;
opening_date=open_time;
age_increment=calculateAgeIncrement(closing_date,opening_date);
UserData.age=UserData.age+age_increment;

disp('Done catching up!')
disp('------------------')
%toc