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

-- cd.