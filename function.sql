/*
    FUNCTION 1
*/

CREATE OR REPLACE FUNCTION podsumowanie_kwoty_do_zaplaty(pesel Klienci.pesel % TYPE)
RETURN NUMBER
AS
    CURSOR podsumowanie_rezerwacji 
    IS 
        SELECT
            k.pesel AS pesel_klienta,
            ((r.data_wyjazdu - r.data_przyjazdu) * cp.cena) AS cena_za_rezerwacje
        FROM
            Klienci k 
                INNER JOIN Rezerwacje r ON k.id_klienta = r.id_klienta 
                INNER JOIN Ceny_pokoi cp ON r.id_pokoju = cp.id_pokoju AND 
                                            (
                                                r.data_rezerwacji BETWEEN cp.data_obowiazywania_od AND cp.data_obowiazywania_do OR 
                                                (cp.data_obowiazywania_do IS NULL AND r.data_rezerwacji >= cp.data_obowiazywania_od)
                                            )
                                                 
        WHERE 
            r.status = 'N';
            
    pr podsumowanie_rezerwacji % ROWTYPE;  
    kwota_do_zaplaty Ceny_pokoi.cena % TYPE := 0;

    BEGIN
        OPEN podsumowanie_rezerwacji;
        
        LOOP 
            FETCH podsumowanie_rezerwacji INTO pr;
            EXIT WHEN podsumowanie_rezerwacji % NOTFOUND;
            
            IF pr.pesel_klienta = pesel
                THEN
                    kwota_do_zaplaty := kwota_do_zaplaty + pr.cena_za_rezerwacje;
            END IF;
        END LOOP;
        
        CLOSE podsumowanie_rezerwacji;
        
        return kwota_do_zaplaty;
    END;
    
-- TEST -->

SELECT 
    pesel AS "PESEL",
    podsumowanie_kwoty_do_zaplaty(pesel) AS "PODSUMOWANIE"
FROM 
    Klienci;
    
-- TEST <--
    
/*
    FUNCTION 2
*/

CREATE OR REPLACE FUNCTION ilosc_wolnych_msc_parkingowych(zadana_data Rezerwacje.data_przyjazdu % TYPE)
RETURN NUMBER
AS
    CURSOR miejsca_parkingowe
    IS
        SELECT 
            wp.id_pokoju AS numer_pokoju,
            r.data_przyjazdu AS data_przybycia,
            r.data_wyjazdu AS data_odjazdu
        FROM Wyposazenia_pokoi wp
            LEFT JOIN Rezerwacje r on wp.id_pokoju = r.id_pokoju
        WHERE
            wp.id_wyposazenia = (SELECT w.id_wyposazenia FROM Wyposazenia w WHERE w.nazwa = 'parking');

    mp miejsca_parkingowe % ROWTYPE;  
    liczba_wolnych_miejsc number := 0;
    
    BEGIN
        OPEN miejsca_parkingowe;
        LOOP 
            FETCH miejsca_parkingowe INTO mp;
            EXIT WHEN miejsca_parkingowe % NOTFOUND;
            
            IF mp.data_przybycia IS NULL
                THEN
                    liczba_wolnych_miejsc := liczba_wolnych_miejsc + 1;
            ELSIF zadana_data < mp.data_przybycia
                THEN
                    liczba_wolnych_miejsc := liczba_wolnych_miejsc + 1;
            ELSIF zadana_data > mp.data_odjazdu
                THEN
                    liczba_wolnych_miejsc := liczba_wolnych_miejsc + 1;
            END IF;
        END LOOP;
        CLOSE miejsca_parkingowe;
    
    return liczba_wolnych_miejsc;
END;

-- TEST <--

SET SERVEROUTPUT ON
DECLARE 
   rezultat number := 0;
   zadana_data date := '2018-09-14';
BEGIN 
   rezultat := ilosc_wolnych_msc_parkingowych(zadana_data); 
   dbms_output.put_line('Liczba wolnych miejsc parkingowych w dniu ' || TO_CHAR(zadana_data) || ' wynosila: ' || rezultat); 
END;

DECLARE 
   rezultat number := 0;
   zadana_data date := '2018-07-15';
BEGIN 
   rezultat := ilosc_wolnych_msc_parkingowych(zadana_data); 
   dbms_output.put_line('Liczba wolnych miejsc parkingowych w dniu ' || TO_CHAR(zadana_data) || ' wynosila: ' || rezultat); 
END; 

ROLLBACK;

-- TEST <--

/*
    FUNCTION 3
*/

CREATE OR REPLACE FUNCTION zysk_z_pokoju(
                            numer_pokoju Pokoje.numer % TYPE, 
                            data_od Rezerwacje.data_przyjazdu % TYPE,
                            data_do Rezerwacje.data_wyjazdu % TYPE)
RETURN NUMBER
AS
    CURSOR rezerwacje_pokoju
    IS
        SELECT 
            r.data_przyjazdu AS data_przybycia,
            r.data_wyjazdu AS data_odjazdu,
            cp.cena AS cena_pokoju
        FROM Rezerwacje r
            INNER JOIN Ceny_pokoi cp on r.id_pokoju = cp.id_pokoju AND 
                                            (
                                                r.data_rezerwacji BETWEEN cp.data_obowiazywania_od AND cp.data_obowiazywania_do OR 
                                                (cp.data_obowiazywania_do IS NULL AND r.data_rezerwacji >= cp.data_obowiazywania_od)
                                            )
        WHERE
            r.id_pokoju = (SELECT p.id_pokoju FROM Pokoje p WHERE p.numer = numer_pokoju);
            
    zysk number := 0;
    start_date number := 0;
    end_date number := 0;
    business_date varchar2(10);
    rp rezerwacje_pokoju % ROWTYPE;
    
    BEGIN
        OPEN rezerwacje_pokoju;
        
        start_date := to_number(to_char(data_od, 'j'));
        end_date := to_number(to_char(data_do, 'j'));
        
        LOOP 
            FETCH rezerwacje_pokoju INTO rp;
            EXIT WHEN rezerwacje_pokoju % NOTFOUND;
            
            FOR cur_r IN start_date..end_date LOOP
                business_date := to_char(to_date(cur_r, 'j'), 'yyyy-MM-dd');
                IF business_date >= rp.data_przybycia AND business_date <= rp.data_odjazdu
                    THEN
                        zysk := zysk + rp.cena_pokoju;
                END IF;
            END LOOP;
            
        END LOOP;
        
        CLOSE rezerwacje_pokoju;
        
    return zysk;
END;

-- TEST <--

SET SERVEROUTPUT ON

DECLARE 
   rezultat number := 0;
   nr_pokoju number := 104;
   od date := '2018-09-01';
   do date := '2018-11-01';
BEGIN 
    rezultat := zysk_z_pokoju(nr_pokoju, od, do);
    dbms_output.put_line('Pokoj nr ' || TO_CHAR(nr_pokoju) || ' zarobil: ' || rezultat);
END; 

DECLARE 
   rezultat number := 0;
   nr_pokoju number := 107;
   od date := '2018-09-01';
   do date := '2018-09-20';
BEGIN 
    rezultat := zysk_z_pokoju(nr_pokoju, od, do);
    dbms_output.put_line('Pokoj nr ' || TO_CHAR(nr_pokoju) || ' zarobil: ' || rezultat);
END; 

ROLLBACK;

-- TEST <--