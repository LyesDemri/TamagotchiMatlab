[sprite_height,sprite_width,osef] = size(UserData.tama_unhappy{1});
top = UserData.position(1);
bottom = UserData.position(1)+sprite_height-1;
left = 17-sprite_width/2;
right = 17+sprite_width/2-1;

if UserData.even==1
    screen(top:bottom,left:right,:)=UserData.tama_unhappy{1};
    screen(top:top+7,right+1:right+8,:)=UserData.cloud1;
else
    if UserData.zmar == 0
        UserData.zmar = 1;
        screen(top:bottom,left:right,:)=UserData.tama_unhappy{2};
    else
        UserData.zmar = 0;
        screen(top:bottom,left:right,:)=UserData.tama_unhappy{3};
    end
    screen(top:top+7,right+1:right+8,:)=UserData.cloud2;
end
UserData.happy_step = UserData.happy_step+1;
if UserData.happy_step ==8
    UserData.state = UserData.old_state;
end

if strcmp(UserData.old_state,'playing') ||...
   strcmp(UserData.old_state,'game intro screen')
    if rand>0.5
        UserData.direction = 'L';
    else
        UserData.direction = 'R';
    end
end