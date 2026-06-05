# Data Dictionary

## Table: users

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| user_id | BIGINT | 64-bit | Primary Key, Not Null | Unique numeric identifier for each user account. |
| cedoc_id | VARCHAR | Variable | Unique, Not Null | Official CEDOC identification number of the user. |
| username | VARCHAR | Variable | Optional | Username used to access the system. |
| password | VARCHAR | Variable | Optional | Protected password credential of the user account. |
| first_name | VARCHAR | Variable | Optional | First name of the user. |
| middle_name | VARCHAR | Variable | Optional | Middle name of the user. |
| surname | VARCHAR | Variable | Optional | Surname or last name of the user. |
| cedoc_name | VARCHAR | Variable | Optional | Complete display name of the CEDOC personnel. |
| email_address | VARCHAR | Variable | Optional | Email address of the user. |
| contacts | VARCHAR | Variable | Optional | Contact number of the user. |
| category | VARCHAR | Variable | Optional | User category or account grouping. |
| designation | VARCHAR | Variable | Optional | Job title or official designation of the user. |
| role | VARCHAR | Variable | Optional | System role assigned to the user. |
| account_type | VARCHAR | Variable | Optional | Type of account used for access control. |
| responder_type | VARCHAR | Variable | Optional | Responder classification of the user. |
| vehicle_type | VARCHAR | Variable | Optional | Vehicle or service type assigned to the responder. |
| status | VARCHAR | Variable | Optional | Current account or service status. |
| is_logged_in | BOOLEAN | True/False | Not Null | Indicates whether the user is currently logged in. |
| session_state | VARCHAR | Variable | Not Null | Current session state of the account. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the user account was created. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the user account was last updated. |

## Table: user_time_render

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| cedoc_id | VARCHAR | Variable | Primary Key, Foreign Key, Not Null | CEDOC ID of the user whose activity time is recorded. |
| full_name | VARCHAR | Variable | Optional | Full name of the active user. |
| activity_date | DATE | YYYY-MM-DD | Optional | Date of the recorded user activity. |
| login_at | TIMESTAMP | Date and Time | Optional | Date and time when the user logged in. |
| logout_at | TIMESTAMP | Date and Time | Optional | Date and time when the user logged out. |
| render_seconds | BIGINT | 64-bit | Not Null | Total active service duration in seconds. |
| render_time | VARCHAR | Variable | Not Null | Formatted active service duration. |
| case_report_created | INTEGER | 32-bit | Not Null | Number of case reports created by the user. |
| active_state | VARCHAR | Variable | Not Null | Current active service state of the user. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the activity record was created. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the activity record was last updated. |

## Table: cedoc_id_year_sequence

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| registration_year | INTEGER | 32-bit | Primary Key, Not Null | Year used for generating CEDOC ID sequences. |
| last_sequence | INTEGER | 32-bit | Not Null | Latest generated sequence number for the year. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the sequence was last updated. |

## Table: system_setting

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| setting_key | VARCHAR | Variable | Primary Key, Not Null | Unique key for the stored system settings. |
| system_name | VARCHAR | Variable | Not Null | Name of the accident recording and reporting system. |
| organization_name | VARCHAR | Variable | Not Null | Name of the organization using the system. |
| contact_number | VARCHAR | Variable | Not Null | Official contact number shown in system settings. |
| email_address | VARCHAR | Variable | Not Null | Official email address shown in system settings. |
| time_zone | VARCHAR | Variable | Not Null | Time zone used by the system. |
| theme_mode | VARCHAR | Variable | Not Null | Selected interface theme mode. |
| accent_color | VARCHAR | Variable | Not Null | Selected accent color of the system interface. |
| sidebar_style | VARCHAR | Variable | Not Null | Selected sidebar display style. |
| log_style | VARCHAR | Variable | Not Null | Selected system log display style. |
| cmd_theme | VARCHAR | Variable | Not Null | Selected command-style log theme. |
| updated_by | VARCHAR | Variable | Not Null | User who last updated the settings. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the settings were last updated. |

