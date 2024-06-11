Create or replace function gregorian_to_jalali3(gregorian_date date)
returns varchar(255) as $$
declare
    gy int; gy2 int; gm int; gd int; days int; jy int; jm int; jd int; g_d_m int[];
begin
    g_d_m := ARRAY[0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    gy := DATE_PART('year', gregorian_date);
    gm := date_part('month', gregorian_date);
    gd := date_part('day', gregorian_date);
    if gm > 2 then
        gy2 = gy + 1;
    else
        gy2 = gy;
    end if;
    days = 355666 + (365 * gy) + FLOOR((gy2 + 3) / 4) - FLOOR((gy2 + 99) / 100) + FLOOR((gy2 + 399) / 400) + gd + g_d_m[gm];
    jy := -1595 + (33 * FLOOR(days / 12053));
    days := days % 12053;
    jy := jy + 4 * Floor(days / 1461);
    days := days % 1461;
    if days > 365 then
        jy := jy + floor(days - 1) / 365;
        days = (days - 1) % 365;
    end if;
    if days < 186 then
      jm := 1 + floor(days / 31);
      jd := 1 + (days % 31);
     else
      jm := 7 + floor((days - 186) / 30);
      jd := 1 + ((days - 186) % 30);
    end if;
    return concat_ws('/', jy, jm, jd);
end;
    $$
language plpgsql;
