disp('TMGC va �voluer')
%On pr�dit en quoi on va �voluer:
determine_evolution_character

%On met � jour les p�riodes de pertes de coeur:
HgHLP=TamagotchiData{2,col};
HpHLP=TamagotchiData{3,col};

%On sauvegarde l'instant de l'�volution (on en aura besoin plus tard)
EvT=TTE;
%Si le tamagotchi n'a pas chi� avant d'�voluer, on met � jour l'heure de
%caca
if ~dirty
    TTP=TTE+TamagotchiData{4,col};
end
UserData.time_to_poop=TamagotchiData{4,col};
%On met � jour la dur�e n�cessaire pour la prochaine �volution:
TTE=TTE+TamagotchiData{7,col};
    
%Mise a jour de certains instants :
%S il reste des coeurs au tmgc il va mourir plus tard (ou plus tot) de faim/ennui. 
%Les CM seront aussi modifi�s
if HgH>0
  TTDFHg=EvT+(HgH-1)*HgHLP+(HgHLP-TSHgC)+DFHgP;
  TFHgCM=EvT+(HgH-1)*HgHLP+(HgHLP-TSHgC)+CMP;
end
if HpH>0
  TTDFB=EvT+(HpH-1)*HpHLP+(HpHLP-TSHpC)+DFBP;
  TFBCM=EvT+(HpH-1)*HpHLP+(HpHLP-TSHpC)+CMP;
end
%Si le tmgc n'a pas encore chi�, il faut aussi mettre � jour l'heure de 
%prochain caca
if ~dirty
  TFPCM=TTP+CMP;
  TTGS=min(TTGS,TFPCM+SFPP);
end

waking_hour=UserData.waking_hour;   %09h
sleeping_hour=UserData.sleeping_hour;  %20h 
%On calcule la diff�rence entre les sleeping dates des 2 tamagotchis
sleeping_hour2=TamagotchiData{5,col};   %21h
sleeping_date2=current_hour(1:3);       %01/10/2020
sleeping_date2(4:6)=[sleeping_hour2,0,0]; %01/10/2020 21h00
%On fait la m�me chose pour le r�veil
waking_hour2=TamagotchiData{6,col};
waking_date2=[0 0 1 waking_hour2 0 0];
%On doit obtenir l'heure d'�volution:
closing_to_evolving_time=EvT-TUC;
evolution_date=addtodate(datenum(current_hour),closing_to_evolving_time,'second');
evolution_date=datevec(evolution_date);
disp(['heure d''�volution: ' datestr(evolution_date)])
working_evolution_date=[0 0 0 evolution_date(4:6)];
if strcmp(character,'Tonmarutchi')
    %On a �volu� de Babytchi, cas particulier
    if evolution_date(4)>=20 || evolution_date(4)<9
        %Si c'est la nuit
        sleeping=true;
        %Calcul de l'instant de r�veil:
        if evolution_date(4)>=0 && evolution_date(4) <9
            disp('l''�volution a lieu apr�s minuit')
            %si c'est apr�s minuit
            working_evolution_date(3)=1;
        end
        SleepDuration=etime(waking_date2,working_evolution_date);
        TTW=EvT+SleepDuration;
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
        TTS=TTW+11*3600;
    else
        %Si c'est le jour
        sleeping=false;
    end
