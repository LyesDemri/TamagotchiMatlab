determine_evolution_character

HgHLP=TamagotchiData{2,col};
HpHLP=TamagotchiData{3,col};
TTP=TamagotchiData{4,col};
TSLP=0;
%On va s'occuper du dodo plus tard
new_sleeping_hour=TamagotchiData{5,col};
new_waking_hour=TamagotchiData{6,col};

TTE=TTE+TamagotchiData{7,col};

UserData.time_to_lose_stomach_heart=HgHLP;
UserData.time_to_lose_happy_heart=HpHLP;
UserData.base_weight = TamagotchiData{8,col};
UserData.weight = max(UserData.base_weight,UserData.weight);
UserData.position(1)=TamagotchiData{10,col};
UserData.walks=TamagotchiData{9,col};
UserData.sleeping_hour = new_sleeping_hour;
UserData.waking_hour = new_waking_hour;


if open_time(4)>=new_sleeping_hour || open_time(4)<new_waking_hour
    sleeping=true;
end