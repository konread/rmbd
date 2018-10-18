/*
    PROCEDURE 1
*/

CREATE OR REPLACE PROCEDURE ustaw_cene_pokoju(numer_pokoju Pokoje.numer % TYPE, cena Ceny_pokoi.cena % TYPE)
IS
    CURSOR aktualne_ceny_pokoi
    IS
        SELECT
            p.id_pokoju p_id,
            p.numer p_nr,
            cp.id_ceny_pokoju cp_id,
            cp.cena cp_cena
        FROM 
            Pokoje p INNER JOIN Ceny_pokoi cp ON p.id_pokoju = cp.id_pokoju
        WHERE
            cp.status = 'A';
    
    acp aktualne_ceny_pokoi % ROWTYPE;  
    iterator NUMBER := 0;
    nowa_data_ustawienia DATE := CURRENT_DATE;
    nowe_id_ceny_pokoju Ceny_pokoi.id_ceny_pokoju % TYPE;
    nowe_id_pokoju Pokoje.id_pokoju % TYPE;
    status_a Ceny_pokoi.status % TYPE := 'A';
    status_n Ceny_pokoi.status % TYPE := 'N';
    
    BEGIN
        OPEN aktualne_ceny_pokoi;
        
            LOOP 
                FETCH aktualne_ceny_pokoi INTO acp;
                EXIT WHEN iterator > 0 OR aktualne_ceny_pokoi % NOTFOUND;
                
                IF acp.p_nr = numer_pokoju
                    THEN
                        nowe_id_pokoju := acp.p_id;
                        nowe_id_ceny_pokoju := acp.cp_id;
                        
                        iterator := iterator + 1;
                END IF;
            END LOOP;
            
            IF iterator = 1
                THEN
                    UPDATE
                        Ceny_pokoi
                    SET 
                        status = status_n,
                        data_obowiazywania_do = nowa_data_ustawienia
                    WHERE 
                        id_ceny_pokoju = nowe_id_ceny_pokoju;
            ELSE
                SELECT 
                    id_pokoju INTO nowe_id_pokoju
                FROM 
                    Pokoje
                WHERE 
                    numer = numer_pokoju;
            END IF;
            
            SELECT 
                MAX(id_ceny_pokoju) INTO nowe_id_ceny_pokoju
            FROM 
                Ceny_pokoi;
            
            INSERT INTO 
                Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status)
            VALUES
                (nowe_id_ceny_pokoju + 1, cena, nowa_data_ustawienia, null, nowe_id_pokoju, status_a); 
                
        CLOSE aktualne_ceny_pokoi;
        
        EXCEPTION 
            WHEN NO_DATA_FOUND 
                THEN 
                    DBMS_OUTPUT.PUT_LINE('Nie znaleziono pokoju!');
            WHEN OTHERS 
                THEN 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END;
    
-- TEST -->

SELECT
    p.id_pokoju,
    p.numer,
    cp.id_ceny_pokoju,
    cp.cena,
    cp.status,
    cp.data_obowiazywania_od,
    cp.data_obowiazywania_do
FROM 
    Pokoje p INNER JOIN Ceny_pokoi cp ON p.id_pokoju = cp.id_pokoju;
    
BEGIN
  ustaw_cene_pokoju(102, 620.00);
END;

SELECT
    p.id_pokoju,
    p.numer,
    cp.id_ceny_pokoju,
    cp.cena,
    cp.status,
    cp.data_obowiazywania_od,
    cp.data_obowiazywania_do
FROM 
    Pokoje p INNER JOIN Ceny_pokoi cp ON p.id_pokoju = cp.id_pokoju;
    
-- RUN EXCEPTION -->

SET SERVEROUTPUT ON
BEGIN
  ustaw_cene_pokoju(120, 620.00);
END;

-- RUN EXCEPTION <--

-- TEST <--
    
/*
    PROCEDURE 2
*/

-- cd.
