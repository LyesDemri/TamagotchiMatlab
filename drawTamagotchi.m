%disp('drawing tamagotchi')
screen=ones(16,32,3);


switch UserData.state
    case 'food choice'
        if UserData.pointed_food == 1
            screen(1:8,1:8,:)=UserData.right_arrow;
        elseif UserData.pointed_food == 2
            screen(9:16,1:8,:)=UserData.right_arrow;
        end
        screen(1:8,17:24,:)=UserData.Food{1,1};
        screen(9:16,17:24,:)=UserData.Food{1,2};
    case 'game intro screen'
        if ~UserData.sound_played
            UserData.sound_played = true;
            wavplay(UserData.game_begin,UserData.Fs,'async');
        end
        screen(1:8,9:16,:)=UserData.full_heart;
        screen(1:8,25:32,:)=UserData.full_heart;
        screen(9:16,1:8,:)=UserData.empty_heart;
        screen(9:16,17:24,:)=UserData.empty_heart;
        UserData.counter = UserData.counter+0.5;
        if UserData.counter == 2.5
            UserData.state = 'playing';
        end
    case 'eating'
        eating_animation
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'saying no food'
        say_no_food
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'saying no'
        say_no
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'idle'
        %If Tamagotchi is not sick
        if UserData.sick == false
            %If it's sleeping
            if UserData.sleeping
                %Draw it sleeping
                [sprite_height,sprite_width,osef] = size(UserData.tama_sleep{UserData.even+1});
                top = UserData.position(1);
                bottom = UserData.position(1)+sprite_height-1;
                left = 17-sprite_width/2;
                right = 17+sprite_width/2-1;
                screen(top:bottom,left:right,:)=UserData.tama_sleep{UserData.even+1};
                %Draw Z's
                screen(top:top+7,min(right+3,25):min(right+10,32),:)=UserData.Zs{UserData.even+1};
                %Draw the poop
                if UserData.dirty
                  screen(9:16,25:32,:)=UserData.poop{UserData.even+1};
                    UserData.position(2)=min(UserData.position(2),17);
                end
            %If it's awake:
            else
                %Draw it
                %This code's getting messy
                k=floor((rem(floor(UserData.t*2),4))/2)+1;
                step=(randi(2)-1.5)*4;
                if step>0
                    sprite = UserData.tama_idle_right;
                else
                    sprite = UserData.tama;
                end
                if UserData.walks
                    [sprite_height,sprite_width,osef] = size(sprite{k});
                    
                    UserData.position(2)=UserData.position(2)+step;
                    UserData.position(2)=min(UserData.position(2),32-sprite_width+1);
                    UserData.position(2)=max(UserData.position(2),1);
                    screen(UserData.position(1):UserData.position(1)+sprite_height-1,...
                           UserData.position(2):UserData.position(2)+sprite_width-1,:)=sprite{k};
                else
                    [sprite_height,sprite_width,osef] = size(UserData.tama_sleep{UserData.even+1});
                    top = UserData.position(1);
                    bottom = UserData.position(1)+sprite_height-1;
                    left = 17-sprite_width/2;
                    right = 17+sprite_width/2-1;
                    screen(top:bottom,left:right,:)=UserData.tama{UserData.even+1};
                end
            end
            %Draw the poop
            if UserData.dirty
                screen(9:16,25:32,:)=UserData.poop{UserData.even+1};
                UserData.position(2)=min(UserData.position(2),17);
            end
            
        %If tamagotchi is sick
        else
            %If it's sleeping
            if UserData.sleeping
                %Draw the tamagotchi sleeping
                [sprite_height,sprite_width,osef] = size(UserData.tama_sleep{UserData.even+1});
                top = UserData.position(1);
                bottom = UserData.position(1)+sprite_height-1;
                left = 17-sprite_width/2;
                right = 17+sprite_width/2-1;
                screen(top:bottom,left:right,:)=UserData.tama_sleep{UserData.even+1};
                %Draw the Z's
                screen(top:top+7,min(right+3,25):min(right+10,32),:)=UserData.Zs{UserData.even+1};
                %Draw the poop
                if UserData.dirty
                    screen(9:16,25:32,:)=UserData.poop{UserData.even+1};
                end
                %I don't think it's necessary to draw the skull
            %If it's awake,
            else
                %Draw it sick
                [sprite_height,sprite_width,osef] = size(UserData.tama_sick{UserData.even+1});
                top = UserData.position(1);
                bottom = UserData.position(1)+sprite_height-1;
                left = 17-sprite_width/2;
                right = 17+sprite_width/2-1;
                screen(top:bottom,left:right,:)=UserData.tama_sick{UserData.even+1};
                %Draw the skull
                screen(1:8,25:32,:)=UserData.skull;
                %Draw the poop
                if UserData.dirty
                    screen(9:16,25:32,:)=UserData.poop{UserData.even+1};
                end
            end
        end
        
        if ~UserData.lights_on
            screen = zeros(16,32,3);
            if UserData.sleeping
                screen(1:8,17:24,:)=UserData.DarkZs{UserData.even+1};
            end
        end
            
    case 'playing'
        sprite = UserData.tama_play{UserData.even+1};
        [sprite_height,sprite_width,osf] = size(sprite);
        top = UserData.position(1);
        bottom = UserData.position(1)+sprite_height-1;
        left = 17-sprite_width/2;
        right = 17 + sprite_width/2 -1;
        screen(top:bottom,left:right,:)=sprite;
        wavplay(UserData.flip_sound,UserData.Fs,'async');
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'happy'
        happy_animation;
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'dead'
        dead_screen;
    case 'unhappy'
        unhappy_animation;
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'game show direction'
        show_game_direction;
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'display game results'
        screen(1:8,1:8,:) = UserData.face_icon;
        screen(1:8,17:24,:) = UserData.empty_heart;
        screen(9:16,5:8,:) = UserData.Numbers{UserData.score+1};
        screen(9:16,9:16,:) = UserData.vs;
        screen(9:16,19:22,:) = UserData.Numbers{5-UserData.score+1};
        UserData.counter = UserData.counter + 0.5;
        if UserData.counter == 2
            %Setting up happy or unhappy animation
            UserData.happy_step = 0;
            UserData.even = 0;
            %Check whether we've won
            if UserData.score >=3
                %If so, play sound
                wavplay(UserData.good_sound,UserData.Fs);
                %Show happy animation
                UserData.state = 'happy';
                %Update happy stats
                UserData.happy = min(UserData.happy+1,4);
                UserData.time_since_happy_changed=0;
                UserData.time_since_unhappy = 0;
            else    %if we haven't won
                %play angry sound
                wavplay(UserData.bad_sound,UserData.Fs);
                %Show unhappy animation.
                UserData.state = 'unhappy';
            end
            %Preparing for next game:
            UserData.old_state='game intro screen';
            UserData.sound_played = false;
            UserData.i=1;
            UserData.score=0;
        end
    case 'displaying status 1'
        screen(1:8,1:8,:) = UserData.face_icon;
        tens = floor(UserData.age/10);
        units = UserData.age-tens*10;
        if tens>0
            screen(1:8,11:14,:) = UserData.Numbers{tens+1};
        end
        screen(1:8,18:21,:) = UserData.Numbers{units+1};
        screen(1:8,25:32,:) = UserData.yr;
        screen(9:16,1:8,:) = UserData.scale_icon;
        tens = floor(UserData.weight/10);
        units = UserData.weight-tens*10;
        if tens>0
            screen(9:16,11:14,:) = UserData.Numbers{tens+1};
        end
        screen(9:16,18:21,:) = UserData.Numbers{units+1};
        screen(9:16,25:32,:) = UserData.lb;
    case 'displaying status 2'
        screen(1:16,1:32,:) = UserData.discipline_screen;
        i=0;
        bar(1:2,1,1:3) = 0;
        if UserData.discipline > 0
            screen(13:14,4, 1:3) = bar;
            screen(13:14,6, 1:3) = bar;
            screen(13:14,8, 1:3) = bar;
            if UserData.discipline > 1
                screen(13:14,10, 1:3) = bar;
                screen(13:14,12, 1:3) = bar;
                screen(13:14,14, 1:3) = bar;
                screen(13:14,16, 1:3) = bar;
                if UserData.discipline > 2
                	screen(13:14,18, 1:3) = bar;
                    screen(13:14,20, 1:3) = bar;
                    screen(13:14,22, 1:3) = bar;
                    if UserData.discipline > 3
                        screen(13:14,24, 1:3) = bar;
                        screen(13:14,26, 1:3) = bar;
                        screen(13:14,28, 1:3) = bar;
                        screen(13:14,30, 1:3) = bar;
                    end
                end
            end
        end
    case 'displaying status 3'
        screen(1:8,1:24,:) = UserData.hungry_word;
        i=1;
        j=1;
        while i<5
            if i>UserData.stomach
                screen(9:16,(i-1)*8+1:(i-1)*8+8,:)=UserData.empty_heart;
            else
                screen(9:16,(i-1)*8+1:(i-1)*8+8,:)=UserData.full_heart;
            end
            i=i+1;
        end
    case 'displaying status 4'
        screen(1:8,1:24,:) = UserData.happy_word;
        i=1;
        j=1;
        while i<5
            if i>UserData.happy
                screen(9:16,(i-1)*8+1:(i-1)*8+8,:)=UserData.empty_heart;
            else
                screen(9:16,(i-1)*8+1:(i-1)*8+8,:)=UserData.full_heart;
            end
            i=i+1;
        end
    case 'pooping'
        sprite = UserData.tama_no{1};
        [sprite_height,sprite_width,osf] = size(sprite);
        top = UserData.position(1);
        bottom = UserData.position(1)+sprite_height-1;
        left = 17-sprite_width/2;
        right = 17 + sprite_width/2 -1;
        screen(top:bottom,left+UserData.even:right+UserData.even,:)=UserData.tama_no{1};
        UserData.pooping_animation_counter = UserData.pooping_animation_counter +0.5;
        if UserData.pooping_animation_counter == 4
            UserData.state = 'done pooping';
            UserData.poop_number = UserData.poop_number + 1;
            UserData.dirty=true;
            UserData.done_poop_animation_counter = 0;
        end
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'done pooping'
        sprite = UserData.tama_happy;
        [sprite_height,sprite_width,osf] = size(sprite);
        top = UserData.position(1);
        bottom = UserData.position(1)+sprite_height-1;
        left = 17-sprite_width/2;
        right = 17 + sprite_width/2 -1;
        screen(top:bottom,left:right,:)=UserData.tama_happy;
        screen(9:16,25:32,:)=UserData.poop{UserData.even+1};
        UserData.done_poop_animation_counter = UserData.done_poop_animation_counter + 0.5;
        if UserData.done_poop_animation_counter == 2
            UserData.state = 'idle';
            UserData.done_poop_animation_counter = 0;
        end
        if ~UserData.lights_on
            screen = zeros(16,32,3);
        end
    case 'evolving'
        screen(1:16,1:32,:) = UserData.evolving_screen;
        UserData.evolving_screen_counter = UserData.evolving_screen_counter + 0.5;
        if UserData.evolving_screen_counter == 2.5
            UserData.state = 'idle';
        end
    case 'egg'
        screen(1:16,9:24,:) = UserData.Egg{UserData.even+1};
    case 'egg shaking'
        switch UserData.hatching_animation_counter
            case {0,1,2,3}
                x = 1-UserData.even;
                screen(1:16,9+x:24+x,:)=UserData.Egg{2};
            case {4,5,6}
                screen(1:16,9:24,:) = UserData.Hatching;
            case 7
                wavplay(UserData.call,UserData.Fs,'async');
                UserData.state = 'idle';
        end
        UserData.hatching_animation_counter = UserData.hatching_animation_counter + 1;
