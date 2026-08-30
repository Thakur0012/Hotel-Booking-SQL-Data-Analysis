-- Hotel Booking Data Analysis
-- MySQL / MySQL Workbench
-- Portfolio Query Collection

USE HotelSalesDB;

-- =========================================================
-- 1. BASIC DATA EXPLORATION
-- =========================================================

SELECT COUNT(*) AS Total_Customers FROM Customers;

SELECT COUNT(*) AS Total_Rooms FROM Rooms;

SELECT COUNT(*) AS Total_Staff FROM Staff;

SELECT COUNT(*) AS Total_Bookings FROM Bookings;

SELECT COUNT(*) AS Total_Payments FROM Payments;


-- =========================================================
-- 2. CUSTOMER ANALYSIS
-- =========================================================

-- Customer full names and booking count
SELECT
    c.CustomerID,
    CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
    COUNT(b.BookingID) AS BookingCount
FROM Customers c
LEFT JOIN Bookings b
    ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY BookingCount DESC;


-- Customers with more than one booking
SELECT
    c.CustomerID,
    CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
    COUNT(b.BookingID) AS BookingCount
FROM Customers c
JOIN Bookings b
    ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(b.BookingID) > 1
ORDER BY BookingCount DESC;


-- Top customers by total spending
SELECT
    c.CustomerID,
    CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
    SUM(b.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Bookings b
    ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpent DESC
LIMIT 10;


-- =========================================================
-- 3. BOOKING & REVENUE ANALYSIS
-- =========================================================

-- Total booking revenue
SELECT
    SUM(TotalAmount) AS Total_Booking_Revenue
FROM Bookings;


-- Average booking value
SELECT
    AVG(TotalAmount) AS Average_Booking_Value
FROM Bookings;


-- Revenue by year
SELECT
    YEAR(CheckInDate) AS BookingYear,
    COUNT(*) AS TotalBookings,
    SUM(TotalAmount) AS TotalRevenue,
    AVG(TotalAmount) AS AverageBookingValue
FROM Bookings
GROUP BY YEAR(CheckInDate)
ORDER BY BookingYear;


-- Revenue by month
SELECT
    YEAR(CheckInDate) AS BookingYear,
    MONTH(CheckInDate) AS BookingMonth,
    COUNT(*) AS TotalBookings,
    SUM(TotalAmount) AS TotalRevenue
FROM Bookings
GROUP BY YEAR(CheckInDate), MONTH(CheckInDate)
ORDER BY BookingYear, BookingMonth;


-- Highest-value bookings
SELECT
    BookingID,
    CustomerID,
    RoomID,
    CheckInDate,
    CheckOutDate,
    TotalAmount
FROM Bookings
ORDER BY TotalAmount DESC
LIMIT 10;


-- =========================================================
-- 4. ROOM ANALYSIS
-- =========================================================

-- Room type count and average price
SELECT
    RoomType,
    COUNT(*) AS NumberOfRooms,
    AVG(PricePerNight) AS AveragePricePerNight,
    MAX(PricePerNight) AS HighestPricePerNight,
    MIN(PricePerNight) AS LowestPricePerNight
FROM Rooms
GROUP BY RoomType
ORDER BY AveragePricePerNight DESC;


-- Room type revenue generated through bookings
SELECT
    r.RoomType,
    COUNT(b.BookingID) AS BookingCount,
    SUM(b.TotalAmount) AS Revenue
FROM Rooms r
JOIN Bookings b
    ON r.RoomID = b.RoomID
GROUP BY r.RoomType
ORDER BY Revenue DESC;


-- Rooms with price above the average room price
SELECT
    RoomID,
    RoomType,
    PricePerNight,
    Capacity
FROM Rooms
WHERE PricePerNight > (
    SELECT AVG(PricePerNight)
    FROM Rooms
)
ORDER BY PricePerNight DESC;


-- =========================================================
-- 5. STAFF ANALYSIS
-- =========================================================

-- Staff booking count
SELECT
    s.StaffID,
    CONCAT_WS(' ', s.FirstName, s.LastName) AS StaffName,
    s.Role,
    COUNT(b.BookingID) AS BookingsHandled
FROM Staff s
LEFT JOIN Bookings b
    ON s.StaffID = b.StaffID
GROUP BY s.StaffID, s.FirstName, s.LastName, s.Role
ORDER BY BookingsHandled DESC;


-- Staff revenue handled
SELECT
    s.StaffID,
    CONCAT_WS(' ', s.FirstName, s.LastName) AS StaffName,
    s.Role,
    SUM(b.TotalAmount) AS RevenueHandled
FROM Staff s
JOIN Bookings b
    ON s.StaffID = b.StaffID
GROUP BY s.StaffID, s.FirstName, s.LastName, s.Role
ORDER BY RevenueHandled DESC;


-- =========================================================
-- 6. PAYMENT ANALYSIS
-- =========================================================

-- Payment method performance
SELECT
    PaymentMethod,
    COUNT(*) AS PaymentCount,
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AveragePayment
FROM Payments
GROUP BY PaymentMethod
ORDER BY TotalAmount DESC;


-- Payment trends by year
SELECT
    YEAR(PaymentDate) AS PaymentYear,
    PaymentMethod,
    COUNT(*) AS NumberOfPayments,
    SUM(Amount) AS TotalPaymentAmount
FROM Payments
GROUP BY YEAR(PaymentDate), PaymentMethod
ORDER BY PaymentYear, TotalPaymentAmount DESC;


-- Largest payments
SELECT
    PaymentID,
    BookingID,
    PaymentDate,
    PaymentMethod,
    Amount
FROM Payments
ORDER BY Amount DESC
LIMIT 10;


-- =========================================================
-- 7. BOOKING DURATION
-- =========================================================

SELECT
    BookingID,
    CustomerID,
    CheckInDate,
    CheckOutDate,
    DATEDIFF(CheckOutDate, CheckInDate) AS StayNights,
    TotalAmount
FROM Bookings
ORDER BY StayNights DESC;


-- Average stay duration
SELECT
    AVG(DATEDIFF(CheckOutDate, CheckInDate)) AS AverageStayNights
FROM Bookings;


-- Revenue per night
SELECT
    BookingID,
    TotalAmount,
    DATEDIFF(CheckOutDate, CheckInDate) AS StayNights,
    ROUND(
        TotalAmount / NULLIF(DATEDIFF(CheckOutDate, CheckInDate), 0),
        2
    ) AS RevenuePerNight
FROM Bookings
ORDER BY RevenuePerNight DESC;


-- =========================================================
-- 8. JOIN ANALYSIS
-- =========================================================

-- Complete booking report
SELECT
    b.BookingID,
    CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
    c.City,
    r.RoomType,
    r.PricePerNight,
    CONCAT_WS(' ', s.FirstName, s.LastName) AS StaffName,
    s.Role,
    b.CheckInDate,
    b.CheckOutDate,
    DATEDIFF(b.CheckOutDate, b.CheckInDate) AS StayNights,
    b.TotalAmount
FROM Bookings b
JOIN Customers c
    ON b.CustomerID = c.CustomerID
JOIN Rooms r
    ON b.RoomID = r.RoomID
JOIN Staff s
    ON b.StaffID = s.StaffID
ORDER BY b.TotalAmount DESC;


-- =========================================================
-- 9. SUBQUERY ANALYSIS
-- =========================================================

-- Bookings above the average booking value
SELECT
    BookingID,
    CustomerID,
    TotalAmount
FROM Bookings
WHERE TotalAmount > (
    SELECT AVG(TotalAmount)
    FROM Bookings
)
ORDER BY TotalAmount DESC;


-- Customers whose total spending is above average customer spending
SELECT
    c.CustomerID,
    CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
    SUM(b.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Bookings b
    ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(b.TotalAmount) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT
            CustomerID,
            SUM(TotalAmount) AS CustomerTotal
        FROM Bookings
        GROUP BY CustomerID
    ) AS CustomerTotals
)
ORDER BY TotalSpent DESC;


