%update tamagotchi status:

%Evolution stuff
if UserData.t == UserData.time_to_evolve
    evolve
end
%Update stuff
if UserData.egg
    if UserData.t == 5*60
        UserData.state = 'egg shaking';
        UserData.egg = false;
        UserData.hatching_animation_counter = 0;
        UserData.character = 'Babytchi';
        load_character;
        wavplay(UserData.Hatching_sound,UserData.Fs,'async');
    end
else
    if ~UserData.sleeping
        %Hunger stuff
        %food care miss verification
        if UserData.stomach == 0
            UserData.time_since_hungry = UserData.time_since_hungry + UserData.time_step;
            if UserData.time_since_hungry == 900
                UserData.care_misses = UserData.care_misses+1;
                %disp('Food care miss');
            end
            if UserData.time_since_hungry == 21600
                UserData.state = 'dead';
                UserData.is_alive = false;
            end
        end
        %check if we should lose hungry heart
        UserData.time_since_hungry_changed = UserData.time_since_hungry_changed + UserData.time_step;
        if UserData.time_since_hungry_changed == UserData.time_to_lose_stomach_heart
            if UserData.stomach > 0
                UserData.time_since_hungry_changed = 0;
                UserData.stomach = UserData.stomach - 1;
                if UserData.stomach == 0
                    %disp([UserData.character ' is calling!']);
                    wavplay(UserData.call,UserData.Fs,'async');
                end
            end
        end

        %Happiness stuff
        %happy care miss verification
        if UserData.happy == 0
            UserData.time_since_unhappy = UserData.time_since_unhappy + UserData.time_step;
            if UserData.time_since_unhappy == 900
                UserData.care_misses = UserData.care_misses + 1;
                %disp('Food care miss');
            end
            if UserData.time_since_unhappy == 21600
                UserData.state = 'dead';
                UserData.is_alive = false;
            end
        end
        %check if we should lose happy heart
        UserData.time_since_happy_changed = UserData.time_since_happy_changed + UserData.time_step;
        if UserData.time_since_happy_changed == UserData.time_to_lose_happy_heart
            if UserData.happy >0
                UserData.time_since_happy_changed = 0;
                UserData.happy = UserData.happy - 1;
                if UserData.happy == 0
                    %disp([UserData.character ' is calling!']);
                    wavplay(UserData.call,UserData.Fs,'async');
                end
            end
        end
    end
    
    %Poop, sickness, and sleeping stuff have different rules for babytchi
    if strcmp(UserData.character,'Babytchi')
        %Poop stuff
        if UserData.t == 1200 || UserData.t == 3010
            UserData.state = 'pooping';
            UserData.pooping_animation_counter = 0;
            wavplay(UserData.call,UserData.Fs,'async');
            UserData.dirty = true;
        end

        %Sickness
        if UserData.t == 2280 
            UserData.sick = true;
            wavplay(UserData.call,UserData.Fs,'async');
        end

        %Sleeping stuff
        if UserData.t == 2700
            UserData.sleeping = true;
            wavplay(UserData.call,UserData.Fs,'async');
        end

        %Waking up
        if UserData.t == 3000
            UserData.sleeping = false;
            UserData.position(2)=12;
            UserData.lights_on = true;
        end
        
        %Discipline stuff (nothing to be done really)
        %UserData.time_since_last_discipline_call = UserData.time_since_last_discipline_call + 0.5;
    else
        if ~UserData.sleeping
            %Poop stuff
            UserData.time_since_last_pooped = UserData.time_since_last_pooped + 0.5;
            if UserData.time_since_last_pooped == UserData.time_to_poop
                UserData.time_since_last_pooped = 0;
                UserData.state = 'pooping';
                UserData.pooping_animation_counter = 0;
                wavplay(UserData.call,UserData.Fs,'async');
                UserData.dirty = true;
            end
            %The poop care miss is handled with the poop-induced sickness

            %Discipline stuff
            if UserData.discipline < 4
                UserData.time_since_last_discipline_call = UserData.time_since_last_discipline_call + UserData.time_step;
                if UserData.time_since_last_discipline_call == (UserData.discipline+1)*3600
                    wavplay(UserData.call,UserData.Fs,'async');
                    UserData.needs_discipline = true;
                    UserData.time_since_last_discipline_call = 0;
                end
            end

            if UserData.needs_discipline
                UserData.time_since_needs_discipline = UserData.time_since_needs_discipline + UserData.time_step;
                if UserData.time_since_needs_discipline == 900
                    UserData.needs_discipline = false;
                    UserData.time_since_needs_discipline = 0;
                    UserData.care_misses = UserData.care_misses+1;
                    %disp('care miss due to discipline');
                end
            end

            %Sickness
            %Poop related sickness:
            if UserData.dirty
                UserData.time_since_dirty = UserData.time_since_dirty + 0.5;
                if UserData.time_since_dirty == 900
                    UserData.care_misses = UserData.care_misses + 1;
                    %disp('Poop related care miss');
                end
                if UserData.time_since_dirty == 7200
                    UserData.sick = true;
                    wavplay(UserData.call,UserData.Fs,'async');
                end
            end
        end
        
        %Age related sickness:
        if (UserData.t == UserData.time_to_get_sick_due_to_age) 
            if UserData.sleeping
                UserData.time_to_get_sick_due_to_age = UserData.time_to_get_sick_due_to_age + 259200;
            else
                UserData.time_to_get_sick_due_to_age = UserData.t + 259200;
                UserData.sick = true;
                wavplay(UserData.call,UserData.Fs,'async');
            end
        end

        if UserData.sick
            UserData.time_since_sick = UserData.time_since_sick + UserData.time_step;
            if UserData.time_since_sick == 900
                UserData.care_misses = UserData.care_misses + 1;
                %disp('care miss due to sickness');
            end
            if UserData.time_since_sick == 43200
                UserData.state = 'dead';
                UserData.is_alive = false;
            end
        end

        %Sleeping stuff
        current_time = clock;
        current_hour = current_time(4);
        current_minutes = current_time(5);
    %     current_hour = UserData.current_hour;
    %     current_minutes = UserData.current_minutes;
    %     disp([num2str(current_hour), 'h',num2str(current_minutes)]);
    %     disp(['sleeping_hour:',num2str(UserData.sleeping_hour)]);
    %     disp(['sleeping:',num2str(UserData.sleeping)]);
        if current_hour == UserData.sleeping_hour && ~UserData.sleeping
            UserData.sleeping = true;
            disp('Tamagotchi fell asleep');
            wavplay(UserData.call,UserData.Fs,'async');
        end

        if UserData.sleeping && UserData.lights_on
            UserData.time_since_needs_lights_off = UserData.time_since_needs_lights_off + UserData.time_step;
            if UserData.time_since_needs_lights_off == 900
                UserData.care_misses = UserData.care_misses+1;
                %disp('Lights on care miss');
            end
        end

        %Waking up
        if current_hour == UserData.waking_hour && UserData.sleeping
            UserData.sleeping = false;
            UserData.position(2) = 12;
            UserData.lights_on = true;
        end

        %Aging
        %if it's midnight
        if current_hour == 0 && current_minutes == 0
            %if one day has passed since last update
            if UserData.t - UserData.time_since_last_aged >= 86400
                %update time since last aged
                UserData.time_since_last_aged = UserData.t;
                %age
                UserData.age = UserData.age + 1;
            end
        end

        if UserData.care_misses == 50 || UserData.t == 2160300
            disp('Your Tamagotchi has died')
            UserData.state = 'dead';
            UserData.is_alive = false;
        end

    end

    %System stuff
    if UserData.icon_number > 0 && UserData.counting_icon_time
        UserData.time_since_icon_lit = UserData.time_since_icon_lit + UserData.time_step;
    end
    if UserData.time_since_icon_lit == 10
        UserData.icon_number=0;
        UserData.time_since_icon_lit=0;
    end
end