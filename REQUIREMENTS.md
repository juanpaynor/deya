# Deya HR System - Mobile Frontend Requirements

**Project:** Employee Attendance & Schedule Management Mobile App (MVP)  
**Date:** December 10, 2025  
**Prepared by:** Frontend Development Team  
**For:** Backend Team & Client

---

## Overview

We are building a mobile frontend application (Flutter) for Deya's HR system. The MVP will focus on:
- Employee attendance tracking (clock in/out)
- Schedule/shift viewing
- Attendance history

Before we proceed with development, we need clarification on the following aspects:

---

## 1. Authentication & Authorization

### Questions for Backend Team:

1. **What authentication method will be used?**
   - JWT tokens?
   - OAuth 2.0?
   - Session-based authentication?
   - Other?

2. **What is the login flow?**
   - Username/password only?
   - Email/password?
   - Employee ID + PIN?
   - Single Sign-On (SSO)?
   - Biometric authentication required?

3. **Token management:**
   - What is the token expiration time?
   - Is there a refresh token mechanism?
   - What endpoint should we call to refresh tokens?

4. **User roles:**
   - What user roles exist in the system? (employee, supervisor, manager, admin, etc.)
   - Will different roles have different access levels in the mobile app?
   - For MVP, are we only building for regular employees or multiple roles?

5. **Session management:**
   - Can a user be logged in on multiple devices simultaneously?
   - Should we implement force logout from other devices?

### Questions for Client:

1. **Security requirements:**
   - Is two-factor authentication (2FA) required for MVP or future phase?
   - Should we implement biometric login (fingerprint/face ID)?
   - Any specific security compliance requirements? (GDPR, data privacy laws, etc.)

2. **Password requirements:**
   - What are the password complexity requirements?
   - Should users be able to reset passwords through the mobile app?

---

## 2. Attendance System Flow

### Questions for Backend Team:

1. **Clock In/Out mechanism:**
   - What data should be sent when an employee clocks in?
   - What data should be sent when an employee clocks out?
   - What is the expected response format?

2. **Location verification:**
   - Is GPS location tracking required?
   - Should location be sent with clock in/out requests?
   - Is there server-side validation of location against office coordinates?
   - What happens if location is outside the allowed area?

3. **Attendance states:**
   - What are all possible attendance states? (present, absent, late, on-leave, work-from-home, etc.)
   - How is "late" determined? (by mobile app or backend?)
   - Can an employee clock in if they're marked absent?

4. **Break time handling:**
   - Are break times tracked separately?
   - Can employees clock out for lunch/break and clock back in?
   - Is there a limit to how many times they can clock in/out per day?

5. **Edge cases:**
   - What happens if an employee forgets to clock out?
   - Can employees clock in before their scheduled shift starts?
   - Can employees clock out after their shift ends (overtime)?
   - Can employees edit their attendance records? (or is that admin-only?)
   - What happens if there's no internet connection during clock in/out?

### Questions for Client:

1. **Business rules:**
   - What defines a "late" clock-in? (grace period in minutes?)
   - Are there different shift times for different employees?
   - How should the system handle early departures?
   - Should employees receive a notification/confirmation after successful clock in/out?

2. **Geolocation requirements:**
   - Do all employees work from the same location?
   - Are there multiple office locations?
   - Should remote work be supported in MVP?
   - What is the acceptable radius for geofencing? (50m, 100m, 500m?)

3. **Overtime tracking:**
   - Should overtime be calculated automatically?
   - Does overtime require manager approval?

---

## 3. Schedule/Shift Management

### Questions for Backend Team:

1. **Schedule data structure:**
   - How far in advance are schedules available? (weekly, monthly, quarterly?)
   - What data fields are included in a shift record?
   - Are schedules assigned to individuals or teams?

2. **Shift types:**
   - What shift types exist? (morning, afternoon, night, split-shift, etc.)
   - How are shift times defined? (fixed or variable?)
   - Can shifts span multiple days? (night shifts crossing midnight?)

3. **Schedule updates:**
   - Can schedules change after being published?
   - Will employees receive notifications for schedule changes?
   - Is there a schedule approval/confirmation workflow?

### Questions for Client:

1. **Schedule visibility:**
   - How far ahead should employees see their schedules? (1 week, 1 month, 3 months?)
   - Can employees view schedules of their teammates?
   - Should there be a calendar view, list view, or both?

2. **Schedule requests:**
   - Can employees request shift changes through the app? (MVP or future?)
   - Can employees request time off through the app? (MVP or future?)
   - Can employees swap shifts with colleagues? (MVP or future?)

3. **Notifications:**
   - Should employees receive reminders before their shift starts? (if yes, how many minutes/hours before?)
   - What types of schedule notifications are needed? (new schedule published, schedule changed, shift starting soon?)

---

## 4. Attendance History

### Questions for Backend Team:

1. **Data retrieval:**
   - What date range can employees query? (last 7 days, last month, last year, custom range?)
   - Is there pagination for attendance history?
   - What filters are available? (date range, status, location?)

2. **Attendance data fields:**
   - What information is included in each attendance record?
   - Are hours worked calculated by backend or frontend?
   - Are overtime hours tracked separately?