## Table: accident_cases

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| case_id | VARCHAR | Variable | Primary Key, Not Null | Unique identifier of the accident case. |
| case_number | VARCHAR | Variable | Optional | Official case number assigned to the record. |
| case_date | VARCHAR | Variable | Optional | Date when the case was recorded. |
| time_label | VARCHAR | Variable | Optional | Time when the case was reported or encoded. |
| case_type | VARCHAR | Variable | Not Null | Type of incident or accident case. |
| name_of_caller | VARCHAR | Variable | Optional | Name of the person who reported the incident. |
| contact_number | VARCHAR | Variable | Optional | Contact number of the caller or reporting person. |
| call_taker | VARCHAR | Variable | Optional | Personnel who received or encoded the call. |
| concern | VARCHAR | Variable | Optional | Reported concern or incident details. |
| action_taken | VARCHAR | Variable | Optional | Action taken by CEDOC or responders. |
| location | VARCHAR | Variable | Not Null | Exact location of the accident or incident. |
| barangay | VARCHAR | Variable | Optional | Barangay where the incident occurred. |
| street_address | VARCHAR | Variable | Optional | Street or specific address of the incident. |
| patient_name | VARCHAR | Variable | Optional | Name of the patient or involved person. |
| status | VARCHAR | Variable | Not Null | Current status of the accident case. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the case. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the case. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the case was created. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the case was last updated. |

## Table: medical_reports

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| report_id | VARCHAR | Variable | Primary Key, Not Null | Unique identifier of the medical report. |
| case_id | VARCHAR | Variable | Foreign Key, Optional | Related accident case identifier. |
| case_number | VARCHAR | Variable | Optional | Case number connected to the medical report. |
| case_date | VARCHAR | Variable | Optional | Date of the medical case report. |
| case_time | VARCHAR | Variable | Optional | Time of the medical case report. |
| patient_name | VARCHAR | Variable | Optional | Name of the patient assisted by medical responders. |
| age | INTEGER | 32-bit | Optional | Age of the patient. |
| gender | VARCHAR | Variable | Optional | Gender of the patient. |
| birthdate | VARCHAR | Variable | Optional | Birthdate of the patient. |
| location | VARCHAR | Variable | Optional | Location where the medical case occurred. |
| address | VARCHAR | Variable | Optional | Address of the patient or incident. |
| contact_number | VARCHAR | Variable | Optional | Contact number related to the medical case. |
| case_type | VARCHAR | Variable | Optional | Type of medical case. |
| vital_signs | VARCHAR | Variable | Optional | Recorded vital signs of the patient. |
| service_provided | VARCHAR | Variable | Optional | Medical service or assistance provided. |
| vehicle_used | VARCHAR | Variable | Optional | Vehicle used by the medical response team. |
| team_leader | VARCHAR | Variable | Optional | Team leader assigned to the medical response. |
| status | VARCHAR | Variable | Not Null | Current status of the medical report. |
| draft | BOOLEAN | True/False | Not Null | Indicates whether the report is saved as draft. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the report. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the report. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was created. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was last updated. |

