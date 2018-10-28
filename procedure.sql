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
    
ROLLBACK;

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

CREATE OR REPLACE PROCEDURE nowa_rezerwacja (
                                numer_pokoju Pokoje.numer % TYPE, 
                                numer_pesel Klienci.pesel % TYPE, 
                                imieK Klienci.imie % TYPE,
                                nazwiskoK Klienci.nazwisko % TYPE,
                                data_przyjazduK Rezerwacje.data_przyjazdu % TYPE,
                                data_wyjazduK rezerwacje.data_wyjazdu % TYPE
                                )
IS
    CURSOR dostepny_pokoj
    IS
        SELECT
            p.id_pokoju pokoj_id,
            p.numer pokoj_numer,
            p.liczba_osob pokoj_losob,
            p.status pokoj_status
        FROM pokoje p;
    
    dp dostepny_pokoj % ROWTYPE;  
    iterator NUMBER := 0;
    nowe_id_pokoju Pokoje.id_pokoju % TYPE;
    nowe_id_klienta Klienci.id_klienta % TYPE;
    nowe_id_rezerwacji Rezerwacje.id_rezerwacji % TYPE;
    liczba_klientow number := 0;
    max_liczba_osob_w_pokoju pokoje.liczba_osob % TYPE;
    lista_pokoi VARCHAR2(100);
    
    BEGIN
        OPEN dostepny_pokoj;
            LOOP
                FETCH dostepny_pokoj INTO dp;
                EXIT WHEN iterator > 0 OR dostepny_pokoj % NOTFOUND;
                
                IF (dp.pokoj_numer = numer_pokoju AND dp.pokoj_status = 'W') THEN
                    nowe_id_pokoju := dp.pokoj_id;                    
                    iterator := iterator + 1;
                ELSIF (dp.pokoj_numer = numer_pokoju AND dp.pokoj_status = 'Z') THEN
                    max_liczba_osob_w_pokoju := dp.pokoj_losob;
                END IF;
            END LOOP;
            
            CLOSE dostepny_pokoj;
            
            IF (iterator = 1)
            THEN            
                SELECT count(id_klienta)
                    INTO nowe_id_klienta 
                    FROM klienci 
                    WHERE pesel = numer_pesel;
                    
                IF (nowe_id_klienta = 0)
                THEN
                    SELECT max(k.id_klienta)
                        INTO nowe_id_klienta 
                        FROM klienci k;
                        
                        nowe_id_klienta := nowe_id_klienta + 1;
                        INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(nowe_id_klienta, numer_pesel, imieK, nazwiskoK);
                        
                        DBMS_OUTPUT.PUT_LINE('Dodano nowego klienta');  
                END IF;
                
                SELECT max(id_rezerwacji) 
                    INTO nowe_id_rezerwacji 
                    FROM rezerwacje;
                
                INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) 
                    VALUES(nowe_id_rezerwacji+1, CURRENT_DATE, data_przyjazduK, data_wyjazduK, 'N', nowe_id_klienta, nowe_id_pokoju);
                    
                DBMS_OUTPUT.PUT_LINE('Dodano rezerwacje');  
            ELSE
                OPEN dostepny_pokoj;
                DBMS_OUTPUT.PUT_LINE('Podany pokoj jest zajety');
                
                LOOP
                    FETCH dostepny_pokoj INTO dp;
                    EXIT WHEN dostepny_pokoj % NOTFOUND;
                    IF(max_liczba_osob_w_pokoju = dp.pokoj_losob AND dp.pokoj_status = 'W') THEN
                        IF (LENGTH(lista_pokoi) > 0)
                        THEN
                            lista_pokoi := lista_pokoi || ', ' || TO_CHAR(dp.pokoj_numer);
                        ELSE
                            lista_pokoi := TO_CHAR(dp.pokoj_numer);
                        END IF;
                    END IF;
                END LOOP;
                
                IF (LENGTH(lista_pokoi) > 0) 
                    THEN
                        DBMS_OUTPUT.PUT_LINE('List dostepnych podobnych pokoi:');
                        DBMS_OUTPUT.PUT_LINE(lista_pokoi);
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('Nie znaleziono podobnych pokoi');   
                    END IF;
                
                CLOSE dostepny_pokoj;
            END IF;
            
        EXCEPTION 
            WHEN NO_DATA_FOUND 
                THEN 
                    DBMS_OUTPUT.PUT_LINE('Nie znaleziono!');
            WHEN OTHERS 
                THEN 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->

SET SERVEROUTPUT ON

SELECT
    *
FROM
    Pokoje;
    
SELECT
    *
FROM
    Rezerwacje;
    
BEGIN
  nowa_rezerwacja(108, '00000000001', 'Jan', 'Kowalski', '2018-12-02', '2018-12-11');
END;

SELECT
    *
FROM
    Pokoje;
    
SELECT
    *
FROM
    Rezerwacje;
    
SELECT
    *
FROM
    Klienci;
    
BEGIN
  nowa_rezerwacja(108, '00000000001', 'Jan', 'Kowalski', '2018-12-02', '2018-12-11');
END;

ROLLBACK;

-- TEST -->