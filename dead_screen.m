if UserData.even==0
    screen(1:16,1:16,:)=UserData.ufo;
    screen(1:8,17:24,:)=UserData.stars{1};
    screen(1:8,25:32,:)=UserData.stars{3};
    screen(9:16,17:24,:)=UserData.stars{3};
    screen(9:16,25:32,:)=UserData.stars{2};
elseif UserData.even==1
    screen(1:16,1:16,:)=UserData.ufo2;
    screen(1:8,17:24,:)=UserData.stars{3};
    screen(1:8,25:32,:)=UserData.stars{1};
    screen(9:16,17:24,:)=UserData.stars{2};
    screen(9:16,25:32,:)=UserData.stars{3};
end