## Table: fire_reports

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| report_id | VARCHAR | Variable | Primary Key, Not Null | Unique identifier of the fire report. |
| case_id | VARCHAR | Variable | Foreign Key, Optional | Related accident case identifier. |
| location | VARCHAR | Variable | Optional | Location of the fire incident. |
| date_started | DATE | YYYY-MM-DD | Optional | Date when the fire incident started. |
| time_started | VARCHAR | Variable | Optional | Time when the fire incident started. |
| time_ended | VARCHAR | Variable | Optional | Time when the fire incident ended. |
| cause_of_fire | VARCHAR | Variable | Optional | Reported or investigated cause of fire. |
| origin_of_fire | VARCHAR | Variable | Optional | Area or source where the fire started. |
| number_of_deaths | INTEGER | 32-bit | Optional | Number of reported deaths. |
| number_of_injuries | INTEGER | 32-bit | Optional | Number of reported injuries. |
| estimated_cost_of_damage | DOUBLE PRECISION | Decimal | Optional | Estimated monetary damage caused by the fire. |
| establishments_or_houses_burned | INTEGER | 32-bit | Optional | Number of establishments or houses burned. |
| families_affected | INTEGER | 32-bit | Optional | Number of families affected by the fire. |
| investigator_on_case | VARCHAR | Variable | Optional | Investigator assigned to the fire case. |
| fireground_commander | VARCHAR | Variable | Optional | Fireground commander assigned to the response. |
| total_people_affected | INTEGER | 32-bit | Optional | Total number of people affected by the fire. |
| remarks | VARCHAR | Variable | Optional | Additional remarks about the fire incident. |
| status | VARCHAR | Variable | Not Null | Current status of the fire report. |
| draft | BOOLEAN | True/False | Not Null | Indicates whether the report is saved as draft. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the report. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the report. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was created. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was last updated. |

## Table: traffic_reports

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| report_id | VARCHAR | Variable | Primary Key, Not Null | Unique identifier of the traffic report. |
| case_id | VARCHAR | Variable | Foreign Key, Optional | Related accident case identifier. |
| responder_name | VARCHAR | Variable | Optional | Name of the responder who created the traffic report. |
| accident_date | VARCHAR | Variable | Optional | Date of the traffic accident. |
| accident_time | VARCHAR | Variable | Optional | Time of the traffic accident. |
| address | VARCHAR | Variable | Optional | Address where the traffic accident occurred. |
| barangay | VARCHAR | Variable | Optional | Barangay where the traffic accident occurred. |
| vehicles_involved | INTEGER | 32-bit | Optional | Number of vehicles involved in the accident. |
| versus_another_vehicle | BOOLEAN | True/False | Not Null | Indicates involvement with another vehicle. |
| versus_pedestrian | BOOLEAN | True/False | Not Null | Indicates involvement with a pedestrian. |
| versus_fixed_object | BOOLEAN | True/False | Not Null | Indicates collision with a fixed object. |
| versus_animal | BOOLEAN | True/False | Not Null | Indicates involvement with an animal. |
| type_fatal | BOOLEAN | True/False | Not Null | Indicates whether the traffic case is fatal. |
| type_non_fatal | BOOLEAN | True/False | Not Null | Indicates whether the traffic case is non-fatal. |
| type_damage_to_property | BOOLEAN | True/False | Not Null | Indicates damage-to-property classification. |
| type_rear_end | BOOLEAN | True/False | Not Null | Indicates rear-end collision type. |
| type_side_swipe_same_direction | BOOLEAN | True/False | Not Null | Indicates side-swipe collision in the same direction. |
| type_head_on | BOOLEAN | True/False | Not Null | Indicates head-on collision type. |
| type_angle | BOOLEAN | True/False | Not Null | Indicates angle collision type. |
| type_side_swipe_opposite_direction | BOOLEAN | True/False | Not Null | Indicates side-swipe collision in the opposite direction. |
| type_hit_and_run | BOOLEAN | True/False | Not Null | Indicates hit-and-run case type. |
| type_roll_over | BOOLEAN | True/False | Not Null | Indicates roll-over case type. |
| type_multiple_vehicle_collision | BOOLEAN | True/False | Not Null | Indicates multiple-vehicle collision type. |
| type_single_vehicle_accident | BOOLEAN | True/False | Not Null | Indicates single-vehicle accident type. |
| involved_vehicles | VARCHAR | Variable | Optional | Details of vehicles involved in the traffic accident. |
| notes | VARCHAR | Variable | Optional | Additional notes about the traffic accident. |
| status | VARCHAR | Variable | Not Null | Current status of the traffic report. |
| draft | BOOLEAN | True/False | Not Null | Indicates whether the report is saved as draft. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the report. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the report. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was created. |
| updated_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was last updated. |

