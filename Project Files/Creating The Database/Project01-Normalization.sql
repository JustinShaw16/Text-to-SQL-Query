SET statement_timeout = '10min';

-- Refresh by dropping old tables
DROP TABLE IF EXISTS DenialReason;
DROP TABLE IF EXISTS CoApplicantRace;
DROP TABLE IF EXISTS ApplicantRace;
DROP TABLE IF EXISTS Application;
DROP TABLE IF EXISTS StateInfo;
DROP TABLE IF EXISTS EditStatusMap;
DROP TABLE IF EXISTS LienMap;
DROP TABLE IF EXISTS HoepaMap;
DROP TABLE IF EXISTS PurchaserMap;
DROP TABLE IF EXISTS ActionTakenMap;
DROP TABLE IF EXISTS PreapprovalMap;
DROP TABLE IF EXISTS OwnerOccupancyMap;
DROP TABLE IF EXISTS LoanPurposeMap;
DROP TABLE IF EXISTS PropertyTypeMap;
DROP TABLE IF EXISTS LoanTypeMap;
DROP TABLE IF EXISTS AgencyMap;
DROP TABLE IF EXISTS Location;

-- Agency 
CREATE TABLE AgencyMap (
   agency_code INTEGER PRIMARY KEY CHECK (agency_code IN (1,2,3,5,7,9)),
   agency_name TEXT NOT NULL,
   agency_abbr TEXT NOT NULL
);
INSERT INTO AgencyMap(agency_code, agency_name, agency_abbr)
  SELECT DISTINCT CAST(NULLIF(btrim(P.agency_code::text), '') AS INTEGER),
                  P.agency_name,
                  P.agency_abbr
  FROM preliminary P
  WHERE btrim(P.agency_code::text) <> '';

-- Loan Type 
CREATE TABLE LoanTypeMap (
   loan_type INTEGER PRIMARY KEY CHECK (loan_type IN (1,2,3,4)),
   loan_type_name TEXT NOT NULL
);
INSERT INTO LoanTypeMap(loan_type, loan_type_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.loan_type::text), '') AS INTEGER),
                  P.loan_type_name
  FROM preliminary P
  WHERE btrim(P.loan_type::text) <> '';

-- Property Type 
CREATE TABLE PropertyTypeMap (
   property_type INTEGER PRIMARY KEY,
   property_type_name TEXT NOT NULL
);
INSERT INTO PropertyTypeMap(property_type, property_type_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.property_type::text), '') AS INTEGER),
                  P.property_type_name
  FROM preliminary P
  WHERE btrim(P.property_type::text) <> '';

-- Loan Purpose 
CREATE TABLE LoanPurposeMap (
   loan_purpose INTEGER PRIMARY KEY CHECK (loan_purpose IN (1,2,3)),
   loan_purpose_name TEXT NOT NULL
);
INSERT INTO LoanPurposeMap(loan_purpose, loan_purpose_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.loan_purpose::text), '') AS INTEGER),
                  P.loan_purpose_name
  FROM preliminary P
  WHERE btrim(P.loan_purpose::text) <> '';

-- Owner Occupancy 
CREATE TABLE OwnerOccupancyMap (
   owner_occupancy INTEGER PRIMARY KEY,
   owner_occupancy_name TEXT NOT NULL
);
INSERT INTO OwnerOccupancyMap(owner_occupancy, owner_occupancy_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.owner_occupancy::text), '') AS INTEGER),
                  P.owner_occupancy_name
  FROM preliminary P
  WHERE btrim(P.owner_occupancy::text) <> '';

-- Preapproval 
CREATE TABLE PreapprovalMap (
   preapproval INTEGER PRIMARY KEY CHECK (preapproval IN (1,2,3)),
   preapproval_name TEXT NOT NULL
);
INSERT INTO PreapprovalMap(preapproval, preapproval_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.preapproval::text), '') AS INTEGER),
                  P.preapproval_name
  FROM preliminary P
  WHERE btrim(P.preapproval::text) <> '';

