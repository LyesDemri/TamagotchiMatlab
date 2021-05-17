%difficulty rate that can easily be changed
rate=8;

switch character
    case 'Babytchi'
        character='Tonmarutchi';
    case 'Tonmarutchi'
        if CM<3*rate
            character='Tongaritchi';
        else
            character='Hashitamatchi';
        end
    case 'Tongaritchi'
        if CM<rate
            character='Mimitchi';
        elseif CM<2*rate
            character='Pochitchi';
        elseif CM<3*rate
            character='Zuccitchi';
        elseif CM<4*rate
            character='Hashizotchi';
        elseif CM<5*rate
            character='Kusatchi';
        else
            character='Takotchi';
        end
    case 'Hashitamatchi'
        if CM<4*rate
            character='Hashizotchi';
        elseif CM<5*rate
            character='Kusatchi';
        else
            character='Takotchi';
        end
    case 'Zuccitchi'
        if CM==2*rate
            character='Zatchi';
        end
    case 'Zatchi'
        if CM==2*rate
            character='Riessutchi';
        end
end

load('TamagotchiData')
for col=2:13
    if strcmp(character,TamagotchiData{1,col})
        break
    end
end
