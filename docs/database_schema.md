# Database Schema

Database: `HotelSalesDB`

## Tables

### Customers
- CustomerID — Primary Key
- FirstName
- LastName
- City

### Rooms
- RoomID — Primary Key
- RoomType
- PricePerNight
- Capacity

### Staff
- StaffID — Primary Key
- FirstName
- LastName
- Role

### Bookings
- BookingID — Primary Key
- CustomerID — Foreign Key → Customers.CustomerID
- RoomID — Foreign Key → Rooms.RoomID
- StaffID — Foreign Key → Staff.StaffID
- CheckInDate
- CheckOutDate
- TotalAmount

### Payments
- PaymentID — Primary Key
- BookingID — Foreign Key → Bookings.BookingID
- PaymentDate
- PaymentMethod
- Amount

## Relationships

```text
Customers  1 ────────< Bookings >──────── 1 Rooms
                         |
                         |
                         v
                       Staff

Bookings   1 ────────< Payments
```

The database is centered on `Bookings`, which connects customers, rooms, staff, and payments.