-- Action Taken 
CREATE TABLE ActionTakenMap (
   action_taken INTEGER PRIMARY KEY,
   action_taken_name TEXT NOT NULL
);
INSERT INTO ActionTakenMap(action_taken, action_taken_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.action_taken::text), '') AS INTEGER),
                  P.action_taken_name
  FROM preliminary P
  WHERE btrim(P.action_taken::text) <> '';

-- Purchaser 
CREATE TABLE PurchaserMap (
   purchaser_type INTEGER PRIMARY KEY CHECK (purchaser_type IN (0,1,2,3,4,5,6,7,8,9)),
   purchaser_type_name TEXT NOT NULL
);
INSERT INTO PurchaserMap(purchaser_type, purchaser_type_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.purchaser_type::text), '') AS INTEGER),
                  P.purchaser_type_name
  FROM preliminary P
  WHERE btrim(P.purchaser_type::text) <> '';

-- Hoepa
CREATE TABLE HoepaMap (
   hoepa_status INTEGER PRIMARY KEY CHECK (hoepa_status IN (1,2)),
   hoepa_status_name TEXT NOT NULL
);
INSERT INTO HoepaMap(hoepa_status, hoepa_status_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.hoepa_status::text), '') AS INTEGER),
                  P.hoepa_status_name
  FROM preliminary P
  WHERE btrim(P.hoepa_status::text) <> '';

-- Lien
CREATE TABLE LienMap (
   lien_status INTEGER PRIMARY KEY,
   lien_status_name TEXT NOT NULL
);
INSERT INTO LienMap(lien_status, lien_status_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.lien_status::text), '') AS INTEGER),
                  P.lien_status_name
  FROM preliminary P
  WHERE btrim(P.lien_status::text) <> '';

-- Edit Status 
CREATE TABLE EditStatusMap (
   edit_status INTEGER PRIMARY KEY,
   edit_status_name TEXT NOT NULL
);
INSERT INTO EditStatusMap(edit_status, edit_status_name)
  SELECT DISTINCT CAST(NULLIF(btrim(P.edit_status::text), '') AS INTEGER),
                  P.edit_status_name
  FROM preliminary P
  WHERE btrim(P.edit_status::text) <> '';

-- State Info (for state_code, state_name, state_abbr)
CREATE TABLE StateInfo (
   state_code INTEGER PRIMARY KEY,
   state_name TEXT NOT NULL,
   state_abbr TEXT NOT NULL
);
INSERT INTO StateInfo(state_code, state_name, state_abbr)
  SELECT DISTINCT CAST(NULLIF(btrim(P.state_code::text), '') AS INTEGER),
                  P.state_name,
                  P.state_abbr
  FROM preliminary P
  WHERE btrim(P.state_code::text) <> '';

-- Location Table
CREATE TABLE Location (
   location_id SERIAL PRIMARY KEY,
   msamd INTEGER,
   msamd_name TEXT,
   state_code INTEGER NOT NULL,
   census_tract_number TEXT NOT NULL,
   county_code INTEGER,
   county_name TEXT,
   population INTEGER,
   minority_population DECIMAL(5,2),
   hud_median_family_income DECIMAL(12,2),
   tract_to_msamd_income DECIMAL(10,2),
   number_of_owner_occupied_units INTEGER,
   number_of_1_to_4_family_units INTEGER,
   CONSTRAINT uc_location UNIQUE(msamd, state_code, census_tract_number, county_code, 
      population, minority_population, hud_median_family_income, tract_to_msamd_income,
      number_of_owner_occupied_units, number_of_1_to_4_family_units)
);
INSERT INTO Location(
   msamd, msamd_name, state_code, census_tract_number, county_code, county_name,
   population, minority_population, hud_median_family_income, tract_to_msamd_income,
   number_of_owner_occupied_units, number_of_1_to_4_family_units
)
SELECT DISTINCT
   CAST(NULLIF(btrim(P.msamd::text), '') AS INTEGER),
   P.msamd_name,
   CAST(NULLIF(btrim(P.state_code::text), '') AS INTEGER),
   P.census_tract_number,
   CAST(NULLIF(btrim(P.county_code::text), '') AS INTEGER),
   P.county_name,
   CAST(NULLIF(btrim(P.population::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.minority_population::text), '') AS DECIMAL(5,2)),
   CAST(NULLIF(btrim(P.hud_median_family_income::text), '') AS DECIMAL(12,2)),
   CAST(NULLIF(btrim(P.tract_to_msamd_income::text), '') AS DECIMAL(10,2)),
   CAST(NULLIF(btrim(P.number_of_owner_occupied_units::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.number_of_1_to_4_family_units::text), '') AS INTEGER)
