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
    TRIGGER 2
*/

-- cd.