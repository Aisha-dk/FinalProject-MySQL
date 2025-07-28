CREATE DATABASE ChariDB;
USE ChariDB;

CREATE TABLE IF NOT EXISTS Locations (
LocationID INT(1) NOT NULL,
Street VARCHAR(100),
District VARCHAR(20),
City VARCHAR(20),
PostalCode INT(5),
CONSTRAINT LocationID_PK PRIMARY KEY(LocationID)
);

CREATE TABLE IF NOT EXISTS Donors (
DonorID INT(1) NOT NULL,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
LocationID INT(1),
TotalDonation DECIMAL(12,2),
CONSTRAINT DonorID_PK PRIMARY KEY(DonorID),
CONSTRAINT LocationID_FK FOREIGN KEY (LocationID) REFERENCES Locations(LocationID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Projects (
    ProjectID INT NOT NULL,
    ProjectName VARCHAR(100) NOT NULL,
    Description TEXT,
    GoalAmount DECIMAL(10, 2),
    Status CHAR(50) CHECK(Status IN ('Pending', 'Active', 'Completed')),
    LocationID INT(1),
    CONSTRAINT ProjectID_PK PRIMARY KEY (ProjectID),
    CONSTRAINT Projects_LocationID_FK FOREIGN KEY (LocationID) REFERENCES Locations(LocationID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Donations (
    DonationID INT AUTO_INCREMENT, 
    DonorID INT NOT NULL,                       
    ProjectID INT NOT NULL,                    
    Amount DECIMAL(10, 2) NOT NULL,            
    DonationDate DATE NOT NULL,
    CONSTRAINT PK_DonationID PRIMARY KEY (DonationID),
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID), 
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

CREATE TABLE IF NOT EXISTS Volunteers (
    VolunteerID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    ProjectID INT,
    HoursContributed INT DEFAULT 0,
    CONSTRAINT VolunteerID_PK PRIMARY KEY (VolunteerID),
    CONSTRAINT Volunteer_ProjectID_FK FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Sponsors(
SponsorsID INT(2) NOT NULL,
SponsorsName VARCHAR(255) NOT NULL,
sponsoredAmount DECIMAL(10,2) NOT NULL,
CONSTRAINT SponsorsID_PK PRIMARY KEY(SponsorsID)
);

CREATE TABLE IF NOT EXISTS Sponsorship (
    SponsorsID INT(2) NOT NULL,
    ProjectID INT NOT NULL,
    CONSTRAINT Sponsorship_PK PRIMARY KEY (SponsorsID, ProjectID),
    CONSTRAINT Sponsorship_SponsorsID_FK FOREIGN KEY (SponsorsID) REFERENCES Sponsors(SponsorsID) ON DELETE CASCADE,
    CONSTRAINT Sponsorship_ProjectID_FK FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Activities (
    ActivityID INT AUTO_INCREMENT,
    ActivityName VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT,
    ActivityDate DATE NOT NULL,
    ProjectID INT NOT NULL,
    VolunteerID INT,
    CONSTRAINT Activities_PK PRIMARY KEY (ActivityID),
    CONSTRAINT Activities_FK1 FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    CONSTRAINT Activities_FK2 FOREIGN KEY (VolunteerID) REFERENCES Volunteers(VolunteerID)
);

CREATE TABLE IF NOT EXISTS ContactMethods
(ContactID INT NOT NULL,
DonorID INT(1) ,
VolunteerID INT(1),
SponsorsID INT(1),
ContactType VARCHAR(5) CHECK(ContactType IN('Phone','Email')) NOT NULL,
ContactValue VARCHAR(30) NOT NULL,
CONSTRAINT ContactID_PK PRIMARY KEY(ContactID),
CONSTRAINT DonorID_FK FOREIGN KEY (DonorID) REFERENCES Donors(DonorID) ON DELETE CASCADE,
CONSTRAINT VolunteerID_FK FOREIGN KEY (VolunteerID) REFERENCES Volunteers(VolunteerID) ON DELETE CASCADE,
CONSTRAINT SponsorsID_FK FOREIGN KEY (SponsorsID) REFERENCES Sponsors(SponsorsID) ON DELETE CASCADE,
CHECK (
        (DonorID IS NOT NULL AND SponsorsID IS NULL AND VolunteerID IS NULL) OR
        (DonorID IS NULL AND SponsorsID IS NOT NULL AND VolunteerID IS NULL) OR
        (DonorID IS NULL AND SponsorsID IS NULL AND VolunteerID IS NOT NULL)
)
);


INSERT INTO Locations (LocationID, Street, District, City, PostalCode)
Values
(1, 'Anas Ibn Malik', 'Riyadh', 'Riyadh', 12242),
(2, 'Prince Mohammed Bin Abdulaziz', 'Jeddah', 'Jeddah', 23322),
(3, 'Prince Sultan Bin Abulaziz', 'Makkah', 'Makkah', 24372),
(4, 'King Khalid Rd', 'Madinah', 'Yanbu', 46423),
(5, 'King Abdulaziz Rd', 'Abha', 'Abha', 62512);

INSERT INTO Donors (DonorID, FirstName, LastName, LocationID, TotalDonation)
Values
(1, 'Nora', 'Alshmari', 1, 123458),
(2, 'Fatimah', 'Mesawah', 3, 34298.95),
(3, 'Hala', 'Dakhil', 2, 443560),
(4, 'Mohammed', 'Alshaim', 5, 1432675.75),
(5, 'Ali', 'Alsubhi', 4, 220486);


INSERT INTO Projects (ProjectID, ProjectName, Description, GoalAmount, Status, LocationID)
VALUES
(1, 'Clean Water Project', 'Providing clean water access', 50000.00, 'Active', 1),
(2, 'Solar Energy Panels', 'Installing solar panels', 75000.00, 'Pending', 2),
(3, 'Tree Planting Drive', 'Planting 1000 trees', 20000.00, 'Completed', 3),
(4, 'Education for All', 'Building a school', 100000.00, 'Active', 4),
(5, 'Health Awareness', 'Health awareness workshops', 15000.00, 'Pending', 5);

INSERT INTO Donations (DonationID, DonorID, ProjectID, Amount, DonationDate)
VALUES
(1, 2, 1, 500.00, '2025-01-01'),
(2, 5, 2, 1000.00, '2025-01-05'),
(3, 1, 3, 250.00, '2025-01-07'),
(4, 3, 4, 1500.00, '2025-01-10'),
(5, 4, 5, 200.00, '2025-01-12');

INSERT INTO Volunteers (VolunteerID, Name, ProjectID, HoursContributed)
VALUES
(1, 'John Smith', 1, 20),
(2, 'Sarah Johnson', 2, 15),
(3, 'Ahmed Ali', 3, 25),
(4, 'Fatima Khan', 4, 30),
(5, 'Carlos Rivera', 5, 10);

INSERT INTO Sponsors(SponsorsID,SponsorsName,sponsoredAmount) 
VALUES
(1, 'Hassan',  3000000),
(2, 'Aisha', 500000),
(3, 'Lama',  1290000),
(4, 'Eman', 6789910.75),
(5, 'Omar', 300000.50);


INSERT INTO Activities (ActivityName, Description, ActivityDate, ProjectID, VolunteerID)
VALUES 
    ('Clean Beach', 'An activity to clean the local beach', '2025-02-01', 1, 1),
    ('Tree Planting', 'Planting trees in the community park', '2025-03-15', 2, 2),
    ('Food Distribution', 'Distributing food to the homeless', '2025-04-10', 3, 3),
    ('Workshop on Recycling', 'Teaching recycling techniques to locals', '2025-05-20', 4, 4),
    ('Neighborhood Cleanup', 'Cleaning up the streets in the neighborhood', '2025-06-05', 5, 5);
    
INSERT INTO ContactMethods (ContactID, DonorID, VolunteerID, SponsorsID, ContactType, ContactValue)
VALUES
(1, 1, NULL, NULL, 'Email', 'nalshmari@gmail.com'),
(2, 1, NULL, NULL, 'Phone', '7527014583'),
(3, 1, NULL, NULL, 'Phone', '6147441745'),
(4, 2, NULL, NULL, 'Email', 'fmesawah@gmail.com'),
(5, 2, NULL, NULL, 'Phone', '3586166567'),
(6, 3, NULL, NULL, 'Email', 'hdakhil@gmail.com'),
(7, 3, NULL, NULL, 'Phone', '6835790138'),
(8, 4, NULL, NULL, 'Phone', '1896517049'),
(9, 5, NULL, NULL, 'Email', 'aalsubhi@gmail.com'),
(10, NULL, NULL, 1, 'Email', 'nhasanomar@gmail.com'),
(11, NULL, NULL, 1, 'Email', 'aaishhaadna@gmail.com'),
(12, NULL, NULL, 1, 'Phone', '0545635843'),
(13, NULL, NULL, 2, 'Phone', '0567778900'),
(14, NULL, NULL, 2, 'Email', 'omaarfahad@gmail.com'),
(15, NULL, 1, NULL, 'Phone', '0555555555'),
(16, NULL, 1, NULL, 'Email', 'fahad@example.com'),
(17, NULL, 1, NULL, 'Phone', '0555555555'),
(18, NULL, 2, NULL, 'Phone', '0566666666'),
(19, NULL, 2, NULL, 'Email', 'noura@example.com');

UPDATE Volunteers
SET HoursContributed = 20
WHERE VolunteerID = 2;

DELETE FROM ContactMethods
WHERE VolunteerID = 1 AND ContactID = 17;


SELECT *
FROM Donors 
WHERE TotalDonation >5000 AND LocationID=1;

SELECT ProjectID, SUM(Amount)AS TotalDonations 
FROM Donations
GROUP BY ProjectID
ORDER BY TotalDonations DESC;
 
SELECT ProjectID, SUM(DonationID)AS TotalAmount 
FROM Donations
GROUP BY ProjectID
HAVING SUM(Amount)>1000;

SELECT DonorID,CONCAT(FirstName, " ", LastName) AS FullName, TotalDonation 
FROM Donors
ORDER BY TotalDonation DESC;

SELECT ProjectName ,GoalAmount
FROM Projects
WHERE GoalAmount>(
SELECT AVG(GoalAmount)
FROM Projects)
ORDER BY GoalAmount DESC;

SELECT CONCAT(d.FirstName, " " ,d.LastName) AS FullName, p.ProjectName, dn.Amount 
FROM Donors d
JOIN Donations dn ON d.DonorID=dn.DonorID
JOIN Projects p ON dn.ProjectID=p.ProjectID ;