FROM preliminary P;

-- Main Application Table
CREATE TABLE Application (
   application_id SERIAL PRIMARY KEY,
   id INTEGER NOT NULL,
   as_of_year INTEGER NOT NULL,
   respondent_id TEXT NOT NULL,
   loan_amount_000s DECIMAL(12,2),
   applicant_ethnicity_name TEXT NOT NULL,
   applicant_ethnicity INTEGER NOT NULL,
   co_applicant_ethnicity_name TEXT,
   co_applicant_ethnicity INTEGER,
   applicant_sex_name TEXT NOT NULL,
   applicant_sex INTEGER NOT NULL,
   co_applicant_sex_name TEXT,
   co_applicant_sex INTEGER,
   applicant_income_000s DECIMAL(12,2),
   rate_spread DECIMAL(12,2),
   sequence_number INTEGER,
   application_date_indicator INTEGER,
   agency_code INTEGER NOT NULL,
   loan_type INTEGER NOT NULL,
   property_type INTEGER NOT NULL,
   loan_purpose INTEGER NOT NULL,
   owner_occupancy INTEGER NOT NULL,
   preapproval INTEGER NOT NULL,
   action_taken INTEGER NOT NULL,
   purchaser_type INTEGER NOT NULL,
   hoepa_status INTEGER NOT NULL,
   lien_status INTEGER NOT NULL,
   edit_status INTEGER,
   state_code INTEGER NOT NULL,
   location_id INTEGER,
   CONSTRAINT fk_agency FOREIGN KEY (agency_code) REFERENCES AgencyMap(agency_code),
   CONSTRAINT fk_loan_type FOREIGN KEY (loan_type) REFERENCES LoanTypeMap(loan_type),
   CONSTRAINT fk_property_type FOREIGN KEY (property_type) REFERENCES PropertyTypeMap(property_type),
   CONSTRAINT fk_loan_purpose FOREIGN KEY (loan_purpose) REFERENCES LoanPurposeMap(loan_purpose),
   CONSTRAINT fk_owner_occupancy FOREIGN KEY (owner_occupancy) REFERENCES OwnerOccupancyMap(owner_occupancy),
   CONSTRAINT fk_preapproval FOREIGN KEY (preapproval) REFERENCES PreapprovalMap(preapproval),
   CONSTRAINT fk_action_taken FOREIGN KEY (action_taken) REFERENCES ActionTakenMap(action_taken),
   CONSTRAINT fk_purchaser FOREIGN KEY (purchaser_type) REFERENCES PurchaserMap(purchaser_type),
   CONSTRAINT fk_hoepa FOREIGN KEY (hoepa_status) REFERENCES HoepaMap(hoepa_status),
   CONSTRAINT fk_lien FOREIGN KEY (lien_status) REFERENCES LienMap(lien_status),
   CONSTRAINT fk_edit_status FOREIGN KEY (edit_status) REFERENCES EditStatusMap(edit_status),
   CONSTRAINT fk_state_info FOREIGN KEY (state_code) REFERENCES StateInfo(state_code),
   CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES Location(location_id)
);
INSERT INTO Application(
   as_of_year, respondent_id, loan_amount_000s, applicant_ethnicity_name, applicant_ethnicity,
   co_applicant_ethnicity_name, co_applicant_ethnicity, applicant_sex_name, applicant_sex,
   co_applicant_sex_name, co_applicant_sex, applicant_income_000s, rate_spread, sequence_number,
   application_date_indicator, agency_code, loan_type, property_type, loan_purpose, owner_occupancy,
   preapproval, action_taken, purchaser_type, hoepa_status, lien_status, edit_status, state_code,
   location_id, id
)
SELECT
   CAST(NULLIF(btrim(P.as_of_year::text), '') AS INTEGER),
   P.respondent_id,
   CAST(NULLIF(btrim(P.loan_amount_000s::text), '') AS DECIMAL(12,2)),
   P.applicant_ethnicity_name,
   CAST(NULLIF(btrim(P.applicant_ethnicity::text), '') AS INTEGER),
   P.co_applicant_ethnicity_name,
   CAST(NULLIF(btrim(P.co_applicant_ethnicity::text), '') AS INTEGER),
   P.applicant_sex_name,
   CAST(NULLIF(btrim(P.applicant_sex::text), '') AS INTEGER),
   P.co_applicant_sex_name,
   CAST(NULLIF(btrim(P.co_applicant_sex::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.applicant_income_000s::text), '') AS DECIMAL(12,2)),
   CAST(NULLIF(btrim(P.rate_spread::text), '') AS DECIMAL(12,2)),
   CAST(NULLIF(btrim(P.sequence_number::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.application_date_indicator::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.agency_code::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.loan_type::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.property_type::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.loan_purpose::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.owner_occupancy::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.preapproval::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.action_taken::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.purchaser_type::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.hoepa_status::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.lien_status::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.edit_status::text), '') AS INTEGER),
   CAST(NULLIF(btrim(P.state_code::text), '') AS INTEGER),
   L.location_id,
   CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER)
