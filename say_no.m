[sprite_height,sprite_width,osef] = size(UserData.tama_no{UserData.even+1});
top = UserData.position(1);
bottom = UserData.position(1)+sprite_height-1;
left = 17-sprite_width/2;
right = 17+sprite_width/2-1;

screen(top:bottom,left:right,:)=UserData.tama_no{UserData.even+1};
UserData.no_anim_counter = UserData.no_anim_counter + 0.5;

if UserData.no_anim_counter == 2
    UserData.state = UserData.old_state;
end