3. **Reports/Export:**
   - Can employees export their attendance history? (PDF, CSV, etc.)
   - Is there a summary/statistics endpoint? (total hours worked, days present, days absent, etc.)

### Questions for Client:

1. **History visibility:**
   - How far back should employees see their attendance history?
   - Should there be a monthly summary view?
   - What statistics should be displayed? (total hours, attendance percentage, late count, etc.)

2. **Discrepancy handling:**
   - Can employees dispute incorrect attendance records?
   - Is there a comment/notes section for attendance records?

---

## 5. API Specifications Needed

### For Backend Team:

Please provide detailed API documentation including:

1. **Base URL and versioning:**
   - API base URL (development, staging, production)
   - API version endpoint structure

2. **Authentication endpoints:**
   - POST /auth/login
   - POST /auth/logout
   - POST /auth/refresh-token
   - POST /auth/forgot-password (if applicable)

3. **Attendance endpoints:**
   - POST /attendance/clock-in
   - POST /attendance/clock-out
   - GET /attendance/current-status
   - GET /attendance/history
   - GET /attendance/summary

4. **Schedule endpoints:**
   - GET /schedule/current
   - GET /schedule/upcoming
   - GET /schedule/{date}

5. **User/Profile endpoints:**
   - GET /user/profile
   - PUT /user/profile (if editable)

6. **For each endpoint, please specify:**
   - HTTP method
   - Request headers required
   - Request body structure (with example)
   - Success response structure (with example)
   - Error response structure (with error codes)
   - Authentication requirements

---

## 6. Data Models

### For Backend Team:

Please provide exact JSON structure for:

1. **User/Employee object**
   ```json
   // Please provide actual structure
   {
     "id": "?",
     "name": "?",
     "email": "?",
     // ... what other fields?
   }
   ```

2. **Attendance record object**
   ```json
   // Please provide actual structure
   {
     "id": "?",
     "clock_in": "?",
     "clock_out": "?",
     // ... what other fields?
   }
   ```

3. **Schedule/Shift object**
   ```json
   // Please provide actual structure
   {
     "id": "?",
     "start_time": "?",
     "end_time": "?",
     // ... what other fields?
   }
   ```

4. **Error response object**
   ```json
   // Please provide actual structure
   {
     "error": "?",
     "message": "?",
     // ... what other fields?
   }
   ```

---

## 7. Technical Requirements

### Questions for Backend Team:

1. **API response format:**
   - JSON only?
   - Date/time format? (ISO 8601, Unix timestamp, etc.)
   - Timezone handling? (UTC? Local time? Timezone field?)

2. **File uploads:**
   - If profile photos are needed, what is the upload endpoint?
   - Accepted file formats and size limits?

3. **Rate limiting:**
   - Are there API rate limits we should be aware of?
   - How should we handle rate limit errors?

4. **Testing:**
   - Is there a test/sandbox environment available?
   - Test user credentials?

### Questions for Client:

1. **Supported platforms:**
   - Android only, iOS only, or both?
   - Minimum OS versions to support?

2. **Offline functionality:**
   - Should the app work offline?
   - If yes, what features should work offline?
   - Should failed requests be queued and retried when online?

3. **Languages:**
   - Single language or multi-language support?
   - If multi-language, which languages?

4. **Branding:**
   - App name, logo, and brand colors?
   - Any specific design guidelines or existing design system?

---

## 8. Timeline & Deployment

### Questions for Client:

1. **Development timeline:**
   - What is the expected delivery date for MVP?
   - Are there any milestone dates we should be aware of?

2. **Testing:**
   - Will there be a UAT (User Acceptance Testing) phase?
   - How many test users will participate?

3. **Deployment:**
   - Internal distribution only or public app stores?
   - Is there an existing Apple Developer/Google Play account?

### Questions for Backend Team:

1. **API availability:**
   - When will the API endpoints be ready?
   - Can we start development with mock data/endpoints?
   - Will API documentation be provided before implementation?

2. **Environment setup:**
   - How many environments? (dev, staging, production?)
   - How will we receive API credentials?

---

## 9. Future Considerations (Post-MVP)

### For planning purposes, please indicate priority:

- Leave management (request time off, view leave balance)
- Overtime request and approval
- Shift swap between employees
- Team schedule viewing
- Push notifications
- Manager/supervisor dashboard
- Payroll integration
- Performance tracking
- Document management (payslips, contracts)
- Announcements/news feed

---

## Next Steps

Please review this document and provide answers to the questions above. Once we have this information, we can:

1. Finalize the technical architecture
2. Create detailed mockups/wireframes (if needed)
3. Begin development with accurate specifications
4. Set up proper API integration

**Contact:** [Your contact information]  
**Response deadline:** [Specify date if needed]

---

## Appendix: Assumptions (if no answers provided)

If we don't receive answers to specific questions, we will proceed with these assumptions for MVP:

- JWT-based authentication with email/password login
- Basic clock in/out with timestamp only (no geolocation)
- Read-only schedule viewing (no requests/changes)
- 30-day attendance history
- JSON API with ISO 8601 date format
- Android and iOS support
- English language only
- Standard Material Design UI

Please confirm or correct these assumptions.
