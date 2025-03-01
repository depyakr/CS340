-- =============================================
-- Note the special character colon : is used to denote entries that the user will fill
-- =============================================

-- =============================================
-- Attendees Queries
-- =============================================

-- Create (Insert)
INSERT INTO Attendees (attendee_id, first_name, last_name, email, phone_number, is_employee)
VALUES (:attendeeIdInput, :fnameInput, :lnameInput, :emailInput, :phoneInput, :isEmployeeInput);

-- Read (Select)
SELECT * FROM Attendees;

-- Update
UPDATE Attendees
SET first_name = :fnameInput, last_name = :lnameInput, email = :emailInput, phone_number = :phoneInput, is_employee = :isEmployeeInput
WHERE attendee_id = :attendeeIdInput;

-- Delete
DELETE FROM Attendees WHERE attendee_id = :attendeeIdInput;

-- =============================================
-- Venues Queries
-- =============================================

-- Create (Insert)
INSERT INTO Venues (venue_id, venue_name, capacity, is_wheelchair_accessible)
VALUES (:venueIdInput, :venueNameInput, :capacityInput, :isAccessibleInput);

-- Read (Select)
SELECT * FROM Venues;

-- Update
UPDATE Venues
SET venue_name = :venueNameInput, capacity = :capacityInput, is_wheelchair_accessible = :isAccessibleInput
WHERE venue_id = :venueIdInput;

-- Delete
DELETE FROM Venues WHERE venue_id = :venueIdInput;

-- =============================================
-- Events Queries
-- =============================================

-- Create (Insert)
INSERT INTO Events (event_id, event_name, event_date, total_attendees, venue_id)
VALUES (:eventIdInput, :eventNameInput, :eventDateInput, :totalAttendeesInput, :venueIdInput);

-- Read (Select)
SELECT Events.event_id, Events.event_name, Events.event_date, Events.total_attendees, Venues.venue_name
FROM Events
INNER JOIN Venues ON Events.venue_id = Venues.venue_id;

-- Update
UPDATE Events
SET event_name = :eventNameInput, event_date = :eventDateInput, total_attendees = :totalAttendeesInput, venue_id = :venueIdInput
WHERE event_id = :eventIdInput;

-- Delete
DELETE FROM Events WHERE event_id = :eventIdInput;

-- =============================================
-- Task Definitions Queries
-- =============================================

-- Create (Insert)
INSERT INTO Task_definitions (task_id, task_name, task_description, task_status)
VALUES (:taskIdInput, :taskNameInput, :taskDescriptionInput, :taskStatusInput);

-- Read (Select)
SELECT * FROM Task_definitions;

-- Update
UPDATE Task_definitions
SET task_name = :taskNameInput, task_description = :taskDescriptionInput, task_status = :taskStatusInput
WHERE task_id = :taskIdInput;

-- Delete
DELETE FROM Task_definitions WHERE task_id = :taskIdInput;

-- =============================================
-- Task Assignments Queries
-- =============================================

-- Create (Insert)
INSERT INTO Task_assignments (assignment_id, task_id, event_id, attendee_id)
VALUES (:assignmentIdInput, :taskIdInput, :eventIdInput, :attendeeIdInput);

-- Read (Select)
SELECT Task_assignments.assignment_id, 
       Task_definitions.task_name, 
       Events.event_name, 
       CONCAT(Attendees.first_name, ' ', Attendees.last_name) AS attendee_name
FROM Task_assignments
INNER JOIN Task_definitions ON Task_assignments.task_id = Task_definitions.task_id
INNER JOIN Events ON Task_assignments.event_id = Events.event_id
LEFT JOIN Attendees ON Task_assignments.attendee_id = Attendees.attendee_id;  -- LEFT JOIN allows NULL attendees

-- Update
UPDATE Task_assignments
SET task_id = :taskIdInput, event_id = :eventIdInput, attendee_id = :attendeeIdInput
WHERE assignment_id = :assignmentIdInput;

-- Delete
DELETE FROM Task_assignments WHERE assignment_id = :assignmentIdInput;

-- =============================================
-- Event_has_attendees Queries
-- =============================================

-- Create (Insert)
INSERT INTO Event_has_attendees (event_id, attendee_id)
VALUES (:eventIdInput, :attendeeIdInput);

-- Read (Select)
SELECT Events.event_name, 
       CONCAT(Attendees.first_name, ' ', Attendees.last_name) AS attendee_name
FROM Event_has_attendees
INNER JOIN Events ON Event_has_attendees.event_id = Events.event_id
INNER JOIN Attendees ON Event_has_attendees.attendee_id = Attendees.attendee_id;

-- Update
UPDATE Event_has_attendees
SET event_id = :newEventIdInput, attendee_id = :newAttendeeIdInput
WHERE event_id = :eventIdInput AND attendee_id = :attendeeIdInput;

-- Delete
DELETE FROM Event_has_attendees WHERE event_id = :eventIdInput AND attendee_id = :attendeeIdInput;
