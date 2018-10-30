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

INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(1, 150.00, '2018-05-10', null, 1, 'A'); 
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(2, 150.00, '2018-04-12', null, 2, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(3, 200.00, '2018-06-08', null, 3, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(4, 150.00, '2018-01-01', null, 4, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(5, 150.00, '2018-05-10', null, 5, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(6, 150.00, '2018-04-22', null, 6, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(7, 150.00, '2018-03-15', null, 7, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(8, 150.00, '2018-08-10', null, 8, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(9, 150.00, '2018-07-17', null, 9, 'A');
INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(10, 150.00, '2018-02-18', null, 10, 'A');

INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(1, '2018-08-12', '2018-08-20', '2018-09-02', 'N', 1, 8);
INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(2, '2018-08-20', '2018-09-10', '2018-09-24', 'N', 4, 6);
INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(3, '2018-08-22', '2018-09-11', '2018-09-28', 'N', 5, 5);
INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(4, '2018-08-23', '2018-09-09', '2018-09-22', 'N', 9, 1);
INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(5, '2018-09-02', '2018-09-12', '2018-09-22', 'N', 6, 10);

INSERT INTO Wyposazenia(id_wyposazenia, nazwa, liczba_szt_calk, liczba_szt_dost) VALUES(1, 'telewizor', 3, 2);
INSERT INTO Wyposazenia(id_wyposazenia, nazwa, liczba_szt_calk, liczba_szt_dost) VALUES(2, 'parking', 10, 3);

INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(1,10);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,10);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,9);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,8);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,7);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,6);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,5);
INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(2,4);