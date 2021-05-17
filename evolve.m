character=UserData.character;
CM=UserData.care_misses;

determine_evolution_character

UserData.character=character;

load_character;
if ~strcmp(UserData.character,'Babytchi')
    
    wavplay(UserData.evolve_sound,UserData.Fs,'async');
    UserData.evolving_screen_counter = 0;
    UserData.state = 'evolving';
    UserData.time_to_lose_stomach_heart = TamagotchiData{2,col};
    UserData.time_to_lose_happy_heart = TamagotchiData{3,col};
    UserData.time_to_poop = TamagotchiData{4,col};
    UserData.time_since_last_pooped = 0;
    UserData.sleeping_hour = TamagotchiData{5,col};
    UserData.waking_hour = TamagotchiData{6,col};
    UserData.time_to_evolve = UserData.t+TamagotchiData{7,col};
    UserData.base_weight = TamagotchiData{8,col};
    UserData.weight = max(UserData.base_weight,UserData.weight);
    UserData.walks = TamagotchiData{9,col};
    UserData.position(1) = TamagotchiData{10,col};
    UserData.position(2) = 12;
    current_date=clock;
    current_hour=current_date(4);
    if current_hour>=UserData.sleeping_hour || current_hour<UserData.waking_hour
        UserData.sleeping=true;
    else
        UserData.sleeping=false;
    end
end