FROM preliminary P
JOIN Location L ON
   CAST(NULLIF(btrim(P.msamd::text), '') AS INTEGER) IS NOT DISTINCT FROM L.msamd
   AND CAST(NULLIF(btrim(P.state_code::text), '') AS INTEGER) = L.state_code
   AND P.census_tract_number IS NOT DISTINCT FROM L.census_tract_number
   AND CAST(NULLIF(btrim(P.county_code::text), '') AS INTEGER) IS NOT DISTINCT FROM L.county_code
   AND CAST(NULLIF(btrim(P.population::text), '') AS INTEGER) IS NOT DISTINCT FROM L.population
   AND CAST(NULLIF(btrim(P.minority_population::text), '') AS DECIMAL(5,2)) IS NOT DISTINCT FROM L.minority_population
   AND CAST(NULLIF(btrim(P.hud_median_family_income::text), '') AS DECIMAL(12,2)) IS NOT DISTINCT FROM L.hud_median_family_income
   AND CAST(NULLIF(btrim(P.tract_to_msamd_income::text), '') AS DECIMAL(10,2)) IS NOT DISTINCT FROM L.tract_to_msamd_income
   AND CAST(NULLIF(btrim(P.number_of_owner_occupied_units::text), '') AS INTEGER) IS NOT DISTINCT FROM L.number_of_owner_occupied_units
   AND CAST(NULLIF(btrim(P.number_of_1_to_4_family_units::text), '') AS INTEGER) IS NOT DISTINCT FROM L.number_of_1_to_4_family_units;

-- Applicant Race
CREATE TABLE ApplicantRace (
   application_id INTEGER NOT NULL,
   race_order INTEGER NOT NULL,  -- 1 to 5
   applicant_race INTEGER NOT NULL,
   applicant_race_name TEXT NOT NULL,
   PRIMARY KEY (application_id, race_order),
   CONSTRAINT fk_applicant_race_app FOREIGN KEY (application_id) REFERENCES Application(application_id)
);
INSERT INTO ApplicantRace (application_id, race_order, applicant_race, applicant_race_name)
  SELECT A.application_id, 1,
         CAST(NULLIF(btrim(P.applicant_race_1::text), '') AS INTEGER),
         P.applicant_race_name_1
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.applicant_race_1::text) <> '';
INSERT INTO ApplicantRace (application_id, race_order, applicant_race, applicant_race_name)
  SELECT A.application_id, 2,
         CAST(NULLIF(btrim(P.applicant_race_2::text), '') AS INTEGER),
         P.applicant_race_name_2
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.applicant_race_2::text) <> '';
INSERT INTO ApplicantRace (application_id, race_order, applicant_race, applicant_race_name)
  SELECT A.application_id, 3,
         CAST(NULLIF(btrim(P.applicant_race_3::text), '') AS INTEGER),
         P.applicant_race_name_3
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.applicant_race_3::text) <> '';
INSERT INTO ApplicantRace (application_id, race_order, applicant_race, applicant_race_name)
  SELECT A.application_id, 4,
         CAST(NULLIF(btrim(P.applicant_race_4::text), '') AS INTEGER),
         P.applicant_race_name_4
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.applicant_race_4::text) <> '';
INSERT INTO ApplicantRace (application_id, race_order, applicant_race, applicant_race_name)
  SELECT A.application_id, 5,
         CAST(NULLIF(btrim(P.applicant_race_5::text), '') AS INTEGER),
         P.applicant_race_name_5
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.applicant_race_5::text) <> '';

