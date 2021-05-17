[sprite_height,sprite_width,osef] = size(UserData.tama_no{UserData.even+1});
top = UserData.position(1);
bottom = UserData.position(1)+sprite_height-1;
left = 17-sprite_width/2;
right = 17+sprite_width/2-1;

switch UserData.eating_steps
    case 0
        screen(1:8,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{1};
    case 1
        screen(9:16,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{1};
    case 2
        screen(9:16,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{2};
    case 3
        screen(9:16,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{1};
    case 4
        screen(9:16,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{2};
    case 5
        screen(9:16,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{1};
    case 6
        screen(9:16,2:9,:)=UserData.Food{1,UserData.food};
        screen(top:bottom,left:right,:)=UserData.tama_no{2};
        UserData.state = 'food choice';
end
UserData.eating_steps = UserData.eating_steps+1;