## Table: accident_cases_archive

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| case_id | VARCHAR | Variable | Primary Key, Foreign Key, Not Null | Archived accident case identifier. |
| case_number | VARCHAR | Variable | Optional | Case number of the archived accident case. |
| case_type | VARCHAR | Variable | Not Null | Type of archived accident case. |
| location | VARCHAR | Variable | Not Null | Location of the archived accident case. |
| barangay | VARCHAR | Variable | Optional | Barangay of the archived accident case. |
| status | VARCHAR | Variable | Not Null | Status of the archived accident case. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the original case. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the original case. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the original case was created. |
| archived_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who archived the case. |
| archived_by_name | VARCHAR | Variable | Not Null | Name of the user who archived the case. |
| archived_at | TIMESTAMP | Date and Time | Not Null | Date and time when the case was archived. |
| archive_reason | VARCHAR | Variable | Not Null | Reason for archiving the case. |

## Table: medical_reports_archive

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| report_id | VARCHAR | Variable | Primary Key, Foreign Key, Not Null | Archived medical report identifier. |
| case_id | VARCHAR | Variable | Foreign Key, Optional | Related accident case identifier. |
| case_number | VARCHAR | Variable | Optional | Case number connected to the archived medical report. |
| patient_name | VARCHAR | Variable | Optional | Name of the patient in the archived medical report. |
| case_type | VARCHAR | Variable | Optional | Type of archived medical case. |
| status | VARCHAR | Variable | Not Null | Status of the archived medical report. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the original report. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the original report. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the original report was created. |
| archived_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who archived the report. |
| archived_by_name | VARCHAR | Variable | Not Null | Name of the user who archived the report. |
| archived_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was archived. |
| archive_reason | VARCHAR | Variable | Not Null | Reason for archiving the medical report. |

## Table: fire_reports_archive

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| report_id | VARCHAR | Variable | Primary Key, Foreign Key, Not Null | Archived fire report identifier. |
| case_id | VARCHAR | Variable | Foreign Key, Optional | Related accident case identifier. |
| location | VARCHAR | Variable | Optional | Location of the archived fire incident. |
| date_started | DATE | YYYY-MM-DD | Optional | Date when the archived fire incident started. |
| cause_of_fire | VARCHAR | Variable | Optional | Cause of the archived fire incident. |
| status | VARCHAR | Variable | Not Null | Status of the archived fire report. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the original report. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the original report. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the original report was created. |
| archived_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who archived the report. |
| archived_by_name | VARCHAR | Variable | Not Null | Name of the user who archived the report. |
| archived_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was archived. |
| archive_reason | VARCHAR | Variable | Not Null | Reason for archiving the fire report. |

## Table: traffic_reports_archive

| Field Name | Data Type | Length | Constraints | Description |
|---|---|---:|---|---|
| report_id | VARCHAR | Variable | Primary Key, Foreign Key, Not Null | Archived traffic report identifier. |
| case_id | VARCHAR | Variable | Foreign Key, Optional | Related accident case identifier. |
| responder_name | VARCHAR | Variable | Optional | Name of the responder who created the original report. |
| accident_date | VARCHAR | Variable | Optional | Date of the archived traffic accident. |
| address | VARCHAR | Variable | Optional | Address where the archived traffic accident occurred. |
| barangay | VARCHAR | Variable | Optional | Barangay where the archived traffic accident occurred. |
| status | VARCHAR | Variable | Not Null | Status of the archived traffic report. |
| created_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who created the original report. |
| created_by_name | VARCHAR | Variable | Not Null | Name of the user who created the original report. |
| created_at | TIMESTAMP | Date and Time | Not Null | Date and time when the original report was created. |
| archived_by_cedoc_id | VARCHAR | Variable | Foreign Key, Not Null | CEDOC ID of the user who archived the report. |
| archived_by_name | VARCHAR | Variable | Not Null | Name of the user who archived the report. |
| archived_at | TIMESTAMP | Date and Time | Not Null | Date and time when the report was archived. |
| archive_reason | VARCHAR | Variable | Not Null | Reason for archiving the traffic report. |
