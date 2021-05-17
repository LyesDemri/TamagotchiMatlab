[sprite_height,sprite_width,osef] = size(UserData.tama_eat{1});
top = UserData.position(1);
bottom = UserData.position(1)+sprite_height-1;
left = 17-sprite_width/2;
right = 17+sprite_width/2-1;

%Draw tamagotchi
if UserData.direction == 'R'
    screen(top:bottom,left:right,:)=UserData.tama_right;
else
    screen(top:bottom,left:right,:)=UserData.tama_left;
end
if UserData.guess == 'R'
    screen(9:16,25:32,:)=UserData.right_arrow;
elseif UserData.guess == 'L'
    screen(9:16,1:8,:)=UserData.left_arrow;
end

UserData.counter = UserData.counter + 0.5;
if UserData.counter == 1
    if UserData.guess == UserData.direction
        UserData.old_state='playing';
        UserData.even = 0;
        UserData.happy_step = 4;
        UserData.state = 'happy';
        UserData.score = UserData.score+1;
        wavplay(UserData.good_sound,UserData.Fs);
    else
        UserData.old_state='playing';
        UserData.even = 0;
        UserData.happy_step = 4;
        UserData.state = 'unhappy';
        wavplay(UserData.bad_sound,UserData.Fs);
    end
    UserData.i=UserData.i+1;
end

%If we've played 5 rounds,
if UserData.i > 5
    wavplay(UserData.display_results_sound,UserData.Fs,'async');
    UserData.counter = 0;
    UserData.state = 'display game results';

    if ~strcmp(UserData.character,'Babytchi');
        UserData.weight = max(UserData.weight - 2, UserData.base_weight);
    end
end