end

screen = imresize(screen,[150 300],'nearest');
screen = [ones(75,300,3);screen;ones(75,300,3)];


if UserData.icon_number == 1
    screen(1:75,1:75,:)=UserData.Food_icon;
elseif UserData.icon_number == 2
    screen(1:75,76:150,:)=UserData.Lights_icon;
elseif UserData.icon_number == 3
    screen(1:75,151:225,:)=UserData.Game_icon;
elseif UserData.icon_number == 4
    screen(1:75,226:300,:)=UserData.Medicine_icon;
elseif UserData.icon_number == 5
    screen(226:300,1:75,:)=UserData.Toilet_icon;
elseif UserData.icon_number == 6
    screen(226:300,76:150,:)=UserData.Status_icon;
elseif UserData.icon_number == 7
    screen(226:300,151:225,:)=UserData.Training_icon;
end


if (UserData.time_since_hungry > 0 && UserData.time_since_hungry <=900) ||...
   (UserData.time_since_unhappy > 0 && UserData.time_since_unhappy <=900) ||...
   (UserData.time_since_needs_discipline > 0 && UserData.time_since_needs_discipline <=900) ||...
   (UserData.time_since_sick > 0 && UserData.time_since_sick <= 900)

    screen(226:300,226:300,:)=UserData.Attention_icon;
end

screen(75,:,:)=0;
screen(226,:,:)=0;

UserData.even = 1-UserData.even;

obj.UserData=UserData;

imshow(screen,'Parent',UserData.handles.axes1);

%disp('done drawing')