-- CoApplicant Race
CREATE TABLE CoApplicantRace (
   application_id INTEGER NOT NULL,
   race_order INTEGER NOT NULL,  -- 1 to 5
   co_applicant_race INTEGER NOT NULL,
   co_applicant_race_name TEXT NOT NULL,
   PRIMARY KEY (application_id, race_order),
   CONSTRAINT fk_co_applicant_race_app FOREIGN KEY (application_id) REFERENCES Application(application_id)
);
INSERT INTO CoApplicantRace (application_id, race_order, co_applicant_race, co_applicant_race_name)
  SELECT A.application_id, 1,
         CAST(NULLIF(btrim(P.co_applicant_race_1::text), '') AS INTEGER),
         P.co_applicant_race_name_1
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.co_applicant_race_1::text) <> '';
INSERT INTO CoApplicantRace (application_id, race_order, co_applicant_race, co_applicant_race_name)
  SELECT A.application_id, 2,
         CAST(NULLIF(btrim(P.co_applicant_race_2::text), '') AS INTEGER),
         P.co_applicant_race_name_2
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.co_applicant_race_2::text) <> '';
INSERT INTO CoApplicantRace (application_id, race_order, co_applicant_race, co_applicant_race_name)
  SELECT A.application_id, 3,
         CAST(NULLIF(btrim(P.co_applicant_race_3::text), '') AS INTEGER),
         P.co_applicant_race_name_3
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.co_applicant_race_3::text) <> '';
INSERT INTO CoApplicantRace (application_id, race_order, co_applicant_race, co_applicant_race_name)
  SELECT A.application_id, 4,
         CAST(NULLIF(btrim(P.co_applicant_race_4::text), '') AS INTEGER),
         P.co_applicant_race_name_4
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.co_applicant_race_4::text) <> '';
INSERT INTO CoApplicantRace (application_id, race_order, co_applicant_race, co_applicant_race_name)
  SELECT A.application_id, 5,
         CAST(NULLIF(btrim(P.co_applicant_race_5::text), '') AS INTEGER),
         P.co_applicant_race_name_5
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.co_applicant_race_5::text) <> '';

-- Denial Reasons
CREATE TABLE DenialReason (
   application_id INTEGER NOT NULL,
   reason_order INTEGER NOT NULL,  -- 1 to 3
   denial_reason INTEGER NOT NULL,
   denial_reason_name TEXT NOT NULL,
   PRIMARY KEY (application_id, reason_order),
   CONSTRAINT fk_denial_reason_app FOREIGN KEY (application_id) REFERENCES Application(application_id)
);
INSERT INTO DenialReason (application_id, reason_order, denial_reason, denial_reason_name)
  SELECT A.application_id, 1,
         CAST(NULLIF(btrim(P.denial_reason_1::text), '') AS INTEGER),
         P.denial_reason_name_1
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.denial_reason_1::text) <> '';
INSERT INTO DenialReason (application_id, reason_order, denial_reason, denial_reason_name)
  SELECT A.application_id, 2,
         CAST(NULLIF(btrim(P.denial_reason_2::text), '') AS INTEGER),
         P.denial_reason_name_2
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.denial_reason_2::text) <> '';
INSERT INTO DenialReason (application_id, reason_order, denial_reason, denial_reason_name)
  SELECT A.application_id, 3,
         CAST(NULLIF(btrim(P.denial_reason_3::text), '') AS INTEGER),
         P.denial_reason_name_3
  FROM preliminary P
  JOIN Application A ON CAST(NULLIF(btrim(P.temp_id::text), '') AS INTEGER) = A.id
  WHERE btrim(P.denial_reason_3::text) <> '';
