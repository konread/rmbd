/*
    TRIGGER 1
*/

CREATE OR REPLACE TRIGGER 
    zarezerwowanie_pokoju
AFTER INSERT ON 
    Rezerwacje
FOR EACH ROW
BEGIN
    UPDATE 
        Pokoje
    SET
        status = 'Z'
    WHERE 
        id_pokoju = :NEW.id_pokoju;
END;

-- TEST -->



-- TEST <--

/*
    TRIGGER 2 (NIE TESTOWANY!)
*/

CREATE OR REPLACE TRIGGER 
    usuwanie_ceny_pokoju
BEFORE DELETE ON 
    Ceny_pokoi
FOR EACH ROW
DECLARE 
    licznik NUMBER := 0;
BEGIN

    SELECT 
        COUNT(*) INTO licznik
    FROM 
        Rezerwacje r INNER JOIN Ceny_pokoi cp ON r.id_pokoju = cp.id_pokoju AND 
                                                 r.data_rezerwacji BETWEEN cp.data_obowiazywania_od AND cp.data_obowiazywania_do;

    IF licznik > 0
        THEN
            raise_application_error(-20000, 'Wystapil blad podczas usuwania ceny pokoju!');
    END IF;
END;

/*
    TRIGGER 3
*/

-- cd.