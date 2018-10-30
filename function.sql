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