function age_increment=calculateAgeIncrement(closing_date,opening_date)

if etime(opening_date,closing_date)<0
    error('How did you open the soft before you closed it?')
end

age_increment=0;
while etime(opening_date,closing_date)>=24*3600
    disp('plus d''un jour est passé')
    closing_date=datevec(addtodate(datenum(closing_date),1,'day'));
    age_increment=age_increment+1;
end

if closing_date(4)>opening_date(4)
    age_increment=age_increment+1;
elseif closing_date(4)==opening_date(4)
    if closing_date(5)>opening_date(5)
        age_increment=age_increment+1;
    elseif closing_date(5)==opening_date(5)
        if closing_date(6)>opening_date(6)
            age_increment=age_increment+1;
        end
    end
end