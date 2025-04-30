-- Eksempel på Database Insert Script for Bilabonnement.dk internt system
-- Indsæt demo-data til test af systemet

-- Indsæt brugere
INSERT INTO users (username, password, full_name, role, email)
VALUES 
('demo', 'demo', 'Demo Bruger', 'Administrator', 'demo@bilabonnement.dk'),
('dataregister', 'password123', 'Data Register', 'Dataregistrering', 'data@bilabonnement.dk'),
('klargoring', 'password123', 'Klar Gøring', 'Klargøring', 'klar@bilabonnement.dk'),
('skade', 'password123', 'Skade Behandler', 'Skade & Udbedring', 'skade@bilabonnement.dk'),
('okonomi', 'password123', 'Øko Nomi', 'Økonomi', 'okonomi@bilabonnement.dk');

-- Indsæt bil-lokationer
INSERT INTO car_locations (name, address, location_type, contact_person, contact_email, contact_phone)
VALUES 
('Hovedlager København', 'Industrivej 10, 2600 Glostrup', 'Lager', 'Lars Lager', 'lager@bilabonnement.dk', '12345678'),
('FDM Center Aarhus', 'Aarhus Gade 42, 8000 Aarhus C', 'FDM Center', 'Finn FDM', 'fdm@fdm.dk', '87654321'),
('Værksted Odense', 'Værkstedsvej 7, 5000 Odense', 'Værksted', 'Viktor Værksted', 'vaerk@bil.dk', '45678912');

-- Indsæt biler
INSERT INTO cars (vin_number, car_number, brand, model, model_year, color, fuel_type, registration_number, current_km, status, purchase_date, purchase_price)
VALUES 
('WBA12345678901234', 'BIL001', 'BMW', '320i', 2022, 'Sort', 'Benzin', 'AB12345', 10000, 'Udlejet', '2023-01-15', 350000.00),
('VWG98765432109876', 'BIL002', 'Volkswagen', 'Golf', 2021, 'Hvid', 'Benzin', 'CD54321', 15000, 'Udlejet', '2023-02-10', 250000.00),
('TES12345678901234', 'BIL003', 'Tesla', 'Model 3', 2022, 'Rød', 'El', 'EF67890', 5000, 'Ledig', '2023-03-05', 400000.00),
('TOY98765432109876', 'BIL004', 'Toyota', 'Yaris', 2021, 'Blå', 'Hybrid', 'GH45678', 20000, 'Under Klargøring', '2023-01-25', 220000.00),
('AUD12345678901234', 'BIL005', 'Audi', 'A4', 2022, 'Sølv', 'Diesel', 'IJ23456', 12000, 'Til Salg', '2022-12-10', 380000.00);

-- Indsæt kunder
INSERT INTO customers (external_id, name, phone, email)
VALUES 
('CUST001', 'Anders Andersen', '11223344', 'anders@example.com'),
('CUST002', 'Bente Bentsen', '22334455', 'bente@example.com'),
('CUST003', 'Christian Christiansen', '33445566', 'christian@example.com');

-- Indsæt lejeaftaler
INSERT INTO rental_agreements (