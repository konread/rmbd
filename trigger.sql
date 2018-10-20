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
SELECT
    *
FROM
    Pokoje;
    
INSERT INTO 
    Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) 
VALUES
    (100, '2018-08-20', '2018-09-10', '2018-09-12', 'N', 1, 10);

SELECT
    *
FROM
    Pokoje;
    
ROLLBACK;
-- TEST <--

/*
    TRIGGER 2
*/

CREATE OR REPLACE VIEW 
    Ceny_pokoi_v 
AS 
    SELECT 
        * 
    FROM 
        Ceny_pokoi;

CREATE OR REPLACE TRIGGER 
    usuwanie_ceny_pokoju
INSTEAD OF DELETE ON 
    Ceny_pokoi_v
FOR EACH ROW
DECLARE 
    licznik NUMBER := 0;
    NO_DELETE EXCEPTION;
BEGIN
    SELECT 
        COUNT(*) INTO licznik
    FROM 
        Rezerwacje r INNER JOIN Ceny_pokoi cp ON r.id_pokoju = cp.id_pokoju AND 
                                                 (
                                                     r.data_rezerwacji BETWEEN cp.data_obowiazywania_od AND cp.data_obowiazywania_do OR 
                                                     (cp.data_obowiazywania_do IS NULL AND r.data_rezerwacji >= cp.data_obowiazywania_od)
                                                 )
    WHERE
        cp.id_ceny_pokoju = :OLD.id_ceny_pokoju;
        
    IF licznik = 0
        THEN
            DELETE FROM 
                Ceny_pokoi cp 
            WHERE 
                cp.id_ceny_pokoju = :OLD.id_ceny_pokoju;
    ELSE
        RAISE NO_DELETE;
    END IF;

    EXCEPTION              
        WHEN NO_DELETE 
            THEN 
                --DBMS_OUTPUT.PUT_LINE('W tej cenie zostal juz zarezerwowany pokoj i nie mozna jej usunac!');
                RAISE_APPLICATION_ERROR(-20000,'W tej cenie zostal juz zarezerwowany pokoj i nie mozna jej usunac!');
END;

-- TEST -->

SELECT
    *
FROM
    Ceny_pokoi;

SET SERVEROUTPUT ON;
DELETE FROM 
    Ceny_pokoi_v 
WHERE 
    id_ceny_pokoju = 1;

SELECT
    *
FROM
    Ceny_pokoi;
    
ROLLBACK;

-- RUN EXCEPTION -->

SELECT
    *
FROM
    Ceny_pokoi;

SET SERVEROUTPUT ON;
DELETE FROM 
    Ceny_pokoi_v 
WHERE 
    id_ceny_pokoju = 8;

SELECT
    *
FROM
    Ceny_pokoi;
    
-- RUN EXCEPTION <--
    
-- TEST <--

/*
    TRIGGER 3
*/

-- cd.