else
    disp('On ne va pas �voluer vers Tonmarutchi')
    if ~sleeping
        disp('Le tamagotchi sera �veill� � l''heure de l''�volution')
        %V�rifier si la forme �volu�e dort � cette heure ci
        if evolution_date(4)>=sleeping_hour2 || evolution_date(4)<waking_hour2
            %Si elle dort:
            sleeping=true;
            %-----|xxxxxxxxxx|E----
            %-------|-----------|--

            %----E|xxxxxxxxxx|-----
            %--|----------|--------

            %----E|xxxxxxxxxx|-----
            %--|----------------|--

            %-----|xxxxxxxxxx|-E---
            %--|----------------|--
            %Calculer combien il reste � dormir 
            %Calcul de l'instant de r�veil:
            if evolution_date(4)>=0 && evolution_date(4) <waking_hour2
                disp('l''�volution a lieu apr�s minuit')
                %si c'est apr�s minuit
                working_evolution_date(3)=1;
            end
            SleepDuration=etime(waking_date2,working_evolution_date);
            %d�caler tous les �v�nements qui doivent se produire avant le 
            %r�veil
            TTW=EvT+SleepDuration;
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
            TTS=TTW+(sleeping_hour2-waking_hour2)*3600;
        else
            %Si elle ne dort pas:
            %--E--|xxxxxxxxxx|-----
            %-------|-----------|--

            %-E---|xxxxxxxxxx|-----
            %--|----------|--------

            %-E---|xxxxxxxxxx|-----
            %--|----------------|--

            %-E---|xxxxxxxxxx|-----
            %--------|----|--------
            %Recalculer les instants de tous les �v�nements et ne rien
            %faire d'autre (l'�v�nement Sleep d�calera les �v�nements qui
            %tombent pendant le sommeil)
            %Le calcul des �v�nements est d�j� fait donc pour le moment on
            %va supposer que �a suffit
            %Il faut quand m�me calculer les nouveaux TTS et TTW
            working_evolution_date=evolution_date;
            working_evolution_date(1:3)=0;
            TTS=EvT+etime([0 0 0 sleeping_hour2 0 0],working_evolution_date);
            TTW=TTS+(24-(sleeping_hour2-waking_hour2))*3600;
        end
    else
        disp('Le tamagotchi sera endormi � l''heure de l''�volution')
        %Si le tamagotchi dormait � l'�volution
        if evolution_date(4)>=sleeping_hour2 || evolution_date(4)<waking_hour2
            disp('La forme �volu�e sera aussi endormie')
            %Si la forme �volu�e dort aussi:
%             xxxxx|---E------|xxxxx
%             -------|-----------|--
% 
%             xxxxx|--E-------|xxxxx
%             --|----------|--------

%             xxxxx|--E-------|xxxxx
%             --|----------------|--
% 
%             xxxxx|----E-----|xxxxx
%             --------|----|--------
            %Calculer combien il reste � dormir 
            %Calcul de l'instant de r�veil:
            if evolution_date(4)>=0 && evolution_date(4) <waking_hour2
                disp('l''�volution aura lieu apr�s minuit')
                %si c'est apr�s minuit
                working_evolution_date(3)=1;
            end
            SleepDuration=etime(waking_date2,working_evolution_date);
            %d�caler tous les �v�nements qui doivent se produire avant le 
            %r�veil
            TTW=EvT+SleepDuration;
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
            TTS=TTW+(sleeping_hour2-waking_hour2)*3600;
        else
            sleeping=false;
            disp('La forme �volu�e sera �veill�e')
            %Si la forme �volu�e est �veill�e:
            %Il faut recalculer les �v�nements sleep et wake
           if evolution_date(4)>=0 && evolution_date(4)<waking_hour2
               disp('L''�volution se produira apr�s minuit')
               %xxxxx|---------E|xxxxx
               %--|----------|--------

               %xxxxx|---------E|xxxxx
               %--------|----|--------
               working_evolution_date=evolution_date;
               working_evolution_date(1:3)=0;
               TTW=EvT+etime([0 0 0 waking_hour2 0 0],working_evolution_date);
               TTS=TTW+(sleeping_hour2-waking_hour2)*3600;
           else
               disp('L''�volution se produira avant minuit')
               %xxxxx|E---------|xxxxx
               %-------|-----------|--

               %xxxxx|E---------|xxxxx
               %--------|----|--------
               working_evolution_date=evolution_date;
               working_evolution_date(1:3)=0;
               TTS=EvT+etime([0 0 0 sleeping_hour2 0 0],working_evolution_date);
               TTW=TTS+(24-(sleeping_hour2-waking_hour2))*3600;
           end
        end
    end
end

if lightsOn
    TFLCM=TTS+CMP;
end