-- =========================================================
-- 10. VIEW FOR REUSABLE REPORTING
-- =========================================================

CREATE OR REPLACE VIEW vw_booking_details AS
SELECT
    b.BookingID,
    b.CustomerID,
    CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
    c.City,
    b.RoomID,
    r.RoomType,
    r.PricePerNight,
    r.Capacity,
    b.StaffID,
    CONCAT_WS(' ', s.FirstName, s.LastName) AS StaffName,
    s.Role AS StaffRole,
    b.CheckInDate,
    b.CheckOutDate,
    DATEDIFF(b.CheckOutDate, b.CheckInDate) AS StayNights,
    b.TotalAmount
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN Staff s ON b.StaffID = s.StaffID;


-- Use the reusable view
SELECT *
FROM vw_booking_details
ORDER BY TotalAmount DESC;


-- =========================================================
-- 11. PAYMENT VIEW
-- =========================================================

CREATE OR REPLACE VIEW vw_payment_summary AS
SELECT
    p.PaymentID,
    p.BookingID,
    p.PaymentDate,
    p.PaymentMethod,
    p.Amount,
    b.CustomerID,
    b.RoomID,
    b.TotalAmount AS BookingAmount
FROM Payments p
JOIN Bookings b
    ON p.BookingID = b.BookingID;


SELECT *
FROM vw_payment_summary
ORDER BY Amount DESC;


-- =========================================================
-- 12. TRIGGER EXAMPLE
-- =========================================================

-- This trigger demonstrates automated cleanup of a payment
-- record when its associated booking is deleted.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_delete_booking_payment $$

CREATE TRIGGER trg_delete_booking_payment
BEFORE DELETE ON Bookings
FOR EACH ROW
BEGIN
    DELETE FROM Payments
    WHERE BookingID = OLD.BookingID;
END $$

DELIMITER ;


-- =========================================================
-- END OF ANALYSIS QUERIES
-- =========================================================
