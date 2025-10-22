CREATE TABLE AgencyMap (
  agency_code INTEGER PRIMARY KEY,
  agency_name TEXT NOT NULL,
  agency_abbr TEXT NOT NULL
);

CREATE TABLE LoanTypeMap (
  loan_type INTEGER PRIMARY KEY,
  loan_type_name TEXT NOT NULL
);

CREATE TABLE Application (
  application_id SERIAL PRIMARY KEY,
  agency_code INTEGER REFERENCES AgencyMap(agency_code),
  loan_type INTEGER REFERENCES LoanTypeMap(loan_type),
  applicant_income_000s INTEGER,
  loan_amount_000s INTEGER,
);

INSERT INTO AgencyMap (agency_code, agency_name, agency_abbr) VALUES
(1, 'Office of the Comptroller of the Currency', 'OCC'),
(2, 'Federal Reserve System', 'FRS');

INSERT INTO LoanTypeMap (loan_type, loan_type_name) VALUES
(1, 'Conventional'),
(2, 'FHA-Insured');

INSERT INTO Application (agency_code, loan_type, applicant_income_000s, loan_amount_000s) VALUES
(1, 1, 60000, 250000),
(2, 2, 40000, 180000);