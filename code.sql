-- Creating the Hospital Management Database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Creating Patients Table to store patient details
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each patient
    FirstName VARCHAR(50) NOT NULL, -- First name of the patient
    LastName VARCHAR(50) NOT NULL, -- Last name of the patient
    DOB DATE NOT NULL, -- Date of birth of the patient
    Gender ENUM('Male', 'Female', 'Other') NOT NULL, -- Gender of the patient
    ContactNumber VARCHAR(15), -- Contact number
    Address TEXT, -- Address details
    BloodType VARCHAR(5), -- Blood type of the patient
    EmergencyContact VARCHAR(15) -- Emergency contact number
);

-- Creating Doctors Table to store doctor details
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each doctor
    FirstName VARCHAR(50) NOT NULL, -- First name of the doctor
    LastName VARCHAR(50) NOT NULL, -- Last name of the doctor
    Specialty VARCHAR(100) NOT NULL, -- Specialization of the doctor
    ContactNumber VARCHAR(15), -- Contact number
    ExperienceYears INT, -- Years of experience
    AvailableHours TEXT -- Availability hours
);

-- Creating Appointments Table to store patient appointment details
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each appointment
    PatientID INT, -- Reference to patient
    DoctorID INT, -- Reference to doctor
    AppointmentDate DATETIME NOT NULL, -- Date and time of appointment
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled', -- Status of appointment
    Notes TEXT, -- Additional notes for appointment
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID), -- Foreign key linking to Patients
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) -- Foreign key linking to Doctors
);

-- Creating Billing Table to manage billing details
CREATE TABLE Billing (
    BillID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each bill
    PatientID INT, -- Reference to patient
    Amount DECIMAL(10,2) NOT NULL, -- Total billing amount
    PaymentStatus ENUM('Pending', 'Paid') DEFAULT 'Pending', -- Status of payment
    PaymentMethod ENUM('Cash', 'Card', 'Online') DEFAULT 'Cash', -- Payment method
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) -- Foreign key linking to Patients
);

-- Creating Prescriptions Table to manage prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for prescription
    PatientID INT, -- Reference to patient
    DoctorID INT, -- Reference to doctor
    Medication TEXT NOT NULL, -- List of medications prescribed
    Dosage TEXT NOT NULL, -- Dosage instructions
    IssueDate DATE NOT NULL, -- Date of prescription
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID), -- Foreign key linking to Patients
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) -- Foreign key linking to Doctors
);

-- Inserting sample data into Patients table
INSERT INTO Patients (FirstName, LastName, DOB, Gender, ContactNumber, Address, BloodType, EmergencyContact) 
VALUES 
    ('John', 'Doe', '1990-05-15', 'Male', '9876543210', '123 Street, City', 'O+', '9112233445'),
    ('Jane', 'Smith', '1985-08-22', 'Female', '9123456789', '456 Avenue, City', 'A-', '9223344556');

-- Inserting sample data into Doctors table
INSERT INTO Doctors (FirstName, LastName, Specialty, ContactNumber, ExperienceYears, AvailableHours) 
VALUES 
    ('Alice', 'Brown', 'Cardiologist', '9988776655', 10, '9 AM - 5 PM'),
    ('Bob', 'Wilson', 'Dermatologist', '8877665544', 8, '10 AM - 6 PM');

-- Inserting sample data into Appointments table
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status, Notes) 
VALUES 
    (1, 1, '2025-02-01 10:00:00', 'Scheduled', 'Follow-up checkup'),
    (2, 2, '2025-02-02 11:30:00', 'Scheduled', 'Skin allergy consultation');

-- Inserting sample data into Billing table
INSERT INTO Billing (PatientID, Amount, PaymentStatus, PaymentMethod) 
VALUES 
    (1, 5000.00, 'Pending', 'Card'),
    (2, 3000.00, 'Paid', 'Online');

-- Inserting sample data into Prescriptions table
INSERT INTO Prescriptions (PatientID, DoctorID, Medication, Dosage, IssueDate) 
VALUES 
    (1, 1, 'Aspirin, Paracetamol', '1 tablet twice a day', '2025-02-01'),
    (2, 2, 'Antihistamine', '1 tablet once a day', '2025-02-02');

-- Query to fetch all patient records
SELECT * FROM Patients;

-- Query to fetch all appointments along with patient and doctor details
SELECT 
    a.AppointmentID, 
    p.FirstName AS PatientName, 
    d.FirstName AS DoctorName, 
    a.AppointmentDate, 
    a.Status, 
    a.Notes 
FROM Appointments a 
JOIN Patients p ON a.PatientID = p.PatientID 
JOIN Doctors d ON a.DoctorID = d.DoctorID;

-- Query to fetch prescriptions for each patient
SELECT 
    pr.PrescriptionID, 
    p.FirstName AS PatientName, 
    d.FirstName AS DoctorName, 
    pr.Medication, 
    pr.Dosage, 
    pr.IssueDate 
FROM Prescriptions pr 
JOIN Patients p ON pr.PatientID = p.PatientID 
JOIN Doctors d ON pr.DoctorID = d.DoctorID;

-- Query to calculate total revenue collected
SELECT SUM(Amount) AS TotalRevenue FROM Billing WHERE PaymentStatus = 'Paid';
