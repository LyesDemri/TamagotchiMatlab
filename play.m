state = 'game intro screen';
UserData.counting_icon_time=false;
wavplay(UserData.game_begin,UserData.Fs,'async');


UserData.i=1;
UserData.score = 0;
while UserData.i<=5
    UserData.state = 'playing';
    %generate random direction
    if rand>0.5
        UserData.direction = 'L';
    else
        UserData.direction = 'R';
    end
    
    %compare guess to direction
    if UserData.guess == UserData.direction
        UserData.old_state='playing';
        UserData.state = 'happy';
        UserData.score = UserData.score+1;
        wavplay(UserData.good_sound,UserData.Fs);
        disp('Correct!');
    elseif UserData.guess == 'q'
        break;
    else
        UserData.old_state='playing';
        UserData.state = 'unhappy';
        wavplay(UserData.bad_sound,UserData.Fs);
        disp('Nope!');
    end
    UserData.happy_step=0;
    pause(2);
    %do it again;
    UserData.i=UserData.i+1;
end
UserData.happy_step = 0;
if UserData.i > 5
    if UserData.score >=3
        wavplay(UserData.good_sound,UserData.Fs);
        disp('Won the game! :D')
        UserData.old_state='idle';
        UserData.state = 'happy';
        UserData.happy = UserData.happy+1;
        UserData.time_since_happy_changed=0;
        UserData.time_since_unhappy = 0;
    else
        disp('Lost the game é_è');
        wavplay(UserData.bad_sound,UserData.Fs);
        UserData.old_state='idle';
        UserData.state = 'unhappy';
    end
    pause(4);
    if ~strcmp(UserData.character,'Babytchi');
        UserData.weight = UserData.weight - 2;
    end
else
    state = 'idle';
end
UserData.icon_number=0;
