DELETE Wyposazenia_pokoi;
DELETE Wyposazenia;
DELETE Rezerwacje;
DELETE Ceny_pokoi;
DELETE Pokoje;
DELETE Klienci;

INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(1, '00000000000', 'Jan', 'Kowalski');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(2, '11111111111', 'Patryk', 'Nowak');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(3, '22222222222', 'Piotr', 'Wisniewski');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(4, '33333333333', 'Robert', 'Lewandowski');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(5, '44444444444', 'Kamil', 'Glik');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(6, '55555555555', 'Jerzy', 'Dudek');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(7, '66666666666', 'Adam', 'Nawalka');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(8, '77777777777', 'Jakub', 'Blaszczykowski');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(9, '88888888888', 'Arkadiusz', 'Milik');
INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(10, '99999999999', 'Kamil', 'Grosicki');

INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(1, 100, 1, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(2, 101, 1, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(3, 102, 1, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(4, 103, 2, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(5, 104, 2, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(6, 105, 2, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(7, 106, 3, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(8, 107, 3, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(9, 108, 3, 'W');
INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(10, 109, 4, 'W');

INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(1, 150.00, '2018-05-10', 1, 'A'); 
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(2, 150.00, '2018-04-12', 2, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(3, 200.00, '2018-06-08', 3, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(4, 150.00, '2018-01-01', 4, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(5, 150.00, '2018-05-10', 5, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(6, 150.00, '2018-04-22', 6, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(7, 150.00, '2018-03-15', 7, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(8, 150.00, '2018-08-10', 8, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(9, 150.00, '2018-07-17', 9, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_ustawienia, id_pokoju, status) VALUES(10, 150.00, '2018-02-18', 10, 'A');