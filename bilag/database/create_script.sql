-- Eksempel på Database Create Script for Bilabonnement.dk internt system
-- Opret tabeller til den interne database

-- Brugere af systemet
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Biler
CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    vin_number VARCHAR(17) UNIQUE NOT NULL,
    car_number VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    model_year INT NOT NULL,
    color VARCHAR(50),
    fuel_type ENUM('Benzin', 'Diesel', 'El', 'Hybrid', 'Plugin-hybrid') NOT NULL,
    registration_number VARCHAR(10) UNIQUE,
    current_km INT,
    status ENUM('Ledig', 'Udlejet', 'Under Klargøring', 'Til Salg', 'Solgt', 'Reserveret') NOT NULL DEFAULT 'Ledig',
    notes TEXT,
    purchase_date DATE,
    purchase_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Kunder (Minimal information - primær data i eksternt system)
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    external_id VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Lejeaftaler
CREATE TABLE rental_agreements (
    agreement_id INT AUTO_INCREMENT PRIMARY KEY,
    agreement_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    subscription_type ENUM('Limited', 'Unlimited') NOT NULL,
    monthly_price DECIMAL(10, 2) NOT NULL,
    deposit_amount DECIMAL(10, 2) NOT NULL,
    pickup_location VARCHAR(100),
    status ENUM('Oprettet', 'Aktiv', 'Afsluttet', 'Opsagt') NOT NULL DEFAULT 'Oprettet',
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Skader på biler
CREATE TABLE damages (
    damage_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    agreement_id INT,
    description TEXT NOT NULL,
    damage_date DATE NOT NULL,
    severity ENUM('Kosmetisk', 'Mindre', 'Moderat', 'Alvorlig') NOT NULL,
    repair_status ENUM('Registreret', 'Under Udbedring', 'Udbedret', 'Ikke Udbedret') NOT NULL DEFAULT 'Registreret',
    repair_cost DECIMAL(10, 2),
    reported_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (agreement_id) REFERENCES rental_agreements(agreement_id),
    FOREIGN KEY (reported_by) REFERENCES users(user_id)
);

-- Tilstandsrapporter
CREATE TABLE condition_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    agreement_id INT,
    report_type ENUM('Indlevering', 'Udlevering', 'Periodisk', 'Salg') NOT NULL,
    report_date DATE NOT NULL,
    km_reading INT NOT NULL,
    exterior_condition TEXT,
    interior_condition TEXT,
    mechanical_condition TEXT,
    tire_condition TEXT,
    overall_assessment TEXT NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (agreement_id) REFERENCES rental_agreements(agreement_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Salg af biler
CREATE TABLE car_sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    buyer_name VARCHAR(100) NOT NULL,
    buyer_contact VARCHAR(100),
    sale_date DATE NOT NULL,
    sale_type ENUM('Direkte', 'FDM', 'Opkøber', 'Anden') NOT NULL,
    pre_sale BOOLEAN NOT NULL DEFAULT 0,
    handled_by INT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (handled_by) REFERENCES users(user_id)
);

-- Lager/Lokation af biler
CREATE TABLE car_locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    location_type ENUM('Lager', 'FDM Center', 'Værksted', 'Kunde', 'Andet') NOT NULL,
    contact_person VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bil-lokation relation (historisk sporing)
CREATE TABLE car_location_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    location_id INT NOT NULL,
    arrival_date DATE NOT NULL,
    departure_date DATE,
    status ENUM('Opbevaring', 'Klargøring', 'Reparation', 'Udlejning', 'Til Salg') NOT NULL,
    notes TEXT,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (location_id) REFERENCES car_locations(location_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Tilbageleveringer
CREATE TABLE car_returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    agreement_id INT NOT NULL,
    return_date DATE NOT NULL,
    return_km INT NOT NULL,
    condition_report_id INT,
    damage_costs DECIMAL(10, 2) DEFAULT 0.00,
    excess_km INT DEFAULT 0,
    excess_km_cost DECIMAL(10, 2) DEFAULT 0.00,
    total_cost DECIMAL(10, 2),
    handled_by INT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agreement_id) REFERENCES rental_agreements(agreement_id),
    FOREIGN KEY (condition_report_id) REFERENCES condition_reports(report_id),
    FOREIGN KEY (handled_by) REFERENCES users(user_id)
);

-- Afgangsårsag for lejemål
CREATE TABLE agreement_terminations (
    termination_id INT AUTO_INCREMENT PRIMARY KEY,
    agreement_id INT NOT NULL,
    termination_date DATE NOT NULL,
    reason ENUM('Udløb', 'Opsagt af kunde', 'Opsagt af Bilabonnement', 'Andet') NOT NULL,
    detailed_reason TEXT,
    recorded_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agreement_id) REFERENCES rental_agreements(agreement_id),
    FOREIGN KEY (recorded_by) REFERENCES users(user_id)
);

-- Indeks for hurtigere søgninger
CREATE INDEX idx_cars_status ON cars(status);
CREATE INDEX idx_cars_brand_model ON cars(brand, model);
CREATE INDEX idx_rental_agreements_status ON rental_agreements(status);
CREATE INDEX idx_rental_agreements_dates ON rental_agreements(start_date, end_date);
CREATE INDEX idx_damages_repair_status ON damages(repair_status);
CREATE INDEX idx_car_location_history_active ON car_location_history(car_id, departure_date);
